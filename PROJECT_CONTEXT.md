# Project Context

> **AIへの指示:** このファイルの `<!-- TODO -->` をすべてプロジェクト固有の情報に置き換えてください。
> 置き換えが完了したら、この指示行を削除してください。

---

## Overview

<!-- TODO: アプリの概要を1〜3文で説明してください。例:
「家計簿アプリ。支出を記録・可視化し、月ごとの予算管理をサポートする。」
-->

- **アプリ名:** <!-- TODO: 例: MyApp -->
- **Bundle ID:** <!-- TODO: 例: com.yourcompany.myapp -->
- **ターゲット:** iOS 17+ / macOS 14+
- **チーム規模:** <!-- TODO: 例: 個人 / 2〜3人 -->

---

## Architecture

Clean Architecture with unidirectional data flow.

```
App/
├── App.swift            # Entry point, creates AppDependency
├── RootView.swift       # Root navigation
└── AppDependency.swift  # DI container

Packages/Core/Sources/Core/
├── Features/            # UI + ViewModel (depends on Domain only)
├── Domain/              # Models, Protocols, UseCases (no dependencies)
├── Infrastructure/      # Network, Persistence (implements Domain protocols)
└── Shared/              # Utilities, Extensions
```

## Dependency Rules

- Feature → Domain ✅
- Feature → Infrastructure ❌
- Domain → Infrastructure ❌

---

## Features

<!-- TODO: 実装予定または実装済みのフィーチャー一覧。例:
| フィーチャー | 状態 | 説明 |
|---|---|---|
| TodoList | ✅ 実装済み | タスクの一覧表示・追加・削除 |
| Auth | 🚧 実装中 | メールアドレスでのサインイン |
| Settings | 📋 未着手 | 通知・テーマの設定 |
-->

| フィーチャー | 状態 | 説明 |
|---|---|---|
| ExampleFeature | 📋 削除予定 | テンプレートのサンプル。最初の本番フィーチャー完成後に削除 |

---

## Key Technology Choices

| Concern | Solution |
|---|---|
| State management | `@Observable` (Swift 5.9+) |
| Persistence | SwiftData <!-- TODO: 不要なら削除 --> |
| Networking | URLSession + async/await <!-- TODO: 不要なら削除 --> |
| Dependency Injection | Manual (AppDependency) |
| Testing | XCTest + mocks |

---

## Environment

<!-- TODO: 環境変数・APIキー・エンドポイントを記載してください。例:
| 変数名 | 設定場所 | 説明 |
|---|---|---|
| BASE_URL | Xcode Scheme > Environment Variables | APIのベースURL |
| API_KEY | Xcode Scheme > Environment Variables | 外部サービスのAPIキー |
-->

| 変数名 | 設定場所 | 説明 |
|---|---|---|
| BASE_URL | Xcode Scheme > Environment Variables | APIのベースURL |

**注意:** APIキーを `.env` ファイルやコードに直接書かないでください。
Xcode の Scheme > Run > Environment Variables に設定してください。

---

## 新規プロジェクト適用時のチェックリスト

このテンプレートを新しいプロジェクトに適用したら、以下を順番に完了させてください。

- [ ] このファイルの `<!-- TODO -->` をすべて埋める
- [ ] `App/App.swift` の `ExampleApp` をプロジェクト名に変更する
- [ ] `README.md` / `README-jp.md` の CI バッジの URL を実際のリポジトリ URL に変更する
- [ ] Xcode プロジェクトを作成し `Packages/Core` をローカルパッケージとして追加する
- [ ] `make bootstrap` を実行してツールをインストールする（pre-commit hooks も自動インストールされる）
- [ ] `make test` が通ることを確認する
- [ ] CI が GitHub Actions で動作することを確認する（security / lint / test の 3 ジョブ）
- [ ] 最初の本番フィーチャーが動作したら `ExampleFeature` を削除する（手順: `docs/maintenance.md`）
