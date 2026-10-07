# Swift App Template

> **This is the reference (English) version.**
> The canonical (Japanese) version is [README-jp.md](README-jp.md).

[![License: All Rights Reserved](https://img.shields.io/badge/License-All%20Rights%20Reserved-red.svg)](LICENSE)
[![CI](https://github.com/y-marui/swift-closed-template/actions/workflows/ci.yml/badge.svg)](https://github.com/y-marui/swift-closed-template/actions/workflows/ci.yml)
[![Charter Check](https://github.com/y-marui/swift-closed-template/actions/workflows/dev-charter-check.yml/badge.svg)](https://github.com/y-marui/swift-closed-template/actions/workflows/dev-charter-check.yml)

Template optimized for small teams, AI-assisted development, and long-term maintainability.

## Project Overview

> **When applying this template:** Replace all `<!-- TODO -->` placeholders with your project-specific information.

<!-- TODO: Describe your app in 1–3 sentences. Example: "A budget tracking app that records expenses and visualizes monthly spending." -->

- **App Name:** <!-- TODO: e.g. MyApp -->
- **Bundle ID:** <!-- TODO: e.g. com.yourcompany.myapp -->
- **Target:** macOS 26+ (iOS 26+ optional; see [Enabling the iOS Target](Resources/Localization/README.md#enabling-the-ios-target))
- **Team Size:** <!-- TODO: e.g. Solo / 2–3 people -->

### Feature List

<!-- TODO: Replace with your planned or implemented features. Example:
| Feature | Status | Description |
|---|---|---|
| TodoList | ✅ Done | List, add, and delete tasks |
| Auth | 🚧 In Progress | Sign in with email |
| Settings | 📋 Planned | Notifications and theme settings |
-->

| Feature | Status | Description |
|---|---|---|
| ExampleFeature | 📋 To be removed | Template sample. Delete after your first production feature is complete. |

### Tech Stack

| Concern | Solution |
|---|---|
| Language | Swift 6 (strict concurrency) |
| State management | `@Observable` |
| Networking | URLSession + async/await (sample `APIClient`) <!-- TODO: remove if not needed --> |
| Dependency Injection | Manual (AppDependency) |
| Testing | XCTest + mocks |

### Environment Variables

<!-- TODO: List your environment variables, API keys, and endpoints. Example:
| Variable | Where to set | Description |
|---|---|---|
| API_KEY | Xcode Scheme > Environment Variables | External service API key |
-->

| Variable | Where to set | Description |
|---|---|---|
| BASE_URL | Xcode Scheme > Environment Variables | API base URL |

> Do not write API keys directly in code or `.env` files. Set them in Xcode under Scheme > Run > Environment Variables.

---

## Use this template

1. Click **"Use this template"** → **"Create a new repository"** on GitHub.
2. Apply the GitHub repository settings first (creating a repository from a template resets them). See [`docs/dev-charter/topics/GITHUB_SETTINGS.md`](docs/dev-charter/topics/GITHUB_SETTINGS.md) and [`docs/dev-charter/INSTALL_CHECKLIST.md`](docs/dev-charter/INSTALL_CHECKLIST.md).
3. Clone your new repository and `cd` into it.
4. Run `make bootstrap` to install tools, generate the Xcode project with xcodegen, and resolve packages.
5. Replace all `Example` references with your feature name (see [AI_CONTEXT.md](AI_CONTEXT.md)).
6. Update the **Project Overview** section above with your app's details.

### Setup Checklist

- [ ] Apply the GitHub repository settings (`main-protection` Ruleset, auto-delete head branches, auto-merge, Dependabot alerts, Sponsorships) per [`GITHUB_SETTINGS.md`](docs/dev-charter/topics/GITHUB_SETTINGS.md); follow [`INSTALL_CHECKLIST.md`](docs/dev-charter/INSTALL_CHECKLIST.md) for the full procedure
- [ ] Rename `README_TEMPLATE.md` / `README_TEMPLATE-jp.md` to `README.md` / `README-jp.md` (replacing the existing ones)
- [ ] Fill in all `<!-- TODO -->` placeholders in the Project Overview section
- [ ] Update the CI and Charter Check badge URLs to your actual repository URL
- [ ] Replace `[USERNAME]` / `[BMC_USERNAME]` in the support badges and `.github/FUNDING.yml` (see `~/.identity/accounts.yaml`)
- [ ] Rename `ExampleApp` in `App/macOS/App.swift` to your project name
- [ ] Run `make bootstrap` to install tools and generate the Xcode project (pre-commit hooks are installed automatically)
- [ ] Confirm `make test` passes
- [ ] Confirm CI works in GitHub Actions (security / lint / test jobs)
- [ ] If the new repository is **private**, set the `MACOS_RUNNER` repository variable to use the self-hosted macOS runner: `gh variable set MACOS_RUNNER --body macos-sh -R <owner>/<repo>` (if unset, CI runs on `macos-latest` at ~10x billing). Never set it on a public repository
- [ ] Delete `ExampleFeature` once your first production feature is working (see [`CONTRIBUTING.md`](CONTRIBUTING.md))
- [ ] If you use signed DMG distribution (`make deploy` / `make deploy-release` with `DEPLOY_DMG=true` in `.env`), replace `TEAM_ID` / `DEVELOPER_NAME` in the `Makefile` with your own values (leaving them blank makes `scripts/build-dmg.sh` fail)

## Features

- ✅ Clean Architecture (Feature / Domain / Infrastructure)
- ✅ Swift 6 with strict concurrency, `@Observable` ViewModels
- ✅ Manual dependency injection via `AppDependency`
- ✅ Async/await networking sample with `URLSession`
- ✅ Xcode project generation with xcodegen
- ✅ In-app language setting (8 languages)
- ✅ XCTest with mock examples
- ✅ SwiftLint + SwiftFormat configured
- ✅ GitHub Actions CI (lint + test)
- ✅ AI-friendly context files (`AI_CONTEXT.md`, project overview in README)

## Requirements

- Xcode 26+
- macOS 26+ (iOS 26+ optional)
- Swift 6

## Quick Start

```bash
git clone https://github.com/y-marui/swift-closed-template.git
cd swift-closed-template
make bootstrap
```

`make bootstrap` generates the Xcode project from `project.yml` with xcodegen.

## Commands

| Command | Description |
|---|---|
| `make bootstrap` | Install tools, resolve packages |
| `make lint` | Run SwiftLint |
| `make format` | Run SwiftFormat |
| `make test` | Run all tests |
| `make build` | Generate the project with xcodegen and build via Xcode |
| `make check-packages` | Warn if a newer `swift-app-monetization` exists (runs before `make build`) |
| `make update-packages` | Update `swift-app-monetization` and clear stale build caches |
| `make clean` | Clean build artifacts (`build/`, `.build/`) |

`make build` generates the project with xcodegen and builds the macOS app into `build/`.
Override defaults as needed:

```bash
DESTINATION="platform=macOS,arch=arm64" make build
SCHEME=MyApp make build
```

## Project Structure

```
Package.swift           # Root — テスト実行・パッケージ管理用
App/
  macOS/                # macOS entry point and DI container
  (iOS/ and Widget/ added per target)
Packages/Core/          # Swift Package with all features
  Sources/Core/
    Features/           # UI + ViewModel per feature
    Domain/             # Models, Protocols (no dependencies)
    Infrastructure/     # Network, Persistence (implements Domain protocols)
    Shared/             # Utilities
.github/workflows/      # GitHub Actions CI
docs/                   # Architecture and development guides
templates/feature/      # Code templates for new features
scripts/                # Shell scripts
```

## Documentation

- [Architecture](docs/architecture.md)
- [Specification](docs/specification.md)
- [UI Design](docs/ui-design.md)
- [File Map](docs/file-map.md)

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for development workflow, naming conventions, and code review checklist.

## Runbook

### Xcode Project Setup

The Xcode project is generated from `project.yml` with xcodegen; do not create it by hand.

1. Edit the target name, `PRODUCT_BUNDLE_IDENTIFIER`, etc. in `project.yml` (and `APP_NAME` in the `Makefile`)
2. Run `make bootstrap` to generate the project
3. To add an iOS target, uncomment the iOS entries in `project.yml` (see [Enabling the iOS Target](Resources/Localization/README.md#enabling-the-ios-target))
4. Confirm `make test` passes

### Adding a New Feature

```bash
FEATURE=MyFeature
mkdir -p Packages/Core/Sources/Core/Features/$FEATURE
cp templates/feature/View.swift.template     Packages/Core/Sources/Core/Features/$FEATURE/${FEATURE}View.swift
cp templates/feature/ViewModel.swift.template Packages/Core/Sources/Core/Features/$FEATURE/${FEATURE}ViewModel.swift
cp templates/feature/UseCase.swift.template  Packages/Core/Sources/Core/Features/$FEATURE/${FEATURE}UseCase.swift
```

Replace `{{FeatureName}}` with your actual feature name.

### Release Flow

```
feature/xxx → main → tag
```

1. Develop on a `feature/xxx` branch
2. Open a PR to `main` (ensure CI passes)
3. Tag after merging to `main`

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### Hotfix

```bash
git checkout main
git checkout -b hotfix/issue-description
# fix and test
make test
git checkout main && git merge hotfix/issue-description
git tag -a v1.0.1 -m "Hotfix v1.0.1"
git push origin main v1.0.1
```

### CI Failures

**Lint errors:**
```bash
make lint     # check errors
make format   # auto-fix formatting
make lint     # re-verify
```

**Test failures:**
```bash
make test                              # reproduce locally
swift test --filter TestClassName      # run a specific test
```

**Package resolution errors:**
```bash
make clean
swift package resolve --package-path Packages/Core
make test
```

## AI-Assisted Development

This template is optimized for Claude Code and GitHub Copilot.
See [`AI_CONTEXT.md`](AI_CONTEXT.md) for rules and patterns the AI should follow.

---
*This document has a Japanese canonical version [README-jp.md](README-jp.md). Update both in the same commit when editing.*
