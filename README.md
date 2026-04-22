# Swift App Template

> **This is the reference (English) version.**
> The canonical (Japanese) version is [README-jp.md](README-jp.md).

[![License: All Rights Reserved](https://img.shields.io/badge/License-All%20Rights%20Reserved-red.svg)](LICENSE)
[![CI](https://github.com/y-marui/swift-closed-template/actions/workflows/ci.yml/badge.svg)](https://github.com/y-marui/swift-closed-template/actions/workflows/ci.yml)
[![Charter Check](https://github.com/y-marui/swift-closed-template/actions/workflows/dev-charter-check.yml/badge.svg)](https://github.com/y-marui/swift-closed-template/actions/workflows/dev-charter-check.yml)

Template optimized for small teams, AI-assisted development, and long-term maintainability.

## Use this template

1. Click **"Use this template"** → **"Create a new repository"** on GitHub.
2. Clone your new repository and `cd` into it.
3. Run `make bootstrap` to install tools and resolve packages.
4. Open Xcode, create a new iOS App project in the repository root, then add `Packages/Core` as a local package.
5. Replace all `Example` references with your feature name (see [AI_CONTEXT.md](AI_CONTEXT.md)).
6. Update `PROJECT_CONTEXT.md` with your app's details.

## Features

- ✅ Clean Architecture (Feature / Domain / Infrastructure)
- ✅ `@Observable` ViewModels (iOS 17+)
- ✅ Manual dependency injection via `AppDependency`
- ✅ SwiftData persistence layer
- ✅ Async/await networking with `URLSession`
- ✅ XCTest with mock examples
- ✅ SwiftLint + SwiftFormat configured
- ✅ GitHub Actions CI (lint + test)
- ✅ AI-friendly context files (`AI_CONTEXT.md`, `PROJECT_CONTEXT.md`)

## Requirements

- Xcode 15+
- iOS 17+ / macOS 14+
- Swift 5.9+

## Quick Start

```bash
git clone https://github.com/y-marui/swift-app-template.git
cd swift-app-template
make bootstrap
```

Then create a new iOS App project in Xcode and add `Packages/Core` as a local package.
See comments in `Package.swift` for details.

## Commands

| Command | Description |
|---|---|
| `make bootstrap` | Install tools, resolve packages |
| `make lint` | Run SwiftLint |
| `make format` | Run SwiftFormat |
| `make test` | Run all tests |
| `make build` | Build via Xcode (if `.xcodeproj` exists) or `swift build` |
| `make clean` | Clean build artifacts (`build/`, `.build/`) |

`make build` auto-detects the `.xcodeproj` and builds for iOS Simulator (iPhone 16) into `build/`.
Override defaults as needed:

```bash
DESTINATION="platform=iOS Simulator,name=iPhone 15" make build
SCHEME=MyApp make build
```

## Project Structure

```
Package.swift           # Root — テスト実行・パッケージ管理用
App/                    # Entry point and DI container
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

### Xcode Project Setup (New)

1. Xcode > File > New > Project — create an iOS App
2. Set project name / Bundle ID and save in the repository root
3. Xcode > File > Add Package Dependencies
4. Select `Packages/Core` via "Add Local..."
5. Add the `Core` library to the App target
6. Add files in the `App/` folder to the project
7. Confirm `make test` passes

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
feature/xxx → develop → main → tag
```

1. Develop on a `feature/xxx` branch
2. Open a PR to `develop` (ensure CI passes)
3. PR from `develop` → `main` before release
4. Tag after merging to `main`

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
git checkout develop && git merge hotfix/issue-description
git tag -a v1.0.1 -m "Hotfix v1.0.1"
git push origin main develop v1.0.1
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
