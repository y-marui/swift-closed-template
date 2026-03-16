# Swift AI App Template

> **This file is the English reference version.**
> 日本語版（正本）は [README-jp.md](README-jp.md) を参照してください。

![CI](https://github.com/y-marui/swift-app-template/actions/workflows/ci.yml/badge.svg)

Template optimized for small teams, AI-assisted development, and long-term maintainability.

## Use this template

1. Click **"Use this template"** → **"Create a new repository"** on GitHub.
2. Clone your new repository and `cd` into it.
3. Run `make bootstrap` to install tools and resolve packages.
4. Open Xcode, create a new iOS App project in the repository root, then add `Packages/Core` as a local package.
5. Replace all `Example` references with your feature name (see `docs/development.md`).
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

その後、Xcodeで新規iOSプロジェクトを作成し、`Packages/Core` をローカルパッケージとして追加してください。
詳細は `Package.swift` のコメントを参照。

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
- [Development Guide](docs/development.md)
- [Maintenance](docs/maintenance.md)
- [Runbook](docs/runbook.md)

## AI-Assisted Development

This template is optimized for Claude Code and GitHub Copilot.
See [`AI_CONTEXT.md`](AI_CONTEXT.md) for rules and patterns the AI should follow.
