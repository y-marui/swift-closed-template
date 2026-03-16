# Swift AI App Template

> **このファイルは正本（日本語版）です。**
> 英語版（参照）は [README.md](README.md) を参照してください。

![CI](https://github.com/y-marui/swift-app-template/actions/workflows/ci.yml/badge.svg)

小規模チーム・AI支援開発・長期保守を前提に最適化されたテンプレートです。

## 使い方

1. GitHub で **"Use this template"** → **"Create a new repository"** をクリック
2. リポジトリをクローンして `cd` で移動
3. `make bootstrap` でツールをインストールしてパッケージを解決
4. Xcode でリポジトリルートに新規 iOS App プロジェクトを作成し、`Packages/Core` をローカルパッケージとして追加
5. すべての `Example` をフィーチャー名に置き換える（`docs/development.md` 参照）
6. `PROJECT_CONTEXT.md` をアプリの情報で更新する

## 特徴

- ✅ Clean Architecture（Feature / Domain / Infrastructure）
- ✅ `@Observable` ViewModel（iOS 17+）
- ✅ `AppDependency` による手動依存注入
- ✅ SwiftData 永続化レイヤー
- ✅ `URLSession` + async/await ネットワーク
- ✅ モック付き XCTest
- ✅ SwiftLint + SwiftFormat 設定済み
- ✅ GitHub Actions CI（lint + test）
- ✅ AI 向けコンテキストファイル（`AI_CONTEXT.md`、`PROJECT_CONTEXT.md`）

## 動作要件

- Xcode 15+
- iOS 17+ / macOS 14+
- Swift 5.9+

## クイックスタート

```bash
git clone https://github.com/y-marui/swift-app-template.git
cd swift-app-template
make bootstrap
```

その後、Xcode で新規 iOS プロジェクトを作成し、`Packages/Core` をローカルパッケージとして追加してください。
詳細は `Package.swift` のコメントを参照。

## コマンド一覧

| コマンド | 説明 |
|---|---|
| `make bootstrap` | ツールのインストールとパッケージ解決 |
| `make lint` | SwiftLint を実行 |
| `make format` | SwiftFormat を実行 |
| `make test` | 全テストを実行 |
| `make build` | Xcode でビルド（`.xcodeproj` がある場合）または `swift build` |
| `make clean` | ビルド成果物を削除（`build/`、`.build/`） |

`make build` は `.xcodeproj` を自動検出し、iOS Simulator（iPhone 16）向けに `build/` へビルドします。
デフォルトは環境変数で上書き可能です：

```bash
DESTINATION="platform=iOS Simulator,name=iPhone 15" make build
SCHEME=MyApp make build
```

## プロジェクト構造

```
Package.swift           # ルート — テスト実行・パッケージ管理用
App/                    # エントリーポイントと DI コンテナ
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

## ドキュメント

- [アーキテクチャ](docs/architecture.md)
- [開発ガイド](docs/development.md)
- [メンテナンス](docs/maintenance.md)
- [ランブック](docs/runbook.md)

## AI 支援開発

このテンプレートは Claude Code と GitHub Copilot に最適化されています。
AI が従うべきルールとパターンは [`AI_CONTEXT.md`](AI_CONTEXT.md) を参照してください。
