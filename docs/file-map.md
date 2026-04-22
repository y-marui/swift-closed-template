# File Map

ファイルレベルの依存関係を記録します。
初回のコードベース探索後に追記し、変更のたびに更新してください。

## 記録フォーマット

```
ファイル: パス/から/ファイル.swift
依存先:
  - パス/先/依存ファイル.swift (理由)
被依存先（参照元）:
  - パス/参照/元ファイル.swift
```

---

## エントリーポイント

| ファイル | 役割 |
|---|---|
| `App/App.swift` | アプリエントリーポイント・ルートビュー |
| `App/AppDependency.swift` | DI コンテナ |

---

## 依存関係マップ

> ここにプロジェクト固有のファイルマップを記録してください。
> 例: `AppDependency.swift` → `ExampleRepository.swift` → `ExampleRepositoryProtocol.swift`

<!-- プロジェクト開始後に追記 -->
