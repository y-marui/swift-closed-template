# Swift App Template

> **このファイルは正本（日本語版）です。**
> 英語版（参照）は [README.md](README.md) を参照してください。

[![License: All Rights Reserved](https://img.shields.io/badge/License-All%20Rights%20Reserved-red.svg)](LICENSE)
[![CI](https://github.com/y-marui/swift-closed-template/actions/workflows/ci.yml/badge.svg)](https://github.com/y-marui/swift-closed-template/actions/workflows/ci.yml)
[![Charter Check](https://github.com/y-marui/swift-closed-template/actions/workflows/dev-charter-check.yml/badge.svg)](https://github.com/y-marui/swift-closed-template/actions/workflows/dev-charter-check.yml)

小規模チーム・AI支援開発・長期保守を前提に最適化されたテンプレートです。

## 使い方

1. GitHub で **"Use this template"** → **"Create a new repository"** をクリック
2. リポジトリをクローンして `cd` で移動
3. `make bootstrap` でツールをインストールしてパッケージを解決
4. Xcode でリポジトリルートに新規 iOS App プロジェクトを作成し、`Packages/Core` をローカルパッケージとして追加
5. すべての `Example` をフィーチャー名に置き換える（[AI_CONTEXT.md](AI_CONTEXT.md) 参照）
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
- [仕様](docs/specification.md)
- [UI 設計](docs/ui-design.md)
- [ファイルマップ](docs/file-map.md)

開発フロー・命名規則・コードレビューチェックリストは [`CONTRIBUTING.md`](CONTRIBUTING.md) を参照してください。

## ランブック

### Xcode プロジェクトのセットアップ（新規）

1. Xcode > File > New > Project で iOS App を作成
2. プロジェクト名・Bundle ID を設定し、このリポジトリのルートに保存
3. Xcode > File > Add Package Dependencies を開く
4. 「Add Local...」で `Packages/Core` を選択
5. App ターゲットに `Core` ライブラリを追加
6. `App/` フォルダ内のファイルをプロジェクトに追加
7. `make test` が通ることを確認

### 新しいフィーチャーの追加

```bash
FEATURE=MyFeature
mkdir -p Packages/Core/Sources/Core/Features/$FEATURE
cp templates/feature/View.swift.template      Packages/Core/Sources/Core/Features/$FEATURE/${FEATURE}View.swift
cp templates/feature/ViewModel.swift.template Packages/Core/Sources/Core/Features/$FEATURE/${FEATURE}ViewModel.swift
cp templates/feature/UseCase.swift.template   Packages/Core/Sources/Core/Features/$FEATURE/${FEATURE}UseCase.swift
```

`{{FeatureName}}` を実際のフィーチャー名に置換してください。

### リリースフロー

```
feature/xxx → develop → main → タグ付け
```

1. `feature/xxx` ブランチで開発
2. `develop` へ PR を出す（CI が通ることを確認）
3. リリース前に `develop` → `main` へ PR
4. `main` マージ後にタグを打つ

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### ホットフィックス

```bash
git checkout main
git checkout -b hotfix/issue-description
# 修正・テスト
make test
git checkout main && git merge hotfix/issue-description
git checkout develop && git merge hotfix/issue-description
git tag -a v1.0.1 -m "Hotfix v1.0.1"
git push origin main develop v1.0.1
```

### CI が失敗したとき

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

## AI 支援開発

このテンプレートは Claude Code と GitHub Copilot に最適化されています。
AI が従うべきルールとパターンは [`AI_CONTEXT.md`](AI_CONTEXT.md) を参照してください。
