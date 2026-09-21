# ローカライゼーション

## Supported Languages

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

## Language Resolution Priority

1. アプリ内のユーザー設定
2. システム言語設定
3. 英語（フォールバック）

## In-App Language Setting

標準の型・保存先・反映方法はテンプレートに実装済み。各アプリはこの形に揃える（#41）。

| 項目 | 内容 |
|---|---|
| 型 | `AppLanguage`（`Packages/Core/Sources/Core/Domain/Models/AppLanguage.swift`）。`system, ja, en, zhHans = "zh-Hans", hi, es, fr, pt` |
| 保存値 | `rawValue`（`system` は `"system"`）。不明な値は `AppLanguage(storedValue:)` で `system` になる |
| 保存先 | App Group の `UserDefaults(suiteName:)` の `appLanguage` キー。`App/macOS/AppGroup.swift` に ID を置く |
| 解決 | `resolvedLocale`。明示の言語ならその言語。`system` は `Locale.preferredLanguages` から対応言語に一致する最初のもの、なければ英語。`zh-Hant`（`zh-TW` 等を含む）は対応外で英語になる |
| 表示名 | `nativeName`（自国語表記で固定）。`system` だけが nil で、`settings.language.system` をローカライズする |
| 反映 | 全シーン（ウィンドウ・Settings・シート）のルートに `.environment(\.locale, language.resolvedLocale)`。即時に反映される |
| 設定画面 | `SettingsView` の「言語」セクション（`AppLanguage.allCases` の `Picker`） |

Xcode の String Catalog は Core のリソース（`Packages/Core/Sources/Core/Resources/Localizable.xcstrings`）に置く。
Core 内の `Text` は `bundle: .module` を指定する。

### Extension (Widget / Intents / Keyboard)

Extension は App Group から `appLanguage` を読む。Widget は Provider が読み、タイムラインの entry に含め、View で
`.environment(\.locale, ...)` を付ける。

### Non-SwiftUI strings

`String(localized:)`・App Intents・AppleScript の文言は、環境の `locale` では変わらない。
これらが必要になったアプリだけ、起動時に `AppleLanguages`（`UserDefaults.standard`）へ選択言語を書き込む
`AppLanguageOverride` を用意する（Glance Task の実装が参考）。反映はアプリの再起動後になるため、設定画面に
「再起動後に反映される」旨を出す。テンプレートには含めない（YAGNI）。

### Enabling the iOS Target

`project.yml` の iOS ターゲットを有効にするときは、`App/iOS/App.swift` にも macOS と同じ設定を入れる。

- `@AppStorage(AppLanguage.storageKey, store: AppGroup.userDefaults)` と、`WindowGroup` のルートへの `.environment(\.locale, ...)`
- `AppGroup.swift` を共有する（`App/macOS` と `App/iOS` の両方から参照できる場所へ移す）
- iOS の entitlements にも同じ App Group を追加する
- `SettingsView(store: AppGroup.userDefaults)` を設定画面の導線から表示する（iOS には `Settings` シーンがない）

## Setup Steps (Xcode)

1. プロジェクト設定 > Info > Localizations に上記言語をすべて追加する
2. `Text(_, bundle: .module)` など `LocalizedStringKey` で文字列を定義する（SwiftUI 以外は下の「Non-SwiftUI strings」を参照）
3. `Packages/Core/Sources/Core/Resources/Localizable.xcstrings`（String Catalog）にキーを追加する

## How to Use Strings

```swift
// ✅ 推奨: String Catalog (Xcode 15+)
Text("feature.title", bundle: .module)
Button { ... } label: { Text("common.retry", bundle: .module) }

// ❌ SwiftUI では避ける: 環境の locale（アプリ内の言語設定）が反映されない
Button(String(localized: "common.retry")) { ... }

// ❌ 禁止: ハードコードされた文字列
Text("タイトル")
Button("Retry") { ... }
```

## Key Naming Convention

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
