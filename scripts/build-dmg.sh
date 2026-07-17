#!/usr/bin/env bash
set -euo pipefail

XCODE_PROJECT=$(find . -maxdepth 1 -name "*.xcodeproj" -print -quit)
if [[ -z "${XCODE_PROJECT}" ]]; then
    echo "Error: No .xcodeproj found in the current directory." >&2
    exit 1
fi
XCODE_PROJECT="${XCODE_PROJECT#./}"
APP_NAME="${XCODE_PROJECT%.xcodeproj}"
SCHEME="${APP_NAME}"

BUILD_DIR="build-dmg"
DMG_NAME="${APP_NAME}.dmg"
DIST_DIR="dist"
STAGING_DIR="/tmp/$(echo "${APP_NAME}" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')-dmg-staging"
DMG_DEST="${1:-}"

TEAM_ID="${TEAM_ID:?Error: TEAM_ID is not set in Makefile}"
SIGN_IDENTITY="Developer ID Application: ${DEVELOPER_NAME:-$(security find-identity -v -p codesigning | grep "Developer ID Application" | head -1 | sed 's/.*"\(.*\)".*/\1/')} (${TEAM_ID})"
ARCHIVE_PATH="${BUILD_DIR}/${APP_NAME}.xcarchive"
EXPORT_PATH="${BUILD_DIR}/export"
EXPORT_OPTIONS="/tmp/$(echo "${APP_NAME}" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')-export-options.plist"

cat > "${EXPORT_OPTIONS}" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>developer-id</string>
    <key>teamID</key>
    <string>${TEAM_ID}</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>notarizeAfterExport</key>
    <false/>
</dict>
</plist>
EOF

CONFIGURATION="${CONFIGURATION:-Debug}"

if [[ "${CONFIGURATION}" == "Debug" ]]; then
    # Debug: Apple Development signed build
    DEBUG_APP="build/Build/Products/Debug/${APP_NAME}.app"
    echo "Building (Debug)..."
    xcodebuild build \
        -project "${XCODE_PROJECT}" \
        -scheme "${SCHEME}" \
        -configuration Debug \
        -destination "platform=macOS" \
        -derivedDataPath build \
        -allowProvisioningUpdates \
        DEVELOPMENT_TEAM="${TEAM_ID}"
    APP_PATH="${DEBUG_APP}"
else
    echo "Archiving (${CONFIGURATION})..."
    xcodebuild archive \
        -project "${XCODE_PROJECT}" \
        -scheme "${SCHEME}" \
        -configuration "${CONFIGURATION}" \
        -destination "platform=macOS" \
        -archivePath "${ARCHIVE_PATH}" \
        -allowProvisioningUpdates \
        DEVELOPMENT_TEAM="${TEAM_ID}"

    echo "Exporting with Developer ID..."
    xcodebuild -exportArchive \
        -archivePath "${ARCHIVE_PATH}" \
        -exportPath "${EXPORT_PATH}" \
        -exportOptionsPlist "${EXPORT_OPTIONS}" \
        -allowProvisioningUpdates

    APP_PATH="${EXPORT_PATH}/${APP_NAME}.app"
fi
if [[ ! -d "${APP_PATH}" ]]; then
    echo "Error: App not found at ${APP_PATH}" >&2
    exit 1
fi

echo "Packaging DMG..."
rm -rf "${STAGING_DIR}"
mkdir -p "${STAGING_DIR}"
cp -R "${APP_PATH}" "${STAGING_DIR}/"
ln -s /Applications "${STAGING_DIR}/Applications"

mkdir -p "${DIST_DIR}"
DMG_PATH="${DIST_DIR}/${DMG_NAME}"

hdiutil create \
    -volname "${APP_NAME}" \
    -srcfolder "${STAGING_DIR}" \
    -ov \
    -format UDZO \
    "${DMG_PATH}"

rm -rf "${STAGING_DIR}"

echo "Signing DMG..."
if [[ "${CONFIGURATION}" == "Debug" ]]; then
    codesign --sign "-" "${DMG_PATH}"
else
    codesign --sign "${SIGN_IDENTITY}" "${DMG_PATH}"
fi

echo "Built: ${DMG_PATH}"

if [[ -n "${DMG_DEST}" ]]; then
    DEST_DIR="${DMG_DEST/#\~/$HOME}"
    mkdir -p "${DEST_DIR}"
    cp "${DMG_PATH}" "${DEST_DIR}/${DMG_NAME}"
    echo "Copied to: ${DEST_DIR}/${DMG_NAME}"
fi
