# Changelog

## [Unreleased]

### Added
- Markdown 見出し言語チェック（`scripts/check-markdown-heading-language.sh`）を pre-commit に追加し、全ドキュメントの見出しを英語に統一（#24）
- Codex 用 `AGENTS.md` を追加（#24）
### Changed
- `SWIFT_STRICT_CONCURRENCY` を `complete` に設定し、CI とローカルビルドの concurrency チェック基準を統一（#22）
- dev-charter を 2026-08-08 版に更新。マネタイズ方針を Sublime Text 方式から Apple App Store 方式（1 か月無料試用 → サブスクリプション/買い切り）に変更、AI ツール分担に Codex を追加（#24）
- dev-charter に新設された `topics/swift/SWIFT_DEV_ENV.md` を取り込み、`DEVELOPING.md` の「Changing SwiftLint Rules」の一般方針部分を同トピックへの参照に置き換え、`AI_CONTEXT.md` の Applied Charter Principles にも参照を追加（y-marui/dev-charter#134）
### Fixed
