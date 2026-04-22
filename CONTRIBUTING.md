# Contributing Guide

開発フロー・命名規則・コードレビューチェックリスト等、開発者向けの情報をまとめています。

## 開発フロー

### ブランチ戦略

```
feature/xxx → develop → main → タグ付け
```

1. `feature/xxx` ブランチで開発
2. `develop` へ PR を出す（CI が通ることを確認）
3. リリース前に `develop` → `main` へ PR（他の開発者がレビュー）
4. `main` マージ後にタグを打つ

### リリース手順

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### ホットフィックス手順

```bash
# main から hotfix ブランチを作成
git checkout main
git checkout -b hotfix/issue-description

# 修正・テスト
make test

# main と develop 両方にマージ
git checkout main && git merge hotfix/issue-description
git checkout develop && git merge hotfix/issue-description

# タグを打つ
git tag -a v1.0.1 -m "Hotfix v1.0.1"
git push origin main develop v1.0.1
```

---

## 命名規則

| 種別 | 規則 | 例 |
|---|---|---|
| Feature ディレクトリ | UpperCamelCase | `UserProfile/` |
| Swift ファイル | UpperCamelCase | `UserProfileView.swift` |
| テストファイル | 対象クラス名 + Tests | `UserProfileViewModelTests.swift` |
| ドキュメント | kebab-case | `architecture-evolution.md` |

---

## 依存パッケージの管理

このプロジェクトはサードパーティ依存を持たない設計です。
SwiftData / URLSession など Apple 純正 framework のみを使用しています。

### 追加してよい依存

- Apple 純正 framework の薄いラッパー（例: KeychainAccess）
- テスト専用ライブラリ（例: Quick/Nimble）— testTarget にのみ追加

### 追加してはいけない依存

- RxSwift / Combine ベースのライブラリ（async/await に統一）
- 巨大な UI フレームワーク（SwiftUI に統一）
- Domain 層に import が必要になるライブラリ

依存を追加する場合は `Packages/Core/Package.swift` の該当ターゲットに追記し、
`docs/architecture.md` の「アーキテクチャ変更履歴」セクションに理由を記録してください。

---

## SwiftLint ルールの変更

`.swiftlint.yml` を変更する際のルール：

- ルールを **無効化** する場合 → PR に理由を必ず記載する
- ルールを **追加** する場合 → 全ファイルに違反がないことを確認してからマージ
- `force_unwrapping` は原則 warning のまま維持する（`!` は使わない）

---

## Example コードの削除手順

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

---

## コードレビューチェックリスト

PR レビュー時に必ず確認する項目：

- [ ] Feature が Infrastructure を直接 import していないか
- [ ] Domain モデルに framework の import がないか
- [ ] ViewModel が `@MainActor @Observable` になっているか
- [ ] 非同期処理が `async/await` になっているか（Combine 禁止）
- [ ] 新しい UseCase・Repository にテストが追加されているか
- [ ] `force_unwrap`（`!`）を使っていないか
