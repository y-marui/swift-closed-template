# AI Context

このファイルを最初に読み、すべての実装判断の基準にしてください。
憲章参照: `docs/dev-charter/CHARTER_INDEX.md` でトピックを特定してから該当ファイルのみ読む

## Context Priority

指示が競合する場合は以下の順で優先してください：

1. **タスクコンテキスト** — Issue / Pull Request の指示（最優先）
2. **プロジェクトコンテキスト** — このファイル（`AI_CONTEXT.md`）
3. **憲章** — `docs/dev-charter/`
4. **グローバルコンテキスト** — AI のデフォルト知識

## Reading Order

AIはタスク開始時に以下の順で参照してください：

1. **[README.md](README.md)** — 概要・セットアップ・コマンド・プロジェクト構造
2. **[DEVELOPING.md](DEVELOPING.md)** — 開発フロー・実装規約・命名規則

必要に応じて以下を参照する（順不同）:

- **[CONTRIBUTING.md](CONTRIBUTING.md)** — PR・Issue ルール・コードレビューチェックリスト
- **[docs/architecture.md](docs/architecture.md)** — モジュール・コンポーネント構造・アーキテクチャ変更履歴
- **[docs/file-map.md](docs/file-map.md)** — ファイルレベルの依存関係（情報が足りない・古い場合は適宜探索し、追記・更新する）
- **[docs/specification.md](docs/specification.md)** — 機能仕様・データフロー
- **[docs/ui-design.md](docs/ui-design.md)** — UI 設計・コンポーネント仕様

---

## Project Overview

<!-- TODO: プロジェクト開始時にこのセクションを記入する -->

**[AppName]** — [アプリの一行説明]

対象: クローズドな Mac app + iOS app（チーム規模: 個人〜3人、将来的に外部委託の可能性あり）

| 項目 | 値 |
|---|---|
| プラットフォーム | macOS XX.0+ / iOS XX.0+ |
| 言語 | Swift 5.9+ |
| UI | SwiftUI |
| ストレージ | [UserDefaults / SwiftData / CloudKit] |
| 外部ライブラリ | なし |

### Xcode Project Settings

```
Product Name:       [AppName]
Bundle Identifiers: [bundle.id]（macOS）/ [bundle.id.ios]（iOS）
Interface:          SwiftUI
Language:           Swift
Deployment Target:  macOS XX.0 / iOS XX.0
```

### Target Structure

```
[AppName]（macOS App）    – Bundle ID: [bundle.id]
[AppName] iOS（iOS App）  – Bundle ID: [bundle.id.ios]
[AppName]Tests / [AppName]UITests
```

### Main Directories

```
Packages/Core/Sources/Core/
├── Features/         – 機能別 UI・ViewModel
├── Domain/           – Model・Protocol・UseCase
├── Infrastructure/   – 永続化・ネットワーク・サービス
└── Shared/           – ユーティリティ・拡張
App/
├── macOS/            – macOS アプリエントリーポイント（常に存在）
│   ├── App.swift          – @main struct XXX: App
│   ├── AppDependency.swift
│   └── RootView.swift
├── iOS/              – iOS ターゲット追加時に作成
│   ├── App.swift          – @main struct XXX: App
│   └── RootView.swift
└── Widget/           – Widget Extension 追加時に作成
    ├── WidgetBundle.swift – @main struct XXX: WidgetBundle
    ├── WidgetView.swift
    ├── Entry.swift        – TimelineEntry
    └── Provider.swift     – TimelineProvider
```

### Build Commands

```bash
# Swift Package
swift build
swift test

# Xcode Project を使う場合
xcodebuild -project "[AppName].xcodeproj" -scheme "[AppName]" build
```

Makefile コマンド: `make bootstrap` / `make lint` / `make format` / `make build` / `make test` / `make clean`

### Localization

実装時に決定。優先順位：ユーザー設定 → システム言語 → 英語

### Monetization

Apple App Store 配信。初回利用から **1 か月間の無料試用**（機能制限なし）、試用終了後は月間/年間サブスクリプションまたは買い切りで継続利用。詳細は `MONETIZATION.md` を参照。

### Scope Exclusions

<!-- TODO: スコープ外の機能を列挙 -->
- （プロジェクト開始時に記入）

---

## Architecture Rules (Strictly Enforced)

