# ローカライゼーション

## 対応言語

| 言語 | Locale ID |
|---|---|
| システム設定に従う | — |
| 日本語 | `ja` |
| 英語 | `en` |
| 中国語（簡体字） | `zh-Hans` |
| ヒンディー語 | `hi` |
| スペイン語 | `es` |
| フランス語 | `fr` |
| ポルトガル語 | `pt` |

## 言語決定の優先順位

1. アプリ内のユーザー設定
2. システム言語設定
3. 英語（フォールバック）

## セットアップ手順（Xcode）

1. プロジェクト設定 > Info > Localizations に上記言語をすべて追加する
2. `String(localized:)` または `LocalizedStringKey` を使って文字列を定義する
3. このディレクトリに `Localizable.xcstrings`（String Catalog）を作成する

## 文字列の使い方

```swift
// ✅ 推奨: String Catalog (Xcode 15+)
Text("feature.title")
Button(String(localized: "common.retry")) { ... }

// ❌ 禁止: ハードコードされた文字列
Text("タイトル")
Button("Retry") { ... }
```

## キー命名規則

```
<スコープ>.<内容>
```

例:
```
common.retry        → 「再試行」
common.error.title  → 「エラー」
todo.list.title     → 「ToDo」
todo.add.button     → 「追加」
```
