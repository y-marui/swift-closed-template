.PHONY: bootstrap lint format test ensure-xcode-project xcodegen build ios ios-release register-widget deploy deploy-release dmg clean update-charter unlock-keychain

-include .env

APP_NAME := Swift AI App Template
XCODE_PROJECT := $(APP_NAME).xcodeproj
SCHEME ?= $(APP_NAME)
DESTINATION ?= platform=macOS,arch=arm64
SIM_DEST ?= platform=iOS Simulator,name=iPhone 17
TEAM_ID ?=
DEVELOPER_NAME ?= Yukihiro Marui
DEPLOY_DMG ?= false
DMG_DEST ?=
IOS_SCHEME ?= Swift AI App Template iOS
IOS_PRODUCT_NAME ?= Swift AI App Template
IOS_DEVICE_UDID ?=
SKIP_XCODEGEN ?= false
IOS_APP_PATH = build/Build/Products/Debug-iphoneos/$(IOS_PRODUCT_NAME).app
IOS_RELEASE_APP_PATH = build-release/Build/Products/Release-iphoneos/$(IOS_PRODUCT_NAME).app
WIDGET_ID ?=
WIDGET_TARGET ?=
WIDGET_APPEX ?=

bootstrap:
	TEAM_ID="$(TEAM_ID)" bash scripts/bootstrap.sh

lint:
	bash scripts/lint.sh

format:
	swiftformat .

test: ensure-xcode-project
	bash scripts/test.sh

ensure-xcode-project:
	@if [ "$(SKIP_XCODEGEN)" != "true" ]; then \
		command -v xcodegen >/dev/null 2>&1 || { echo "Error: xcodegen is not installed. Run 'make bootstrap'."; exit 1; }; \
		TEAM_ID="$(TEAM_ID)" xcodegen generate; \
	fi

xcodegen:
	@command -v xcodegen >/dev/null 2>&1 || { echo "Error: xcodegen is not installed. Run 'make bootstrap'."; exit 1; }
	TEAM_ID="$(TEAM_ID)" xcodegen generate

build: ensure-xcode-project
	xcodebuild -project "$(XCODE_PROJECT)" -scheme "$(SCHEME)" -configuration Debug -destination "$(DESTINATION)" -derivedDataPath build -allowProvisioningUpdates DEVELOPMENT_TEAM="$(TEAM_ID)" build

ios: ensure-xcode-project
	@if [ -z "$(IOS_DEVICE_UDID)" ]; then echo "Error: IOS_DEVICE_UDID is not set. Set it in .env or pass IOS_DEVICE_UDID=<udid> to make."; exit 1; fi
	$(MAKE) SCHEME="$(IOS_SCHEME)" DESTINATION="id=$(IOS_DEVICE_UDID)" build
	@test -d "$(IOS_APP_PATH)" || { echo "Error: Build output not found at '$(IOS_APP_PATH)'"; exit 1; }
	xcrun devicectl device install app --device "$(IOS_DEVICE_UDID)" "$(IOS_APP_PATH)"

ios-release: ensure-xcode-project
	@if [ -z "$(IOS_DEVICE_UDID)" ]; then echo "Error: IOS_DEVICE_UDID is not set. Set it in .env or pass IOS_DEVICE_UDID=<udid> to make."; exit 1; fi
	xcodebuild -project "$(XCODE_PROJECT)" -scheme "$(IOS_SCHEME)" -configuration Release -destination "id=$(IOS_DEVICE_UDID)" -derivedDataPath build-release -allowProvisioningUpdates DEVELOPMENT_TEAM="$(TEAM_ID)" build
	@test -d "$(IOS_RELEASE_APP_PATH)" || { echo "Error: Build output not found at '$(IOS_RELEASE_APP_PATH)'"; exit 1; }
	xcrun devicectl device install app --device "$(IOS_DEVICE_UDID)" "$(IOS_RELEASE_APP_PATH)"

DEPLOY_MOUNT ?= $(shell echo "/tmp/$(APP_NAME)-deploy" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

deploy: ensure-xcode-project
	@if pgrep -x "$(APP_NAME)" >/dev/null; then osascript -e 'tell application "$(APP_NAME)" to quit'; fi
ifeq ($(DEPLOY_DMG),true)
	CONFIGURATION=Debug $(MAKE) -s dmg
	@if mount | grep -Fq "on $(DEPLOY_MOUNT) "; then hdiutil detach "$(DEPLOY_MOUNT)"; fi
	hdiutil attach "dist/$(APP_NAME).dmg" -mountpoint "$(DEPLOY_MOUNT)" -quiet
	rm -rf "/Applications/$(APP_NAME).app"
	cp -Rp "$(DEPLOY_MOUNT)/$(APP_NAME).app" "/Applications/$(APP_NAME).app"
	hdiutil detach "$(DEPLOY_MOUNT)" -quiet
else
	$(MAKE) -s build
	rm -rf "/Applications/$(APP_NAME).app"
	ditto "build/Build/Products/Debug/$(APP_NAME).app" "/Applications/$(APP_NAME).app"
endif
	@if [ -n "$(WIDGET_TARGET)" ]; then $(MAKE) -s register-widget; fi
	open "/Applications/$(APP_NAME).app"

deploy-release: ensure-xcode-project
	xcodebuild -project "$(XCODE_PROJECT)" -scheme "$(SCHEME)" -configuration Release -destination "$(DESTINATION)" -derivedDataPath build-release -allowProvisioningUpdates DEVELOPMENT_TEAM="$(TEAM_ID)" build
	@if pgrep -x "$(APP_NAME)" >/dev/null; then osascript -e 'tell application "$(APP_NAME)" to quit'; fi
	rm -rf "/Applications/$(APP_NAME).app"
	ditto "build-release/Build/Products/Release/$(APP_NAME).app" "/Applications/$(APP_NAME).app"
	@if [ -n "$(WIDGET_TARGET)" ]; then $(MAKE) -s register-widget; fi
	open "/Applications/$(APP_NAME).app"
	@if [ "$(DEPLOY_DMG)" = "true" ]; then CONFIGURATION=Release $(MAKE) -s dmg; fi

dmg: ensure-xcode-project
	TEAM_ID="$(TEAM_ID)" DEVELOPER_NAME="$(DEVELOPER_NAME)" bash scripts/build-dmg.sh "$(DMG_DEST)"

register-widget:
	@test -n "$(WIDGET_ID)" -a -n "$(WIDGET_APPEX)" || { echo "Error: widget is not configured."; exit 1; }
	pluginkit -a "$(WIDGET_APPEX)"
	pluginkit -e use -i "$(WIDGET_ID)"

clean:
	swift package clean
	rm -rf .build build build-release build-dmg dist DerivedData
	@if [ -d "$(HOME)/Library/Developer/Xcode/DerivedData" ]; then SCHEME_ESC=$$(echo "$(SCHEME)" | tr ' ' '_'); find "$(HOME)/Library/Developer/Xcode/DerivedData" -maxdepth 1 -name "$${SCHEME_ESC}-*" -exec rm -rf {} +; fi

update-charter:
	curl -fsSL https://raw.githubusercontent.com/y-marui/dev-charter/main/scripts/install.sh | CHARTER_UPDATE_ONLY=1 bash

unlock-keychain:
	security unlock-keychain ~/Library/Keychains/login.keychain-db
