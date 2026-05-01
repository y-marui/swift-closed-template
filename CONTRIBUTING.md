# Contributing Guide

PR・Issue ルール・コードレビューチェックリスト等、外部コントリビューター向けの情報をまとめています。

ビルド手順・実装規約・命名規則等の開発者向け情報は [DEVELOPING.md](DEVELOPING.md) を参照してください。

---

## コードレビューチェックリスト

PR レビュー時に必ず確認する項目：

- [ ] Feature が Infrastructure を直接 import していないか
- [ ] Domain モデルに framework の import がないか
- [ ] ViewModel が `@MainActor @Observable` になっているか
- [ ] 非同期処理が `async/await` になっているか（Combine 禁止）
- [ ] 新しい UseCase・Repository にテストが追加されているか
- [ ] `force_unwrap`（`!`）を使っていないか
