# AI Context

このファイルを最初に読み、すべての実装判断の基準にしてください。
**通常セッションでは `docs/dev-charter/` を直接読まず、このファイルのみを参照してください。**

## コンテキスト優先順位

指示が競合する場合は以下の順で優先してください：

1. **タスクコンテキスト** — Issue / Pull Request の指示（最優先）
2. **プロジェクトコンテキスト** — このファイル（`AI_CONTEXT.md`）・`PROJECT_CONTEXT.md`
3. **開発憲章** — `docs/dev-charter/`（通常は本ファイルに統合済み）
4. **グローバルコンテキスト** — AI のデフォルト知識

対象: クローズドな Mac app + iOS app

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

## Development Principles

### 開発哲学
- まず小さなツールを構築する
- ローカルファーストのデザインを優先する
- インフラストラクチャを最小限に保つ
- オフライン機能を優先

### コード設計原則
- **変更範囲は必要最小限**（Over-engineering しない）
- **YAGNI 原則**: 今必要ない機能は実装しない
- **DRY の判断**: 2 回の重複では抽象化しない、3 回目で検討
- **既存コードの再利用**: 新規実装前に類似機能がないか確認
- **TODO/FIXME を残さない**: 実装するか、issue として記録する
- **既存コードのパターンに従う**: 命名規則・アーキテクチャ・ディレクトリ構造

### コメント方針
- コメントは「なぜそうするか」のみ書く
- コードから自明な処理には書かない

---

## UI Guidelines

### 外観モード
- ライト・ダーク・システムの 3 モードに対応し、ユーザーが設定から選択できるようにする

### カラーパレット

| モード | 背景 | 文字 | 強調（テキスト） |
|---|---|---|---|
| ライト | #FFFFFF | #4e454a | #000000 |
| ダーク | #000000 | #bab1b6 | #FFFFFF |

- アクセントカラーと装飾: ライト/ダーク間で色相・彩度を維持しつつ明度を反転
- システムカラーを優先
- ネイティブ UI コンポーネントを優先

### アイコノグラフィ
- **SF Symbols を絶対優先** (`Image(systemName: "...")`)
- **Unicode 絵文字禁止**: ボタン・ラベル・装飾等における使用は原則禁止（SF Symbols を使う）

---

## Localization

### 対応言語
アプリ内で選択可能な言語:

1. システム設定 (System)
2. 日本語
3. 英語
4. 中国語
5. ヒンディー語
6. スペイン語
7. フランス語
8. ポルトガル語

### 言語決定の優先順位
1. ユーザー設定
2. システム言語設定
3. 英語 (fallback)

---

## Language Policy (ドキュメント言語)

- このプロジェクトは **クローズドプロジェクト** のため、ドキュメントは **日本語を正本** とする
- `README.md` は英語（国際的な参照用）、`README-jp.md` が日本語版（正本）
- 日本語と英語の両方が存在する場合は、日本語を主として編集し英語をそれに合わせて更新する

---

## Monetization Policy

- クローズドな Mac app / iOS app は **Sublime Text 方式** を採用する
  - 時々購入を促すポップアップを表示し、正式購入で解除
- 独自の課金システムは禁止（メンテナンスコスト・セキュリティリスク）
- 本格的にマネタイズを検討する場合は `MONETIZATION.md` を作成し、その概要を `AI_CONTEXT.md` に記載する

---

## Security Policy

pre-commit フック（`.pre-commit-config.yaml` + gitleaks）でシークレット漏洩・`.env` コミット等は自動ブロックされる。
AIが守るべき手動ルールのみ記載する。

- API キー・パスワード・トークンをコードに書かない（環境変数または Secret Manager を使う）
- シークレットを含むファイルやコードを AI に渡さない（プロンプト・コンテキストファイル・スクリーンショット含む）
- AI が生成したコードは必ずレビューしてからコミットする（SQL インジェクション・ハードコードされた認証情報等を確認）
- AI との会話ログをリポジトリにコミットしない

---

## Git Operations

- **コミット粒度**: 機能単位・動作確認 OK 後
- **コミットメッセージ**: Conventional Commits 形式（`feat` / `fix` / `refactor` / `docs`）
- **WIP 禁止**: 動作しないコードはコミットしない
- **`main` へのコミット**: 必ず他の開発者がレビューする

---

## AI Collaboration Rules

### AI 行動原則
- **Scope（スコープ厳守）**: 会話の主題・タスク・ゴールを AI が勝手に変更しない。話題変更はユーザーが明示するか、AI の提案をユーザーが許可した場合のみ
- **Uncertainty（不明点の扱い）**: 重要な情報不足や曖昧さは質問する。軽微な不足は合理的な仮定で補い、仮定を明示する。推測で断定しない

### コーディング前の確認
不明・未定の項目があれば**作業前に 1 回でまとめて**質問する。推測で進めない。

**確認必須:**
- ゴール（完了条件）
- 言語・FW・バージョン制約
- 新規 or 既存コード修正
- テストの要否
- 影響範囲

**確認不要（既存コードに合わせて進める）:**
- コードスタイル / ファイル配置 / 軽微な実装詳細

### エラー・デバッグ対応
- エラー発生時は**原因分析 → 修正方針説明 → 実装**の順で進める
- エラーログ・スタックトレースは必ず全文確認してから対応
- 推測で修正しない（必要なら既存コードを確認）
- デバッグ用の `print` 文は本番コードに残さない

### 作業スタンス
- 大きな変更前に方針を説明してから着手する
- 不要な依存追加禁止: 既存の依存で解決できないか先に検討する

### AI ツールの役割分担
| ツール | 担当 |
|---|---|
| **Claude Code** | プロジェクト立ち上げ・大規模コード変更・アーキテクチャ設計とリファクタリング提案 |
| **GitHub Copilot** | バグ修正・細かな実装とコーディング補助・単体テスト作成 |
| **Gemini CLI** | プライバシーポリシー・ストア説明文・審査用ドキュメント・プロジェクト全体のドキュメント管理 |

- Claude Code 作業中は Copilot 提案を**参考程度**に（盲目的に受け入れない）
- Copilot の提案がプロジェクト規約に反する場合は無視し、Claude Code でレビュー後に採用

---

## When You Are Unsure

判断に迷ったときは以下の順で確認してください：

1. `docs/architecture.md` — レイヤー図とデータフローを確認
2. `examples/FeatureExample/README.md` — 具体的な実装例を確認
3. `ExampleFeature/` の既存コード — 実際のパターンを確認
4. それでも不明な場合は**実装を止めて質問する**（間違った方向に進まない）

---

## What NOT to Change Without Discussion

以下はプロジェクトオーナーの承認なく変更しないでください：

- `AI_CONTEXT.md` 自体の内容
- `docs/architecture.md` のレイヤー構造
- `AppDependency.swift` の設計方針
- `Packages/Core/Package.swift` への依存追加
- `.swiftlint.yml` の `force_unwrapping` ルール
