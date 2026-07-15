SHELL := /bin/bash
.PHONY: bootstrap lint format test build ios ios-release register-widget deploy deploy-release dmg clean update-charter unlock-keychain

# .xcodeprojを自動検出。複数ある場合は XCODE_PROJECT=MyApp.xcodeproj make build で指定。
XCODE_PROJECT ?= $(wildcard *.xcodeproj)
SCHEME        ?= $(basename $(XCODE_PROJECT))
DESTINATION   ?= platform=macOS,arch=arm64
SIM_DEST      ?= platform=iOS Simulator,name=iPhone 17

-include .env
export

DEPLOY_DMG     ?= false
DMG_DEST       ?=
TEAM_ID        ?=
DEVELOPER_NAME ?=
WIDGET_ID      ?=
WIDGET_APPEX   ?=

bootstrap:
	bash scripts/bootstrap.sh

lint:
	bash scripts/lint.sh

format:
	swiftformat .

test:
	bash scripts/test.sh

build:
ifeq ($(XCODE_PROJECT),)
	swift build --package-path Packages/Core --build-path build
else
	xcodebuild \
		-project "$(XCODE_PROJECT)" \
		-scheme "$(SCHEME)" \
		-configuration Debug \
		-destination "$(DESTINATION)" \
		-derivedDataPath build \
		-allowProvisioningUpdates \
		build
endif

IOS_SCHEME           ?= $(SCHEME) iOS
IOS_DEVICE_UDID      ?=
IOS_APP_PATH          = build/Build/Products/Debug-iphoneos/$(IOS_SCHEME).app
IOS_RELEASE_APP_PATH  = build-release/Build/Products/Release-iphoneos/$(IOS_SCHEME).app

ios:
	@if [ -z "$(IOS_DEVICE_UDID)" ]; then \
		echo "Error: IOS_DEVICE_UDID is not set. Add IOS_DEVICE_UDID=<udid> to .env"; \
		echo "       Find your UDID: xcrun xctrace list devices"; \
		exit 1; \
	fi
	$(MAKE) SCHEME="$(IOS_SCHEME)" DESTINATION="id=$(IOS_DEVICE_UDID)" build
	@if [ ! -d "$(IOS_APP_PATH)" ]; then \
		echo "Error: Build output not found at '$(IOS_APP_PATH)'"; \
		exit 1; \
	fi
	@echo "Installing on device $(IOS_DEVICE_UDID)..."
	@xcrun devicectl device install app \
		--device "$(IOS_DEVICE_UDID)" \
		"$(IOS_APP_PATH)" \
		|| { echo "Error: Installation failed. Device '$(IOS_DEVICE_UDID)' must be unlocked and trusted."; exit 1; }

ios-release:
	@if [ -z "$(IOS_DEVICE_UDID)" ]; then \
		echo "Error: IOS_DEVICE_UDID is not set. Add IOS_DEVICE_UDID=<udid> to .env"; \
		echo "       Find your UDID: xcrun xctrace list devices"; \
		exit 1; \
	fi
	xcodebuild \
		-project "$(XCODE_PROJECT)" \
		-scheme "$(IOS_SCHEME)" \
		-configuration Release \
		-destination "id=$(IOS_DEVICE_UDID)" \
		-derivedDataPath build-release \
		-allowProvisioningUpdates \
		build
	@if [ ! -d "$(IOS_RELEASE_APP_PATH)" ]; then \
		echo "Error: Build output not found at '$(IOS_RELEASE_APP_PATH)'"; \
		exit 1; \
	fi
	@echo "Installing Release build on device $(IOS_DEVICE_UDID)..."
	@xcrun devicectl device install app \
		--device "$(IOS_DEVICE_UDID)" \
		"$(IOS_RELEASE_APP_PATH)" \
		|| { echo "Error: Installation failed. Device '$(IOS_DEVICE_UDID)' must be unlocked and trusted."; exit 1; }

DEPLOY_MOUNT ?= $(shell echo "/tmp/$(SCHEME)-deploy" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

deploy:
	@echo "Stopping $(SCHEME) if running..."
	@osascript -e 'tell application "$(SCHEME)" to quit' 2>/dev/null || true
	@sleep 2
ifeq ($(DEPLOY_DMG),true)
	@$(MAKE) -s dmg
	@echo "Installing from DMG..."
	@hdiutil detach "$(DEPLOY_MOUNT)" 2>/dev/null || true
	@hdiutil attach "dist/$(SCHEME).dmg" -mountpoint "$(DEPLOY_MOUNT)" -quiet
	@rm -rf "/Applications/$(SCHEME).app"
	@cp -Rp "$(DEPLOY_MOUNT)/$(SCHEME).app" "/Applications/$(SCHEME).app"
	@hdiutil detach "$(DEPLOY_MOUNT)" -quiet
else
	@$(MAKE) -s build
	@echo "Copying to /Applications..."
	@rm -rf "/Applications/$(SCHEME).app"
	@ditto "build/Build/Products/Debug/$(SCHEME).app" "/Applications/$(SCHEME).app"
endif
	@echo "Launching $(SCHEME)..."
	@open "/Applications/$(SCHEME).app"

deploy-release:
	xcodebuild \
		-project "$(XCODE_PROJECT)" \
		-scheme "$(SCHEME)" \
		-configuration Release \
		-destination "$(DESTINATION)" \
		-derivedDataPath build-release \
		-allowProvisioningUpdates \
		build
	@echo "Stopping $(SCHEME) if running..."
	@osascript -e 'tell application "$(SCHEME)" to quit' 2>/dev/null || true
	@sleep 2
	@echo "Copying to /Applications..."
	@rm -rf "/Applications/$(SCHEME).app"
	@ditto "build-release/Build/Products/Release/$(SCHEME).app" "/Applications/$(SCHEME).app"
	@echo "Launching $(SCHEME)..."
	@open "/Applications/$(SCHEME).app"
	@if [ "$(DEPLOY_DMG)" = "true" ]; then $(MAKE) -s dmg; fi

dmg:
	@bash scripts/build-dmg.sh "$(DMG_DEST)"

register-widget:
	@echo "📡 Registering widget..."
	@pluginkit -a "$(WIDGET_APPEX)" 2>/dev/null || true
	@pluginkit -e use -i "$(WIDGET_ID)" 2>/dev/null || true

clean:
	swift package clean
	rm -rf .build build build-release build-dmg dist DerivedData
	@SCHEME_ESC=$$(echo "$(SCHEME)" | tr ' ' '_'); \
	find "$(HOME)/Library/Developer/Xcode/DerivedData" -maxdepth 1 -name "$${SCHEME_ESC}-*" -exec rm -rf {} + 2>/dev/null || true

update-charter:
	git subtree pull --prefix=docs/dev-charter dev-charter main --squash

unlock-keychain:
	security unlock-keychain ~/Library/Keychains/login.keychain-db
