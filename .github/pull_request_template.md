## 概要

<!-- 変更内容とその背景を説明してください。 -->

## 変更の種類

- [ ] バグ修正 (`fix`)
- [ ] 新機能・テンプレート追加 (`feat`)
- [ ] リファクタリング（動作変更なし）(`refactor`)
- [ ] ドキュメント更新 (`docs`)

> コミットメッセージは Conventional Commits 形式で記述してください（`feat:`, `fix:`, `refactor:`, `docs:`）。

## コードレビューチェックリスト

- [ ] Feature が Infrastructure を直接 import していないか
- [ ] Domain モデルに framework の import がないか
- [ ] ViewModel が `@MainActor @Observable` になっているか
- [ ] 非同期処理が `async/await` になっているか（Combine 禁止）
- [ ] 新しい UseCase・Repository にテストが追加されているか
- [ ] `force_unwrap`（`!`）を使っていないか
- [ ] 動作確認済みのコードのみ含まれているか（WIP は含めない）

## テスト確認

- [ ] `make test` が通ることを確認した
- [ ] `make lint` が 0 violations であることを確認した

## 関連 Issue

<!-- Closes # -->
