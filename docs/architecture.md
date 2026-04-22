# アーキテクチャ

## 概要

Clean Architecture 原則に基づき、厳格な依存ルールを持つ 4 層構造で構成されています。

## レイヤー図

```
┌─────────────────────────────────┐
│           App (Entry)           │
│  App.swift / AppDependency.swift│
└────────────┬────────────────────┘
             │ injects
┌────────────▼────────────────────┐
│          Features               │
│  View + ViewModel + UseCase     │
│  (Domain のみに依存)             │
└────────────┬────────────────────┘
             │ uses protocols
┌────────────▼────────────────────┐
│           Domain                │
│  Models / Repositories / UseCases│
│  (pure Swift、依存なし)          │
└────────────┬────────────────────┘
             │ implemented by
┌────────────▼────────────────────┐
│        Infrastructure           │
│  Network / Persistence / Services│
└─────────────────────────────────┘
```

## データフロー

```
ユーザー操作
  → ViewModel.action()
    → UseCase.execute()
      → Repository.fetch()   (プロトコル呼び出し)
        → APIClient / SwiftData  (実装)
      ← [DomainModel]
    ← [DomainModel]
  ← ViewModel が state を更新
@Observable により View が自動で再描画
```

## ViewModel パターン

すべての ViewModel は `@MainActor @Observable`（iOS 17+）を使用します：

```swift
@MainActor
@Observable
final class FeatureViewModel {
    private(set) var state: ViewState = .idle
    private let useCase: FeatureUseCaseProtocol

    init(useCase: FeatureUseCaseProtocol) {
        self.useCase = useCase
    }

    func onAppear() async { ... }
}
```

## 依存注入

`AppDependency` はオブジェクト生成の唯一の責務を持ちます。
`App.swift` で一度だけ生成し、`init` 経由で下位に渡します。

```swift
// App.swift
private let dependency = AppDependency()

// AppDependency.swift
func makeFeatureViewModel() -> FeatureViewModel {
    FeatureViewModel(useCase: FeatureUseCase(repository: featureRepository))
}
```

---

## アーキテクチャ変更履歴

アーキテクチャの変更履歴をここに記録します。
**なぜその決定をしたか**を残すことが目的です。

### 記録フォーマット

```
## YYYY-MM-DD: 変更タイトル

**背景:** なぜ変更が必要だったか
**決定:** 何を変えたか
**却下した選択肢:** 検討したが採用しなかった案とその理由
**影響範囲:** 変更が影響するファイル・レイヤー
```

### 変更を記録するタイミング

以下の変更を行ったとき、必ずこのファイルに追記してください。

- 新しいレイヤーやディレクトリ構造を追加したとき
- 技術選定（ライブラリ・パターン）を変更したとき
- アーキテクチャルールに例外を設けたとき
- `AI_CONTEXT.md` のルールを変更したとき

---

### 2026-01-01: テンプレート初期設計

**背景:** iOS 17+ を最低ターゲットとした新規プロジェクト向けのテンプレートが必要だった。
AI支援開発（Claude Code, GitHub Copilot）を前提とした設計にする必要があった。

**決定:**
- `@Observable` を採用（`ObservableObject` は使わない）
- 依存注入は手動の `AppDependency`（DI フレームワーク不使用）
- 永続化は SwiftData（CoreData は使わない）
- 非同期は async/await（Combine は使わない）
- ロジックは Swift Package として `App` から分離

**却下した選択肢:**
- `ObservableObject` + `@Published`: iOS 17 で `@Observable` が安定したため不要
- The Composable Architecture (TCA): 小規模チーム向けにはオーバーエンジニアリング
- Swinject などの DI フレームワーク: 手動 DI で十分なスケール感

**影響範囲:** プロジェクト全体
