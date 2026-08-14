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

---

## Dependency Map

> ここにプロジェクト固有のファイルマップを記録してください。
> 例: `AppDependency.swift` → `ExampleRepository.swift` → `ExampleRepositoryProtocol.swift`

<!-- プロジェクト開始後に追記 -->
