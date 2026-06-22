# Developing Guide

ビルド・テスト・実装規約・命名規則など、開発者向けの情報をまとめています。

## セットアップ

[README-jp.md](README-jp.md) のセットアップ手順に従ってください。

### Xcode 設定

DerivedData をプロジェクト内（`DerivedData/`）に配置することで `make clean` で一括削除できる。

初回セットアップ時に以下を実施する：

1. `~/Library/Developer/Xcode/DerivedData/` を削除（任意）
2. Xcode > Settings（⌘,）> Locations > Derived Data: **Relative** を選択

---

## ロードマップ

<!-- TODO: プロジェクト開始時に Step を記入する -->

| Step | 内容 | 状態 |
|---|---|---|
| 01 | [機能名] | 未着手 |
| 02 | [機能名] | 未着手 |
| 03 | [機能名] | 未着手 |
| 04 | [機能名] | 未着手 |
| 05 | [機能名] | 未着手 |
| 06 | 収益化（購入ダイアログ・StoreKit 2） | 未着手 |
| 07 | ローカライズ | 未着手 |
| 08 | Polish + App Store 提出 | 未着手 |

---

## 日常コマンド

```bash
make lint     # SwiftLint でコード品質チェック
make format   # SwiftFormat でコード整形
make test     # テスト実行
make build    # ビルド
make clean    # ビルド成果物削除
```

---

## 機能追加ワークフロー

### 1. ディレクトリを作成

```bash
mkdir -p Packages/Core/Sources/Core/Features/NewFeature/
```

### 2. ViewModel の追加

```bash
cp templates/feature/ViewModel.swift.template \
  Packages/Core/Sources/Core/Features/NewFeature/NewFeatureViewModel.swift
```

`{{FeatureName}}` を実際の名前に置き換えてください。

### 3. View の追加

```bash
cp templates/feature/View.swift.template \
  Packages/Core/Sources/Core/Features/NewFeature/NewFeatureView.swift
```

### 4. UseCase / Repository の追加（必要な場合）

```bash
cp templates/feature/UseCase.swift.template \
  Packages/Core/Sources/Core/Domain/UseCases/NewFeatureUseCase.swift
```

### 5. AppDependency.swift に登録

```swift
let newFeatureUseCase = NewFeatureUseCaseImpl(repository: newFeatureRepository)
let newFeatureViewModel = NewFeatureViewModel(useCase: newFeatureUseCase)
```

詳細は `examples/FeatureExample/README.md` を参照してください。

---

## テスト

テストは `Packages/Core/Tests/CoreTests/` に配置します。Given / When / Then 構造で記述してください：

```swift
func test_onAppear_loadsItems() async {
    // Given
    let mock = MockUseCase(result: .success([...]))
    let sut = MyViewModel(useCase: mock)

    // When
    await sut.onAppear()

    // Then
    XCTAssertEqual(...)
}
```

---

## コーディング規約

詳細は [AI_CONTEXT.md](AI_CONTEXT.md) を参照してください。

### 要点

- `@Observable` + `@MainActor` を使う（`ObservableObject` 禁止）
- `async/await` を使う（`Combine` 禁止）
- View にビジネスロジックを書かない
- `guard let` / `if let` を使う（force unwrap `!` 禁止）
- ビジネスロジックは UseCase に、UI 状態は ViewModel に

---

## 開発フロー

### ブランチ戦略

```
feature/xxx → step0N-xxx → main → タグ付け
```

- `main`: リリース済みコード
- `step0N-xxx`: 現在の Step ブランチ（ロードマップの Step 単位）
- `feature/xxx`: 機能単位の作業ブランチ

Step ブランチを使わない場合:

```
feature/xxx → develop → main → タグ付け
```

コミットは Conventional Commits 形式：

```
feat: 新機能の追加
fix: バグ修正
refactor: リファクタリング
docs: ドキュメント更新
```

### リリース手順

1. `main` ブランチに PR をマージ
2. CI（lint / build）がグリーンであることを確認
3. `git tag v1.x.x` でタグを打つ
4. Xcode Organizer でアーカイブ・提出

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### ホットフィックス手順

```bash
git checkout -b hotfix/issue-description main

# 修正・テスト
make test

git checkout main && git merge hotfix/issue-description
git tag -a v1.0.1 -m "Hotfix v1.0.1"
git push origin main v1.0.1
```

---

## 命名規則