- **Feature → Domain**: ✅ Allowed
- **Feature → Infrastructure**: ❌ Forbidden — inject via protocol
- **Domain → Infrastructure**: ❌ Forbidden — Domain must stay pure

## Layer Responsibilities

| Layer | Responsibility | May depend on |
|---|---|---|
| Features | UI, ViewModel, state | Domain only |
| Domain | Models, Protocols, UseCases | Nothing |
| Infrastructure | Network, Persistence, Services | Domain protocols |
| Shared | Utilities, Extensions | Nothing |

---

## Patterns to Follow

- ViewModels use `@MainActor @Observable` (iOS 17+), NOT `ObservableObject`
- UseCase protocols and implementations are `@MainActor`
- Repository protocols and implementations are `@MainActor`
- `AppDependency` is `@MainActor` — Repository・UseCase・ViewModel を統一して生成する
- Views receive ViewModels via `init` injection, stored as `@State`
- ViewModel generation happens in `App.swift` (WindowGroup = `@MainActor`), NOT inside View `init`
- All async operations use `async/await`, NOT Combine / DispatchQueue
- Business logic lives in UseCases, NOT ViewModels
- Repository protocols are defined in Domain; implementations in Infrastructure

---

## Strictly Forbidden

以下は理由を問わず行わないでください：

| 禁止事項 | 代わりに使うもの |
|---|---|
| `ObservableObject` / `@Published` | `@MainActor @Observable` |
| `@StateObject` / `@ObservedObject` | `@State` (for `@Observable`) |
| `Combine` / `PassthroughSubject` | `async/await` |
| `DispatchQueue.main.async` | `@MainActor` / `.task` |
| `import SwiftData` in Domain layer | Infrastructure 層でのみ使う |
| `import UIKit` in Features/Domain | SwiftUI に統一 |
| `force unwrap` (`!`) | `guard let` / `if let` / `throws` |
| ViewModel 内で `APIClient` を直接呼ぶ | UseCase 経由で呼ぶ |
| View 内にビジネスロジックを書く | UseCase に移動する |
| `AnyObject` / 型消去を不必要に使う | 具体的な protocol を定義する |
| `// swiftlint:disable` / `nonisolated(unsafe)` 等の抑制コメント（プロジェクトコード内） | 違反を根本修正する（ファイル分割・メソッド分割・struct 導入等） |

---

## Dependency Policy (Guardrail)

依存追加前に必ず確認してください：

**追加してよい依存:**
- Apple 純正 framework の薄いラッパー（例: KeychainAccess）
- テスト専用ライブラリ（例: Quick/Nimble）— testTarget にのみ追加

**追加してはいけない依存:**
- RxSwift / Combine ベースのライブラリ（async/await に統一）
- 巨大な UI フレームワーク（SwiftUI に統一）
- Domain 層に import が必要になるライブラリ

依存を追加する場合は `Packages/Core/Package.swift` の該当ターゲットに追記し、
`docs/architecture.md` の「アーキテクチャ変更履歴」セクションに理由を記録してください。

---

## File Naming

- `FeatureNameView.swift` — SwiftUI View
- `FeatureNameViewModel.swift` — `@MainActor @Observable` ViewModel
- `FeatureNameUseCase.swift` — `@MainActor` Protocol + implementation (同一ファイル)
- `FeatureNameRepositoryProtocol.swift` — `@MainActor` Repository protocol (Domain)
- `FeatureNameRepository.swift` — `@MainActor` Repository implementation (Infrastructure)

---

## When Adding a Feature

1. Create `Packages/Core/Sources/Core/Features/FeatureName/`
2. Add `FeatureNameView.swift`, `FeatureNameViewModel.swift`, `FeatureNameUseCase.swift`
3. Define Domain model in `Domain/Models/`
4. Define `@MainActor` Repository protocol in `Domain/Repositories/`
5. Implement `@MainActor` Repository in `Infrastructure/Services/`
6. Register in `AppDependency.swift`
7. Add unit tests (`@MainActor` test class) in `Packages/Core/Tests/CoreTests/`

具体的な実装例は `examples/FeatureExample/README.md` を参照してください。

---

## Testing

- Unit テストは `Packages/Core/Tests/CoreTests/` に置く
- 依存はプロトコル経由でモックする
- Given / When / Then 構造で書く

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

