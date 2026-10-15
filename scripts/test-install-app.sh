#!/usr/bin/env bash
# Regression test for scripts/install-app.sh. Everything happens in a temporary folder, so the real
# /Applications and any running app are never touched. macOS only (PlistBuddy, ditto).
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
  echo "skip: install-app.sh is macOS only"
  exit 0
fi

SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install-app.sh"
WORK="$(mktemp -d)"
FAILURES=0
trap 'rm -rf "$WORK"' EXIT

check() {
  local label="$1"
  shift
  if "$@"; then echo "ok   - $label"; else echo "FAIL - $label"; FAILURES=$((FAILURES + 1)); fi
}
exists() { [[ -d "$1" ]]; }
missing() { [[ ! -e "$1" ]]; }
contains() { [[ "$1" == *"$2"* ]]; }

make_app() { # parent name bundle-id [mas]
  mkdir -p "$1/$2.app/Contents"
  cat > "$1/$2.app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0"><dict><key>CFBundleIdentifier</key><string>$3</string></dict></plist>
PLIST
  [[ "${4:-}" == mas ]] && mkdir -p "$1/$2.app/Contents/_MASReceipt"
  return 0
}

fresh() { rm -rf "$WORK/root"; mkdir -p "$WORK/root" "$WORK/build"; rm -rf "$WORK/build"/*; }
bundle_id() { /usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$1/Contents/Info.plist"; }
ROOT="$WORK/root"
DEPLOY="$ROOT/My Swift"
# The old folder is the Applications root; the tests point it at a temporary folder.
run_install() { bash "$SCRIPT" "$1" "$2" "$3" "$4" "$ROOT"; }

fresh
make_app "$WORK/build" "Demo App" "test.demo"
out=$(run_install "$WORK/build/Demo App.app" "$DEPLOY" "Demo App" true 2>&1)
check "installs into the deploy folder (with spaces in the path)" exists "$DEPLOY/Demo App.app"
check "nothing is placed directly in the parent" missing "$ROOT/Demo App.app"
check "reports the install" contains "$out" "Installed: $DEPLOY/Demo App.app"

fresh
make_app "$WORK/build" "Demo" "test.demo"
make_app "$ROOT" "Demo" "test.demo"
out=$(run_install "$WORK/build/Demo.app" "$DEPLOY" "Demo" true 2>&1)
check "migration removes the old copy with the same bundle id" missing "$ROOT/Demo.app"
check "and installs the new one" exists "$DEPLOY/Demo.app"

fresh
make_app "$WORK/build" "Demo" "test.demo"
make_app "$ROOT" "Demo" "other.id"
out=$(run_install "$WORK/build/Demo.app" "$DEPLOY" "Demo" true 2>&1)
check "an old copy with another bundle id is kept" exists "$ROOT/Demo.app"
check "and the user is told" contains "$out" "another bundle identifier"

fresh
make_app "$WORK/build" "Demo" "test.demo"
make_app "$ROOT" "Demo" "test.demo" mas
out=$(run_install "$WORK/build/Demo.app" "$DEPLOY" "Demo" true 2>&1)
check "an App Store build is kept" exists "$ROOT/Demo.app"
check "and the user is told" contains "$out" "App Store build"

fresh
make_app "$WORK/build" "Demo" "test.demo"
make_app "$ROOT" "Demo" "test.demo"
make_app "$DEPLOY" "Demo" "test.demo"
out=$(run_install "$WORK/build/Demo.app" "$DEPLOY" "Demo" true 2>&1)
check "when both places have it, the old copy is not removed" exists "$ROOT/Demo.app"
check "and the user is told" contains "$out" "exists in both places"

fresh
make_app "$WORK/build" "Demo" "test.demo"
make_app "$ROOT" "Demo" "test.demo"
run_install "$WORK/build/Demo.app" "$DEPLOY" "Demo" false >/dev/null 2>&1
check "migrate-old=false keeps the old copy" exists "$ROOT/Demo.app"

fresh
make_app "$WORK/build" "Demo" "new.id"
make_app "$DEPLOY" "Demo" "old.id"
run_install "$WORK/build/Demo.app" "$DEPLOY" "Demo" true >/dev/null 2>&1
check "an existing copy in the deploy folder is replaced" [ "$(bundle_id "$DEPLOY/Demo.app")" = "new.id" ]

fresh
if run_install "$WORK/build/Missing.app" "$DEPLOY" "Missing" true >/dev/null 2>&1; then
  echo "FAIL - a missing build output is an error"; FAILURES=$((FAILURES + 1))
else
  echo "ok   - a missing build output is an error"
fi
check "and nothing is created for it" missing "$DEPLOY/Missing.app"

# Installing directly into the old folder (DEPLOY_DIR=/Applications) skips the migration.
fresh
make_app "$WORK/build" "Demo" "test.demo"
out=$(run_install "$WORK/build/Demo.app" "$ROOT" "Demo" true 2>&1)
check "deploying directly into the old folder installs there" exists "$ROOT/Demo.app"
check "and removes nothing" contains "$out" "Installed: $ROOT/Demo.app"

if (( FAILURES > 0 )); then echo; echo "$FAILURES check(s) failed"; exit 1; fi
echo; echo "all checks passed"
