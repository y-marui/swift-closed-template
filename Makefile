SHELL := /bin/bash
.PHONY: bootstrap lint format test build clean

bootstrap:
	bash scripts/bootstrap.sh

lint:
	bash scripts/lint.sh

format:
	swiftformat .

test:
	bash scripts/test.sh

build:
	swift build --package-path Packages/Core --build-path build

clean:
	swift package clean
	rm -rf .build build
