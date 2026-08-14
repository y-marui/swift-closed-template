# Developing Guide

ビルド・テスト・実装規約・命名規則など、開発者向けの情報をまとめています。

## Setup

[README-jp.md](README-jp.md) のセットアップ手順に従ってください。

### Xcode Configuration

DerivedData をプロジェクト内（`DerivedData/`）に配置することで `make clean` で一括削除できる。

初回セットアップ時に以下を実施する：

1. `~/Library/Developer/Xcode/DerivedData/` を削除（任意）
2. Xcode > Settings（⌘,）> Locations > Derived Data: **Relative** を選択

---

## Roadmap

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

## Daily Commands

```bash
make lint     # SwiftLint でコード品質チェック
make format   # SwiftFormat でコード整形
make test     # テスト実行
make build    # ビルド
make clean    # ビルド成果物削除
```

---

## Feature Addition Workflow

### 1. Create the Directory

```bash
mkdir -p Packages/Core/Sources/Core/Features/NewFeature/
```

### 2. Add the ViewModel

```bash
cp templates/feature/ViewModel.swift.template \
  Packages/Core/Sources/Core/Features/NewFeature/NewFeatureViewModel.swift
```

`{{FeatureName}}` を実際の名前に置き換えてください。

### 3. Add the View

```bash
cp templates/feature/View.swift.template \
  Packages/Core/Sources/Core/Features/NewFeature/NewFeatureView.swift
```

### 4. Add UseCase / Repository (If Needed)

```bash
cp templates/feature/UseCase.swift.template \
  Packages/Core/Sources/Core/Domain/UseCases/NewFeatureUseCase.swift
```

### 5. Register in AppDependency.swift

```swift
let newFeatureUseCase = NewFeatureUseCaseImpl(repository: newFeatureRepository)
let newFeatureViewModel = NewFeatureViewModel(useCase: newFeatureUseCase)
```

詳細は `examples/FeatureExample/README.md` を参照してください。

---

## Testing

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

## Coding Conventions

詳細は [AI_CONTEXT.md](AI_CONTEXT.md) を参照してください。

### Key Points

- `@Observable` + `@MainActor` を使う（`ObservableObject` 禁止）
- `async/await` を使う（`Combine` 禁止）
- View にビジネスロジックを書かない
- `guard let` / `if let` を使う（force unwrap `!` 禁止）
- ビジネスロジックは UseCase に、UI 状態は ViewModel に

---

## Development Flow

### Branch Strategy

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

### Release Steps

1. `main` ブランチに PR をマージ
2. CI（lint / build）がグリーンであることを確認
3. `git tag v1.x.x` でタグを打つ
4. Xcode Organizer でアーカイブ・提出

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### Hotfix Steps

```bash
git checkout -b hotfix/issue-description main

# 修正・テスト
make test

git checkout main && git merge hotfix/issue-description
git tag -a v1.0.1 -m "Hotfix v1.0.1"
git push origin main v1.0.1
```

---

## Naming Conventions

| 種別 | 規則 | 例 |
|---|---|---|
| Feature ディレクトリ | UpperCamelCase | `UserProfile/` |
| Swift ファイル | UpperCamelCase | `UserProfileView.swift` |
| テストファイル | 対象クラス名 + Tests | `UserProfileViewModelTests.swift` |
| ドキュメント | kebab-case | `architecture-evolution.md` |

---

## Dependency Package Management

このプロジェクトはサードパーティ依存を持たない設計です。
SwiftData / URLSession など Apple 純正 framework のみを使用しています。

### Dependencies You May Add

- Apple 純正 framework の薄いラッパー（例: KeychainAccess）
- テスト専用ライブラリ（例: Quick/Nimble）— testTarget にのみ追加

### Dependencies You Must Not Add

- RxSwift / Combine ベースのライブラリ（async/await に統一）
- 巨大な UI フレームワーク（SwiftUI に統一）
- Domain 層に import が必要になるライブラリ

依存を追加する場合は `Packages/Core/Package.swift` の該当ターゲットに追記し、
`docs/architecture.md` の「アーキテクチャ変更履歴」セクションに理由を記録してください。

---

## Changing SwiftLint Rules

`.swiftlint.yml` を変更する際のルール：

- ルールを **無効化** する場合 → PR に理由を必ず記載する
- ルールを **追加** する場合 → 全ファイルに違反がないことを確認してからマージ
- `force_unwrapping` は原則 warning のまま維持する（`!` は使わない）

---

## Troubleshooting

### Lint Errors

```bash
make format   # 自動修正
make lint     # 再チェック
```

### Build Failures

```bash
make clean
make build    # フル出力で確認
```

### Package Resolution Issues

```bash
# Swift Package Manager
swift package resolve

# Xcode Project の場合
xcodebuild -resolvePackageDependencies -project "[AppName].xcodeproj"
```

---

## Debugging

<!-- TODO: プロジェクト固有のデバッグ手順をここに記入する -->

デバッグ用の `print` 文は本番コードに残さないでください。

---

## Steps for Creating the Xcode Project

テンプレートは `.xcodeproj` を含まない。新規プロジェクト開始時に Xcode で作成する。

### 1. Create the Project

Xcode > File > New > Project でアプリを作成する。

- **保存先**: このリポジトリのルートディレクトリ
- **Interface**: SwiftUI
- **Language**: Swift
- **Include Tests**: チェックしてもしなくても良い（後述）

### 2. Place the Source Files

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

### 3. Add the Core Package

Xcode > File > Add Package Dependencies...

ローカルパッケージとして `Packages/Core` を追加し、アプリターゲットにリンクする。

### 4. Handling Auto-Generated Test Targets

Xcode が自動生成する `[AppName]Tests`・`[AppName]UITests` はユニットテストを置く場所ではない（ユニットテストは `Packages/Core/Tests/CoreTests/` に置く）。

- **削除推奨**: ロジックテストは Core 側に集約するため、不要なら削除してよい
- **残す場合**: UI テスト（XCUITest）のみに限定して使う

### 5. Check `.gitignore`

自動生成された `[AppName].xcodeproj/xcuserdata/` 等がコミットされないことを確認する。

### 6. Bundle ID When Combining macOS + iOS + Widget

`project.yml` の Widget（`type: app-extension`, `supportedDestinations: [iOS, macOS]`）を
macOS App と iOS App の**両方**に埋め込む場合、Bundle ID は以下の規則に必ず従うこと：

- macOS App: `y.marui.<AppName>`
- iOS App: `y.marui.<AppName>.iOS`（macOS と共通化しない）
- Widget（単一ターゲットのまま SDK 条件で出し分ける）:
  ```yaml
  PRODUCT_BUNDLE_IDENTIFIER: y.marui.<AppName>.Widget
  PRODUCT_BUNDLE_IDENTIFIER[sdk=iphone*]: y.marui.<AppName>.iOS.Widget
  ```

**理由**: Apple の要件により、埋め込まれる Extension の Bundle ID は親アプリの Bundle ID を
接頭辞に持たなければならない（`Embedded binary's bundle identifier is not prefixed with the
parent app's bundle identifier` エラー）。macOS App と iOS App の Bundle ID を共通化（Universal
Purchase 的な構成）して回避するのではなく、Widget 側を SDK 条件付きで出し分けるのが y-marui
プロジェクト共通の規約。`project.yml` の Widget ターゲットのコメントアウトを解除する際は、
`PRODUCT_BUNDLE_IDENTIFIER[sdk=iphone*]` の行を削除しないこと。

---

## Steps to Remove Example Code

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
