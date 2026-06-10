SHELL := /bin/bash
.PHONY: bootstrap lint format test build ios deploy deploy-release dmg clean update-charter

# .xcodeprojを自動検出。複数ある場合は XCODE_PROJECT=MyApp.xcodeproj make build で指定。
XCODE_PROJECT := $(wildcard *.xcodeproj)
SCHEME        ?= $(basename $(XCODE_PROJECT))
DESTINATION   ?= platform=iOS Simulator,name=iPhone 16

-include .env
export

DEPLOY_DMG ?= false
DMG_DEST   ?=

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

IOS_SCHEME      ?= $(SCHEME) iOS
IOS_DEVICE_UDID ?=
IOS_APP_PATH     = build/Build/Products/Debug-iphoneos/$(IOS_SCHEME).app

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

deploy: build
	@echo "Stopping $(SCHEME) if running..."
	@osascript -e 'tell application "$(SCHEME)" to quit' 2>/dev/null || true
	@sleep 2
	@echo "Copying to /Applications..."
	@rm -rf "/Applications/$(SCHEME).app"
	@ditto "build/Build/Products/Debug/$(SCHEME).app" "/Applications/$(SCHEME).app"
	@echo "Launching $(SCHEME)..."
	@open "/Applications/$(SCHEME).app"
	@if [ "$(DEPLOY_DMG)" = "true" ]; then $(MAKE) -s dmg; fi

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

clean:
	swift package clean
	rm -rf .build build build-release build-dmg dist

update-charter:
	git subtree pull --prefix=docs/dev-charter dev-charter main --squash
