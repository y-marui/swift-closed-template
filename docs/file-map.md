# File Map

ファイルレベルの依存関係を記録します。
初回のコードベース探索後に追記し、変更のたびに更新してください。

## Record Format

```
ファイル: パス/から/ファイル.swift
依存先:
  - パス/先/依存ファイル.swift (理由)
被依存先（参照元）:
  - パス/参照/元ファイル.swift
```

---

## Entry Points

| ファイル | 役割 |
|---|---|
| `App/macOS/App.swift` | macOS アプリエントリーポイント・ルートビュー |
| `App/macOS/AppDependency.swift` | DI コンテナ |
| `App/macOS/AppGroup.swift` | App Group ID と共有 `UserDefaults` |

---

## Dependency Map

> ここにプロジェクト固有のファイルマップを記録してください。
> 例: `AppDependency.swift` → `ExampleRepository.swift` → `ExampleRepositoryProtocol.swift`

### Language Setting

| ファイル | 役割 | 依存先 |
|---|---|---|
| `Packages/Core/Sources/Core/Domain/Models/AppLanguage.swift` | 言語の型・`resolvedLocale` | Foundation |
| `Packages/Core/Sources/Core/Features/Settings/SettingsView.swift` | 「言語」セクションの `Picker` | `AppLanguage.swift`、`Resources/Localizable.xcstrings` |
| `Packages/Core/Sources/Core/Resources/Localizable.xcstrings` | 文言カタログ（7 言語） | — |
| `App/macOS/App.swift` | `Settings` シーンと `.environment(\.locale, ...)` | `AppLanguage.swift`、`SettingsView.swift`、`AppGroup.swift` |

<!-- プロジェクト開始後に追記 -->
