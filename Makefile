SHELL := /bin/bash
.PHONY: bootstrap lint format test build clean update-charter

# .xcodeprojを自動検出。複数ある場合は XCODE_PROJECT=MyApp.xcodeproj make build で指定。
XCODE_PROJECT := $(wildcard *.xcodeproj)
SCHEME        ?= $(basename $(XCODE_PROJECT))
DESTINATION   ?= platform=iOS Simulator,name=iPhone 16

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
		-destination "$(DESTINATION)" \
		-derivedDataPath build \
		build
endif

clean:
	swift package clean
	rm -rf .build build

update-charter:
	git subtree pull --prefix=docs/dev-charter dev-charter main --squash
