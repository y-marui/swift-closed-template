# Swift App Template

> **このファイルは正本（日本語版）です。**
> 英語版（参照）は [README.md](README.md) を参照してください。

[![License: All Rights Reserved](https://img.shields.io/badge/License-All%20Rights%20Reserved-red.svg)](LICENSE)
[![CI](https://github.com/y-marui/swift-closed-template/actions/workflows/ci.yml/badge.svg)](https://github.com/y-marui/swift-closed-template/actions/workflows/ci.yml)
[![Charter Check](https://github.com/y-marui/swift-closed-template/actions/workflows/dev-charter-check.yml/badge.svg)](https://github.com/y-marui/swift-closed-template/actions/workflows/dev-charter-check.yml)

小規模チーム・AI支援開発・長期保守を前提に最適化されたテンプレートです。

## Project Overview

> **新規プロジェクト適用時:** 以下の `<!-- TODO -->` をすべてプロジェクト固有の情報に置き換えてください。

<!-- TODO: アプリの概要を1〜3文で説明してください。例: 「家計簿アプリ。支出を記録・可視化し、月ごとの予算管理をサポートする。」 -->

- **アプリ名:** <!-- TODO: 例: MyApp -->
- **Bundle ID:** <!-- TODO: 例: com.yourcompany.myapp -->
- **ターゲット:** macOS 26+（iOS 26+ は任意。[iOS ターゲットの有効化](Resources/Localization/README.md#enabling-the-ios-target)参照）
- **チーム規模:** <!-- TODO: 例: 個人 / 2〜3人 -->

### Feature List

<!-- TODO: 実装予定または実装済みのフィーチャー一覧に置き換えてください。例:
| フィーチャー | 状態 | 説明 |
|---|---|---|
| TodoList | ✅ 実装済み | タスクの一覧表示・追加・削除 |
| Auth | 🚧 実装中 | メールアドレスでのサインイン |
| Settings | 📋 未着手 | 通知・テーマの設定 |
-->

| フィーチャー | 状態 | 説明 |
|---|---|---|
| ExampleFeature | 📋 削除予定 | テンプレートのサンプル。最初の本番フィーチャー完成後に削除 |

### Tech Stack

| Concern | Solution |
|---|---|
| Language | Swift 6（strict concurrency） |
| State management | `@Observable` |
| Networking | URLSession + async/await（サンプルの `APIClient`） <!-- TODO: 不要なら削除 --> |
| Dependency Injection | Manual (AppDependency) |
| Testing | XCTest + mocks |

### Environment Variables

<!-- TODO: 環境変数・APIキー・エンドポイントを記載してください。例:
| 変数名 | 設定場所 | 説明 |
|---|---|---|
| API_KEY | Xcode Scheme > Environment Variables | 外部サービスのAPIキー |
-->

| 変数名 | 設定場所 | 説明 |
|---|---|---|
| BASE_URL | Xcode Scheme > Environment Variables | APIのベースURL |

> APIキーをコードや `.env` ファイルに直接書かないでください。Xcode の Scheme > Run > Environment Variables に設定してください。

---

## Use this template

1. GitHub で **"Use this template"** → **"Create a new repository"** をクリック
2. GitHub リポジトリ設定を最初に適用する（テンプレートからの作成時は設定が初期化されるため）。[`docs/dev-charter/topics/GITHUB_SETTINGS.md`](docs/dev-charter/topics/GITHUB_SETTINGS.md) と [`docs/dev-charter/INSTALL_CHECKLIST.md`](docs/dev-charter/INSTALL_CHECKLIST.md) を参照
3. リポジトリをクローンして `cd` で移動
4. `make bootstrap` でツールをインストールし、xcodegen で Xcode プロジェクトを生成してパッケージを解決
5. すべての `Example` をフィーチャー名に置き換える（[AI_CONTEXT.md](AI_CONTEXT.md) 参照）
6. 上記「プロジェクト概要」セクションをアプリの情報で更新する

### Setup Checklist

- [ ] GitHub リポジトリ設定（`main-protection` Ruleset、head ブランチ自動削除、auto-merge、Dependabot alerts、Sponsorships）を [`GITHUB_SETTINGS.md`](docs/dev-charter/topics/GITHUB_SETTINGS.md) に従って適用する。全体の手順は [`INSTALL_CHECKLIST.md`](docs/dev-charter/INSTALL_CHECKLIST.md) を参照
- [ ] `README_TEMPLATE.md` / `README_TEMPLATE-jp.md` を `README.md` / `README-jp.md` にリネームする（既存ファイルは置き換える）
- [ ] 「プロジェクト概要」セクションの `<!-- TODO -->` をすべて埋める
- [ ] CI・Charter Check バッジの URL を実際のリポジトリ URL に変更する
- [ ] サポートバッジと `.github/FUNDING.yml` の `[USERNAME]` / `[BMC_USERNAME]` を置き換える（`~/.identity/accounts.yaml` 参照）
- [ ] `App/macOS/App.swift` の `ExampleApp` をプロジェクト名に変更する
- [ ] `make bootstrap` を実行してツールをインストールし、Xcode プロジェクトを生成する（pre-commit hooks も自動インストールされる）
- [ ] `make test` が通ることを確認する
- [ ] CI が GitHub Actions で動作することを確認する（security / lint / test の 3 ジョブ）
- [ ] 新しいリポジトリが **private** なら、self-hosted macOS runner を使うためリポジトリ変数 `MACOS_RUNNER` を設定する: `gh variable set MACOS_RUNNER --body macos-sh -R <owner>/<repo>`（未設定だと `macos-latest` で動き、約 10 倍の課金になる）。public リポジトリには設定しない
- [ ] 最初の本番フィーチャーが動作したら `ExampleFeature` を削除する（手順: [`CONTRIBUTING.md`](CONTRIBUTING.md)）
- [ ] 署名付き DMG 配布（`make deploy` / `make deploy-release`、`.env` の `DEPLOY_DMG=true`）を使う場合は `Makefile` の `TEAM_ID` / `DEVELOPER_NAME` をプロジェクト固有の値に置き換える（空のままだと `scripts/build-dmg.sh` がエラーになる）

## Features

- ✅ Clean Architecture（Feature / Domain / Infrastructure）
- ✅ Swift 6（strict concurrency）、`@Observable` ViewModel
- ✅ `AppDependency` による手動依存注入
- ✅ `URLSession` + async/await ネットワークのサンプル
- ✅ xcodegen による Xcode プロジェクト生成
- ✅ アプリ内言語設定（8 言語）
- ✅ モック付き XCTest
- ✅ SwiftLint + SwiftFormat 設定済み
- ✅ GitHub Actions CI（lint + test）
- ✅ AI 向けコンテキストファイル（`AI_CONTEXT.md`、README 内プロジェクト概要）

## Requirements

- Xcode 26+
- macOS 26+（iOS 26+ は任意）
- Swift 6

## Quick Start

```bash
git clone https://github.com/y-marui/swift-closed-template.git
cd swift-closed-template
make bootstrap
```

`make bootstrap` が xcodegen で `project.yml` から Xcode プロジェクトを生成します。

## Commands

| コマンド | 説明 |
|---|---|
| `make bootstrap` | ツールのインストールとパッケージ解決 |
| `make lint` | SwiftLint を実行 |
| `make format` | SwiftFormat を実行 |
| `make test` | 全テストを実行 |
| `make build` | xcodegen でプロジェクトを生成し、Xcode でビルド |
| `make clean` | ビルド成果物を削除（`build/`、`.build/`） |

`make build` は xcodegen でプロジェクトを生成し、macOS アプリを `build/` へビルドします。
デフォルトは環境変数で上書き可能です：

```bash
DESTINATION="platform=macOS,arch=arm64" make build
SCHEME=MyApp make build
```

## Project Structure

```
Package.swift           # ルート — テスト実行・パッケージ管理用
App/
  macOS/                # macOS エントリーポイントと DI コンテナ
  (iOS/、Widget/ はターゲット追加時に作成)
Packages/Core/          # 全フィーチャーを含む Swift Package
  Sources/Core/
    Features/           # フィーチャーごとの UI + ViewModel
    Domain/             # モデル・プロトコル（依存なし）
    Infrastructure/     # ネットワーク・永続化（Domain プロトコルの実装）
    Shared/             # ユーティリティ
.github/workflows/      # GitHub Actions CI
docs/                   # アーキテクチャ・開発ガイド
templates/feature/      # 新規フィーチャー用コードテンプレート
scripts/                # シェルスクリプト
```

## Documentation

- [アーキテクチャ](docs/architecture.md)
- [仕様](docs/specification.md)
- [UI 設計](docs/ui-design.md)
- [ファイルマップ](docs/file-map.md)

開発フロー・命名規則・コードレビューチェックリストは [`CONTRIBUTING.md`](CONTRIBUTING.md) を参照してください。

## Runbook

### Xcode Project Setup

Xcode プロジェクトは xcodegen が `project.yml` から生成する。手作業で作成しない。

1. `project.yml` のターゲット名・`PRODUCT_BUNDLE_IDENTIFIER` 等（と `Makefile` の `APP_NAME`）を編集する
2. `make bootstrap` でプロジェクトを生成する
3. iOS ターゲットを追加する場合は `project.yml` の iOS 関連行のコメントを外す（[iOS ターゲットの有効化](Resources/Localization/README.md#enabling-the-ios-target)参照）
4. `make test` が通ることを確認

### Adding a New Feature

```bash
FEATURE=MyFeature
mkdir -p Packages/Core/Sources/Core/Features/$FEATURE
cp templates/feature/View.swift.template      Packages/Core/Sources/Core/Features/$FEATURE/${FEATURE}View.swift
cp templates/feature/ViewModel.swift.template Packages/Core/Sources/Core/Features/$FEATURE/${FEATURE}ViewModel.swift
cp templates/feature/UseCase.swift.template   Packages/Core/Sources/Core/Features/$FEATURE/${FEATURE}UseCase.swift
```

`{{FeatureName}}` を実際のフィーチャー名に置換してください。

### Release Flow

```
feature/xxx → main → タグ付け
```

1. `feature/xxx` ブランチで開発
2. `main` へ PR を出す（CI が通ることを確認）
3. `main` マージ後にタグを打つ

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### Hotfix

```bash
git checkout main
git checkout -b hotfix/issue-description
# 修正・テスト
make test
git checkout main && git merge hotfix/issue-description
git tag -a v1.0.1 -m "Hotfix v1.0.1"
git push origin main v1.0.1
```

### CI Failures

**Lint エラーの場合:**
```bash
make lint     # エラー内容を確認
make format   # 自動修正できるものを修正
make lint     # 再確認
```

**テスト失敗の場合:**
```bash
make test                              # ローカルで再現確認
swift test --filter TestClassName      # 特定テストのみ実行
```

**パッケージ解決エラーの場合:**
```bash
make clean
swift package resolve --package-path Packages/Core
make test
```

## AI-Assisted Development

このテンプレートは Claude Code・Codex・GitHub Copilot・Gemini CLI に最適化されています。
AI が従うべきルールとパターンは [`AI_CONTEXT.md`](AI_CONTEXT.md) を参照してください。

---
*この文書には英語版 [README.md](README.md) があります。編集時は同一コミットで更新してください。*
