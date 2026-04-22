# Maintenance Guide

## 依存パッケージの更新

このプロジェクトはサードパーティ依存を持たない設計です。
SwiftData / URLSession など Apple 純正 framework のみを使用しています。
依存を追加する際は以下の基準で判断してください。

**追加してよい依存:**
- Apple 純正 framework の薄いラッパー（例: KeychainAccess）
- テスト専用ライブラリ（例: Quick/Nimble）— testTarget にのみ追加

**追加してはいけない依存:**
- RxSwift / Combine ベースのライブラリ（async/await に統一）
- 巨大な UI フレームワーク（SwiftUI に統一）
- Domain 層に import が必要になるライブラリ

依存を追加する場合は `Packages/Core/Package.swift` の該当ターゲットに追記し、
`docs/architecture.md` の「アーキテクチャ変更履歴」セクションに理由を記録してください。

## SwiftLint ルールの変更

`.swiftlint.yml` を変更する際のルール：

- ルールを **無効化** する場合 → PR に理由を必ず記載する
- ルールを **追加** する場合 → 全ファイルに違反がないことを確認してからマージ
- `force_unwrapping` は原則 warning のまま維持する（`!` は使わない）

## ファイル・ディレクトリの命名規則

| 種別 | 規則 | 例 |
|---|---|---|
| Feature ディレクトリ | UpperCamelCase | `UserProfile/` |
| Swift ファイル | UpperCamelCase | `UserProfileView.swift` |
| テストファイル | 対象クラス名 + Tests | `UserProfileViewModelTests.swift` |
| ドキュメント | kebab-case | `architecture-evolution.md` |

## 不要になった Example コードの削除手順

`ExampleFeature` はテンプレートのサンプルです。
実際のプロジェクト開始後、最初の本番フィーチャーが動作したら以下を削除してください。

```bash
rm -rf Packages/Core/Sources/Core/Features/ExampleFeature/
rm Packages/Core/Sources/Core/Domain/Models/ExampleItem.swift
rm Packages/Core/Sources/Core/Domain/Repositories/ExampleRepositoryProtocol.swift
rm Packages/Core/Sources/Core/Domain/UseCases/UseCasePlaceholder.swift
rm Packages/Core/Sources/Core/Infrastructure/Network/APIClient.swift        # 独自実装に置き換えた場合
rm Packages/Core/Sources/Core/Infrastructure/Persistence/ExampleItemRecord.swift
rm Packages/Core/Sources/Core/Infrastructure/Services/ExampleRepository.swift
```

その後 `make test` が通ることを確認してください。

## コードレビューチェックリスト

PRレビュー時に必ず確認する項目：

- [ ] Feature が Infrastructure を直接 import していないか
- [ ] Domain モデルに framework の import がないか
- [ ] ViewModel が `@MainActor @Observable` になっているか
- [ ] 非同期処理が `async/await` になっているか（Combine 禁止）
- [ ] 新しい UseCase・Repository にテストが追加されているか
- [ ] `force_unwrap`（`!`）を使っていないか