## Development Principles

### Development Philosophy (`docs/dev-charter/topics/SOFTWARE_DESIGN_PRINCIPLES.md`)
- まず小さなツールを構築する
- ローカルファーストのデザインを優先する
- インフラストラクチャを最小限に保つ

### Design (`docs/dev-charter/topics/SOFTWARE_DESIGN_PRINCIPLES.md`)
- 高速なインタラクション
- 最小限のUI

### Architecture (`docs/dev-charter/topics/SOFTWARE_DESIGN_PRINCIPLES.md`)
- 最小限の依存関係
- オフライン機能を優先

### Code Design Principles (`docs/dev-charter/PRINCIPLES.md`)
- **変更範囲は必要最小限**（Over-engineering しない）
- **YAGNI 原則**: 今必要ない機能は実装しない
- **DRY の判断**: 2 回の重複では抽象化しない、3 回目で検討
- **既存コードの再利用**: 新規実装前に類似機能がないか確認
- **TODO/FIXME を残さない**: 実装するか、issue として記録する
- **既存コードのパターンに従う**: 命名規則・アーキテクチャ・ディレクトリ構造

### Comment Policy
- コメントは「なぜそうするか」のみ書く
- コードから自明な処理には書かない

---

## UI Guidelines

詳細は [`docs/ui-design.md`](docs/ui-design.md) を参照してください。

### AI UI Rules (Guardrail)

- **SF Symbols を絶対優先** (`Image(systemName: "...")`)
- **Unicode 絵文字禁止**: ボタン・ラベル・装飾等における使用は原則禁止（SF Symbols を使う）
- ライト・ダーク・システムの 3 モードに対応すること
- システムカラー・ネイティブ UI コンポーネントを優先する

---

## Localization

### Supported Languages
アプリ内で選択可能な言語:

1. システム設定 (System)
2. 日本語
3. 英語
4. 中国語
5. ヒンディー語
6. スペイン語
7. フランス語
8. ポルトガル語

### Language Resolution Priority
1. ユーザー設定
2. システム言語設定
3. 英語 (fallback)

---

## Language Policy (Document Language)

- このプロジェクトは **クローズドプロジェクト** のため、ドキュメントは **日本語を正本** とする
- `README.md` は英語（国際的な参照用）、`README-jp.md` が日本語版（正本）
- 日本語と英語の両方が存在する場合は、日本語を主として編集し英語をそれに合わせて更新する

---

## Applied Charter Principles

このプロジェクトに直接影響する憲章原則（`docs/dev-charter/` 配下）：

| 原則 | 参照先 |
|---|---|
| 変更設計原則（変更範囲最小化・YAGNI・DRY・TODO を残さない等） | `PRINCIPLES.md` |
| ソフトウェア設計哲学（ローカルファースト・依存最小化・オフライン優先等） | `topics/SOFTWARE_DESIGN_PRINCIPLES.md` |
| Swift/Xcode 開発環境（XcodeGen・SwiftLint・SwiftFormat・`swift test`・CI 構成等の一般方針） | `topics/swift/SWIFT_DEV_ENV.md` |
| コードコメント・スタイルガイド | `CODE_STYLE.md` |
| シークレット管理・pre-commit・gitleaks | `SECURITY_POLICY.md` |
| UI デザイン・SF Symbols・ダークモード | `UI_GUIDELINES.md` |
| 収益化・App Store・In-App Purchase | `MONETIZATION_POLICY.md` |
| ライセンス（All Rights Reserved） | `LEGAL_POLICY.md` |
| git ワークフロー・Conventional Commits | `PROJECT_LIFECYCLE.md` |
| ローカライズ方針 | `LOCALIZATION_POLICY.md` |

---

## Monetization Policy

- Apple App Store で配布する macOS / iOS アプリは **1 か月間の無料試用 → 月間/年間サブスクリプションまたは買い切り** を採用する
  - 試用期間中はすべての機能を利用可能にし、機能制限を設けない
  - macOS 版と iOS 版は同一購入に含め、購入権利を共有する
- 独自の課金システムは禁止（メンテナンスコスト・セキュリティリスク）
- 詳細は `MONETIZATION.md` を参照する

---

## Security Policy

