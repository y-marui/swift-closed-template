#!/usr/bin/env bash
# swift-app-monetization を、最新の版に更新する。
#
# 1. Package.resolved（Packages/Core とルート）を更新する
# 2. xcodebuild のビルドキャッシュに残った、古い版の固定情報を削除する
#    （`make ios` や `make deploy` は build/SourcePackages の固定情報を使うため、これを消さないと反映されない）
# 次のビルドで、最新の版を取り込み直す。
set -euo pipefail

PACKAGE_NAME="swift-app-monetization"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

declared=false
for file in Packages/Core/Package.swift Package.swift project.yml; do
  if [ -f "$file" ] && grep -q "$PACKAGE_NAME" "$file"; then
    declared=true
    break
  fi
done
if [ "$declared" != true ]; then
  echo "${PACKAGE_NAME} に依存していないため、何もしません。"
  exit 0
fi

for dir in Packages/Core .; do
  if [ -f "$dir/Package.swift" ] && { [ -f "$dir/Package.resolved" ] || grep -q "$PACKAGE_NAME" "$dir/Package.swift"; }; then
    echo "==> swift package update ${PACKAGE_NAME} (${dir})"
    (cd "$dir" && swift package update "$PACKAGE_NAME")
  fi
done

removed=0
for cache in build*/SourcePackages DerivedData/*/SourcePackages; do
  # glob が一致しなかった場合は、パターンの文字列がそのまま入る
  if [ -d "$cache/checkouts/$PACKAGE_NAME" ]; then
    echo "==> ビルドキャッシュを削除: ${cache}"
    rm -rf "$cache"
    removed=$((removed + 1))
  fi
done
if [ "$removed" -eq 0 ]; then
  echo "==> 削除するビルドキャッシュはありません"
fi

echo "完了。次のビルドで、最新の版を取り込みます。"
