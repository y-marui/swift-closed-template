#!/usr/bin/env bash
# Install a built .app into the deploy folder (macOS only).
#
# usage: install-app.sh <built .app> <deploy folder> <app name> [migrate-old: true|false] [old folder]
#
# The deploy folder keeps self-made apps apart from /Applications itself (for example
# "/Applications/My Swift"), so they never collide with an App Store version of the same name.
# To install directly under /Applications instead, set DEPLOY_DIR=/Applications (Makefile or .env);
# the migration below is then skipped, because the old folder is the deploy folder.
#
# Removing an old copy directly under the old folder (default /Applications)
# is a temporary, opt-in migration measure (MIGRATE_OLD in the Makefile). The old copy is removed
# only when ALL of these hold:
#   - the app did not already exist in the deploy folder before this run
#     (when it exists in both places, the old copy is left alone and the user is told),
#   - it is not a Mac App Store build (no _MASReceipt),
#   - its bundle identifier is the same as the app being installed.
set -euo pipefail

if [[ $# -lt 3 ]]; then
    echo "usage: $0 <built .app> <deploy folder> <app name> [migrate-old: true|false] [old folder]" >&2
    exit 64
fi

src="$1"
deploy_dir="$2"
name="$3"
migrate_old="${4:-true}"
old_dir="${5:-/Applications}"

new_app="$deploy_dir/$name.app"
legacy_app="$old_dir/$name.app"

[[ -d "$src" ]] || { echo "Error: build output not found at '$src'" >&2; exit 1; }

bundle_id_of() {
    /usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$1/Contents/Info.plist" 2>/dev/null || true
}

existed_before=false
[[ -d "$new_app" ]] && existed_before=true

mkdir -p "$deploy_dir"

if [[ "$migrate_old" == "true" && "$deploy_dir" != "$old_dir" && -d "$legacy_app" ]]; then
    if $existed_before; then
        echo "Note: the app exists in both places, so the old copy is not removed: $legacy_app"
    elif [[ -d "$legacy_app/Contents/_MASReceipt" ]]; then
        echo "Note: the old copy is an App Store build, so it is not removed: $legacy_app"
    else
        legacy_id="$(bundle_id_of "$legacy_app")"
        new_id="$(bundle_id_of "$src")"
        if [[ -n "$new_id" && "$legacy_id" == "$new_id" ]]; then
            if pgrep -f "$legacy_app/Contents/MacOS" >/dev/null 2>&1; then
                osascript -e "tell application \"$name\" to quit" 2>/dev/null || true
                sleep 1
            fi
            echo "Removing the old copy: $legacy_app"
            rm -rf "$legacy_app"
        else
            echo "Note: the old copy has another bundle identifier, so it is not removed: $legacy_app"
        fi
    fi
fi

rm -rf "$new_app"
ditto "$src" "$new_app"
echo "Installed: $new_app"