pre-commit フック（`.pre-commit-config.yaml` + gitleaks）でシークレット漏洩・`.env` コミット等は自動ブロックされる。
AIが守るべき手動ルールのみ記載する。

- API キー・パスワード・トークンをコードに書かない（環境変数または Secret Manager を使う）
- 誤ってコミットしたシークレットは、履歴から削除した上で即座にローテーションする
- シークレットを含むファイルやコードを AI に渡さない（プロンプト・コンテキストファイル・スクリーンショット含む）
- AI が生成したコードは必ずレビューしてからコミットする（SQL インジェクション・ハードコードされた認証情報等を確認）
- AI との会話ログをリポジトリにコミットしない

---

## Document Sync Rule

仕様・ルール・構成に変更が生じたとき、変更と同じ作業内で関連ドキュメントを更新する。
対象は `docs/` 内のファイルに限らず、`AI_CONTEXT.md`・`README.md` 等のルートファイルも含む。

---

## Git Operations

- **コミット粒度**: 機能単位・動作確認 OK 後
- **コミットメッセージ**: Conventional Commits 形式（`feat` / `fix` / `refactor` / `docs`）
- **WIP 禁止**: 動作しないコードはコミットしない
- **`main` へのコミット**: 他の開発者がレビューする。個人開発では実装担当と異なる AI によるレビューとオーナーの最終確認で代替できる（`docs/dev-charter/SECURITY_POLICY.md` の Code Review 参照）

---

## AI Collaboration Rules

### AI Behavior Principles
- **Scope（スコープ厳守）**: 会話の主題・タスク・ゴールを AI が勝手に変更しない。話題変更はユーザーが明示するか、AI の提案をユーザーが許可した場合のみ
- **Uncertainty（不明点の扱い）**: 重要な情報不足や曖昧さは質問する。軽微な不足は合理的な仮定で補い、仮定を明示する。推測で断定しない

### Pre-Coding Confirmation
不明・未定の項目があれば**作業前に 1 回でまとめて**質問する。推測で進めない。

**確認必須:**
- ゴール（完了条件）
- 言語・FW・バージョン制約
- 新規 or 既存コード修正
- テストの要否
- 影響範囲

**確認不要（既存コードに合わせて進める）:**
- コードスタイル / ファイル配置 / 軽微な実装詳細

### Error & Debug Handling
- エラー発生時は**原因分析 → 修正方針説明 → 実装**の順で進める
- エラーログ・スタックトレースは必ず全文確認してから対応
- 推測で修正しない（必要なら既存コードを確認）
- デバッグ用の `console.log` / `print` 文は本番コードに残さない

### Work Stance
- 大きな変更前に方針を説明してから着手する
- 不要な依存追加禁止: 既存の依存で解決できないか先に検討する

### dev-charter Modification Rules
`docs/dev-charter/` 配下のファイルは**直接編集しない**。
- 変更が必要な場合は dev-charter リポジトリ本体に Issue を立て、`git subtree pull` でアップデートを取り込む
- プロジェクト固有のルールは `AI_CONTEXT.md` または専用ファイルに記載する

### AI Tool Assignments

- **使用ツール**：Claude Code、Codex、GitHub Copilot、Gemini CLI
- **標準担当の正本**：`docs/dev-charter/AI_COLLABORATION_RULES.md` の「AI Tool Responsibilities」と「Rules for Multi-AI Usage」
- **プロジェクト固有の上書き**：なし

---

## When You Are Unsure

判断に迷ったときは以下の順で確認してください：

1. `docs/architecture.md` — レイヤー図とデータフローを確認
2. `docs/file-map.md` — ファイルの依存関係を確認
3. `docs/specification.md` — 機能仕様・動作定義を確認
4. `examples/FeatureExample/README.md` — 具体的な実装例を確認
5. `ExampleFeature/` の既存コード — 実際のパターンを確認
6. それでも不明な場合は**実装を止めて質問する**（間違った方向に進まない）

---

## What NOT to Change Without Discussion

以下はプロジェクトオーナーの承認なく変更しないでください：

- `AI_CONTEXT.md` 自体の内容
- `docs/architecture.md` のレイヤー構造
- `AppDependency.swift` の設計方針
- `Packages/Core/Package.swift` への依存追加
- `.swiftlint.yml` の `force_unwrapping` ルール
