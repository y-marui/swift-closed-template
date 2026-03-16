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