| 種別 | 規則 | 例 |
|---|---|---|
| Feature ディレクトリ | UpperCamelCase | `UserProfile/` |
| Swift ファイル | UpperCamelCase | `UserProfileView.swift` |
| テストファイル | 対象クラス名 + Tests | `UserProfileViewModelTests.swift` |
| ドキュメント | kebab-case | `architecture-evolution.md` |

---

## 依存パッケージの管理

このプロジェクトはサードパーティ依存を持たない設計です。
SwiftData / URLSession など Apple 純正 framework のみを使用しています。

### 追加してよい依存

- Apple 純正 framework の薄いラッパー（例: KeychainAccess）
- テスト専用ライブラリ（例: Quick/Nimble）— testTarget にのみ追加

### 追加してはいけない依存

- RxSwift / Combine ベースのライブラリ（async/await に統一）
- 巨大な UI フレームワーク（SwiftUI に統一）
- Domain 層に import が必要になるライブラリ

依存を追加する場合は `Packages/Core/Package.swift` の該当ターゲットに追記し、
`docs/architecture.md` の「アーキテクチャ変更履歴」セクションに理由を記録してください。

---

## SwiftLint ルールの変更

`.swiftlint.yml` を変更する際のルール：

- ルールを **無効化** する場合 → PR に理由を必ず記載する
- ルールを **追加** する場合 → 全ファイルに違反がないことを確認してからマージ
- `force_unwrapping` は原則 warning のまま維持する（`!` は使わない）

---

## トラブルシューティング

### Lint エラー

```bash
make format   # 自動修正
make lint     # 再チェック
```

### ビルド失敗

```bash
make clean
make build    # フル出力で確認
```

### パッケージ解決の問題

```bash
# Swift Package Manager
swift package resolve

# Xcode Project の場合
xcodebuild -resolvePackageDependencies -project "[AppName].xcodeproj"
```

---

## デバッグ

<!-- TODO: プロジェクト固有のデバッグ手順をここに記入する -->

デバッグ用の `print` 文は本番コードに残さないでください。

---

## Xcode プロジェクト作成時の手順

テンプレートは `.xcodeproj` を含まない。新規プロジェクト開始時に Xcode で作成する。

### 1. プロジェクト作成

Xcode > File > New > Project でアプリを作成する。

- **保存先**: このリポジトリのルートディレクトリ
- **Interface**: SwiftUI
- **Language**: Swift
- **Include Tests**: チェックしてもしなくても良い（後述）

### 2. ソースファイルの配置

Xcode が生成するアプリソース（`[AppName]App.swift` 等）を `App/` に移動する。
プラットフォームが複数の場合は `App/macOS/`・`App/iOS/` に分ける。

```
App/
├── macOS/
│   ├── [AppName]App.swift
│   ├── AppDependency.swift
│   └── RootView.swift
└── iOS/
    ├── [AppName]iOSApp.swift
    └── iOSRootView.swift
```

Xcode のプロジェクトナビゲーターでもフォルダ参照を `App/` に合わせること。

### 3. Core パッケージを追加

Xcode > File > Add Package Dependencies...

ローカルパッケージとして `Packages/Core` を追加し、アプリターゲットにリンクする。

### 4. 自動生成されたテストターゲットの扱い

Xcode が自動生成する `[AppName]Tests`・`[AppName]UITests` はユニットテストを置く場所ではない（ユニットテストは `Packages/Core/Tests/CoreTests/` に置く）。

- **削除推奨**: ロジックテストは Core 側に集約するため、不要なら削除してよい
- **残す場合**: UI テスト（XCUITest）のみに限定して使う

### 5. `.gitignore` の確認

自動生成された `[AppName].xcodeproj/xcuserdata/` 等がコミットされないことを確認する。

---

## Example コードの削除手順

`ExampleFeature` はテンプレートのサンプルです。
実際のプロジェクト開始後、最初の本番フィーチャーが動作したら以下を削除してください。

```bash
rm -rf Packages/Core/Sources/Core/Features/ExampleFeature/
rm Packages/Core/Sources/Core/Domain/Models/ExampleItem.swift
rm Packages/Core/Sources/Core/Domain/Repositories/ExampleRepositoryProtocol.swift
rm Packages/Core/Sources/Core/Domain/UseCases/UseCasePlaceholder.swift
rm Packages/Core/Sources/Core/Infrastructure/Network/APIClient.swift        # 独自実装に置き換えた場合
rm Packages/Core/Sources/Core/Infrastructure/Persistence/ExampleItemRecord.swift
rm Packages/Core/Sources/Core/Infrastructure/Services/ExampleRepository.swift
```

その後 `make test` が通ることを確認してください。
