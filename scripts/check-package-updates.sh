#!/usr/bin/env bash
# swift-app-monetization に、手元で使っている版より新しい版がないかを確認する。
#
# 使い方: check-package-updates.sh [--strict] [--root DIR]
#   既定は警告だけを出して正常終了する。--strict は、古い版があればエラー（終了コード 1）にする。
#   このパッケージに依存していない場合と、ネットワークに届かない場合は、何も表示せず正常終了する。
#
# 手元の版は、Package.resolved と、xcodebuild のビルドキャッシュ（workspace-state.json）で確認する。
# 後者は、`make ios` や `make deploy` が実際に使う版で、Package.resolved より古いままになることがある。
set -euo pipefail

PACKAGE_NAME="swift-app-monetization"
PACKAGE_URL="${PACKAGE_UPDATE_URL:-ssh://git@github.com/y-marui/swift-app-monetization.git}"

strict=false
root=""
while [ $# -gt 0 ]; do
  case "$1" in
    --strict) strict=true ;;
    --root)
      root="${2:?--root にはディレクトリを指定してください}"
      shift
      ;;
    *)
      echo "不明なオプション: $1" >&2
      exit 2
      ;;
  esac
  shift
done
if [ -z "$root" ]; then
  root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

declared=false
for file in "$root/Packages/Core/Package.swift" "$root/Package.swift" "$root/project.yml"; do
  if [ -f "$file" ] && grep -q "$PACKAGE_NAME" "$file"; then
    declared=true
    break
  fi
done
if [ "$declared" != true ] || ! command -v python3 >/dev/null 2>&1; then
  exit 0
fi

# 手元で固定されている版を「ファイル<TAB>リビジョン<TAB>バージョン<TAB>ブランチ」で列挙する。
pins="$(python3 - "$root" "$PACKAGE_NAME" <<'PY' || true
import glob
import json
import os
import sys

root, name = sys.argv[1], sys.argv[2]


def emit(path, revision, version, branch):
    # 空の欄はシェルの read が詰めてしまうため、"-" で埋める
    print("\t".join([os.path.relpath(path, root), revision or "-", version or "-", branch or "-"]))


def matches(identity, location):
    return name in (identity or "") or name in (location or "")


for path in (f"{root}/Package.resolved", f"{root}/Packages/Core/Package.resolved"):
    if os.path.isfile(path):
        for pin in json.load(open(path)).get("pins", []):
            if matches(pin.get("identity"), pin.get("location")):
                state = pin.get("state", {})
                emit(path, state.get("revision"), state.get("version"), state.get("branch"))

patterns = [
    f"{root}/build*/SourcePackages/workspace-state.json",
    f"{root}/DerivedData/*/SourcePackages/workspace-state.json",
]
for pattern in patterns:
    for path in glob.glob(pattern):
        for dep in json.load(open(path)).get("object", {}).get("dependencies", []):
            ref = dep.get("packageRef", {})
            if matches(ref.get("identity"), ref.get("location")):
                state = dep.get("state", {}).get("checkoutState", {})
                emit(path, state.get("revision"), state.get("version"), state.get("branch"))
PY
)"
if [ -z "$pins" ]; then
  exit 0
fi

# ネットワークに届かないとき（オフライン・鍵がない等）は、黙ってスキップする。
export GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=10"
export GIT_TERMINAL_PROMPT=0

latest_revision() {
  { git ls-remote "$PACKAGE_URL" "refs/heads/$1" 2>/dev/null || true; } | awk 'NR == 1 { print $1 }'
}

latest_tag() {
  { git ls-remote --tags --refs "$PACKAGE_URL" 'v*' 2>/dev/null || true; } \
    | sed -e 's|.*refs/tags/v||' | sort -t. -k1,1n -k2,2n -k3,3n | tail -n 1
}

messages=""
while IFS=$'\t' read -r file revision version branch; do
  [ "$revision" = "-" ] && revision=""
  [ "$version" = "-" ] && version=""
  [ "$branch" = "-" ] && branch=""
  if [ -n "$branch" ]; then
    latest="$(latest_revision "$branch")"
    if [ -n "$latest" ] && [ "$latest" != "$revision" ]; then
      messages+="  ${file}: ${revision:0:7} → ${latest:0:7}（${branch}）"$'\n'
    fi
  elif [ -n "$version" ]; then
    latest="$(latest_tag)"
    if [ -n "$latest" ] && [ "$latest" != "$version" ]; then
      messages+="  ${file}: ${version} → ${latest}（依存の要件の範囲外の可能性があります）"$'\n'
    fi
  fi
done <<<"$pins"

if [ -z "$messages" ]; then
  exit 0
fi

if [ "$strict" = true ]; then
  label="エラー"
else
  label="警告"
fi
{
  echo "${label}: ${PACKAGE_NAME} に新しい版があります。"
  printf '%s' "$messages"
  echo "  make update-packages を実行してください。"
} >&2

if [ "$strict" = true ]; then
  exit 1
fi
