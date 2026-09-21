# Changelog

## [Unreleased]

### Added
- アプリ内の言語設定の標準を追加（`AppLanguage`・App Group への保存・`Settings` シーンの言語 `Picker`・`Localizable.xcstrings` の雛形）。`Packages/Core` に `defaultLocalization: "ja"` を設定し、`AI_CONTEXT.md` の Localization と `Resources/Localization/README.md` を更新した（#41）
- Markdown 見出し言語チェック（`scripts/check-markdown-heading-language.sh`）を pre-commit に追加し、全ドキュメントの見出しを英語に統一（#24）
- Codex 用 `AGENTS.md` を追加（#24）
### Changed
- `templates/feature/View.swift.template` と `examples/FeatureExample/README.md` の `String(localized:)` を `Text(_, bundle: .module)` に置き換え、アプリ内の言語設定が新機能の画面にも反映されるようにした。テンプレートのキーはカタログの `common.error.title`・`common.retry` に揃えた。`Resources/Localization/README.md` の文言の書き方も同様に更新した（#41）
- macOS と iOS の Bundle ID を同一にする規約に変更した（Universal Purchase で購入権限を共有するため）。`DEVELOPING.md` の「Bundle ID When Combining macOS + iOS + Widget」、`AI_CONTEXT.md`、`project.yml` のコメントアウト部を更新し、Widget の `[sdk=iphone*]` 上書きを廃止した（y-marui/swift-leaf-mark#20）
- `SWIFT_STRICT_CONCURRENCY` を `complete` に設定し、CI とローカルビルドの concurrency チェック基準を統一（#22）
- dev-charter を 2026-08-08 版に更新。マネタイズ方針を Sublime Text 方式から Apple App Store 方式（1 か月無料試用 → サブスクリプション/買い切り）に変更、AI ツール分担に Codex を追加（#24）
- dev-charter に新設された `topics/swift/SWIFT_DEV_ENV.md` を取り込み、`DEVELOPING.md` の「Changing SwiftLint Rules」の一般方針部分を同トピックへの参照に置き換え、`AI_CONTEXT.md` の Applied Charter Principles にも参照を追加（y-marui/dev-charter#134）
### Fixed
