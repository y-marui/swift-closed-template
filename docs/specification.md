# Specification

機能仕様・動作定義・データフローを記録します。

---

## 機能一覧

> プロジェクト固有の機能一覧をここに記載してください。

| 機能名 | 概要 | 優先度 |
|---|---|---|
| ExampleFeature | サンプルフィーチャー（削除対象） | - |

---

## 機能仕様

### ExampleFeature（削除対象）

> このセクションはテンプレートです。実際の機能仕様に置き換えてください。

**概要:** サンプルアイテムの一覧取得・表示

**入力:** なし

**出力:** `[ExampleItem]` — サンプルアイテムの配列

**正常フロー:**
1. View が表示される（`onAppear`）
2. ViewModel が UseCase を呼び出す
3. UseCase が Repository 経由でデータを取得
4. ViewModel が state を更新
5. View が再描画される

**エラーフロー:**
- ネットワークエラー → エラーメッセージを表示
- データ未取得 → ローディング状態を表示

---

## データモデル

> プロジェクト固有のドメインモデルをここに記載してください。

### ExampleItem（削除対象）

```swift
struct ExampleItem: Identifiable {
    let id: UUID
    let title: String
    let createdAt: Date
}
```

---

## 状態管理

> 各フィーチャーの ViewState を記載してください。

```swift
enum ViewState {
    case idle
    case loading
    case loaded([Item])
    case error(String)
}
```
