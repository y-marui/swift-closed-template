# アーキテクチャ

## Overview

Clean Architecture 原則に基づき、厳格な依存ルールを持つ 4 層構造で構成されています。

## Layer Diagram

```
┌─────────────────────────────────┐
│           App (Entry)           │
│  App.swift / AppDependency.swift│
└────────────┬────────────────────┘
             │ injects
┌────────────▼────────────────────┐
│          Features               │
│  View + ViewModel + UseCase     │
│  (Domain のみに依存)             │
└────────────┬────────────────────┘
             │ uses protocols
┌────────────▼────────────────────┐
│           Domain                │
│  Models / Repositories / UseCases│
│  (pure Swift、依存なし)          │
└────────────┬────────────────────┘
             │ implemented by
┌────────────▼────────────────────┐
│        Infrastructure           │
│  Network / Persistence / Services│
└─────────────────────────────────┘
```

## Data Flow

```
ユーザー操作
  → ViewModel.action()
    → UseCase.execute()
      → Repository.fetch()   (プロトコル呼び出し)
        → APIClient / SwiftData  (実装)
      ← [DomainModel]
    ← [DomainModel]
  ← ViewModel が state を更新
@Observable により View が自動で再描画
```

## ViewModel Pattern

すべての ViewModel は `@MainActor @Observable`（iOS 17+）を使用します：

```swift
@MainActor
@Observable
final class FeatureViewModel {
    private(set) var state: ViewState = .idle
    private let useCase: FeatureUseCaseProtocol

    init(useCase: FeatureUseCaseProtocol) {
        self.useCase = useCase
    }

    func onAppear() async { ... }
}
```

## Dependency Injection

`AppDependency` はオブジェクト生成の唯一の責務を持ちます。
`App.swift` で一度だけ生成し、`init` 経由で下位に渡します。

```swift
// App.swift
private let dependency = AppDependency()

// AppDependency.swift
func makeFeatureViewModel() -> FeatureViewModel {
    FeatureViewModel(useCase: FeatureUseCase(repository: featureRepository))
}
```

---

## Architecture Change Log

アーキテクチャの変更履歴をここに記録します。
**なぜその決定をしたか**を残すことが目的です。

### Record Format

```
## YYYY-MM-DD: 変更タイトル

**背景:** なぜ変更が必要だったか
**決定:** 何を変えたか
**却下した選択肢:** 検討したが採用しなかった案とその理由
**影響範囲:** 変更が影響するファイル・レイヤー
```

### When to Record a Change

以下の変更を行ったとき、必ずこのファイルに追記してください。

- 新しいレイヤーやディレクトリ構造を追加したとき
- 技術選定（ライブラリ・パターン）を変更したとき
- アーキテクチャルールに例外を設けたとき
- `AI_CONTEXT.md` のルールを変更したとき

---

### 2026-09-22: In-App Language Setting

**背景:** アプリ内の言語設定が 7 アプリで 4 通りに実装され、3 アプリには設定がなかった（#41）。

**決定:**
- `AppLanguage`（`system, ja, en, zh-Hans, hi, es, fr, pt`）を Domain に置く（Foundation のみに依存）
- 保存は App Group の `UserDefaults`（Widget・Intents・Keyboard から同じ値を読むため）
- 反映は全シーンのルートに `.environment(\.locale, ...)`（即時反映）
- `Packages/Core` に `defaultLocalization: "ja"` とリソース（`Localizable.xcstrings`）を追加
- `String(localized:)`・App Intents・AppleScript 向けの `AppleLanguages` 方式はテンプレートに含めない

**却下した選択肢:**
- 共通 Swift Package 化: `AppLanguage` は小さく設定画面と密に結びつくため、まずテンプレートで形を示す
- 中国語のコードを `zh` にする: 共通パッケージ `swift-app-monetization` の文言に合わせて `zh-Hans` にした

**影響範囲:** `Packages/Core`（Domain・Features/Settings・Resources）、`App/macOS`、entitlements

### 2026-10-01: Localized Initializers and Out-of-View Lookup

**背景:** 7 アプリへ展開した結果、`String(localized:)` を `Button`・`Label` などに渡している箇所が言語設定に従わない問題が多く見つかった。標準のイニシャライザは `bundle:` を取れないため、Core のカタログを引くには `Text(_, bundle:)` を使う書き換えが必要だった。

**決定:**
- `bundle:` を取るイニシャライザを `Shared/LocalizedViews.swift` に用意する
- ビュー外の文言用に `AppLanguage.localizedString(_:bundle:)` を追加する（選択言語の lproj を直接引く）
- `AppleLanguages` 方式はテンプレートに含めない（App Intents・AppleScript が必要なアプリだけ）

**影響範囲:** `Packages/Core`（Shared・Domain・Features）、`templates/feature`

---

### 2026-01-01: Initial Template Design

**背景:** iOS 17+ を最低ターゲットとした新規プロジェクト向けのテンプレートが必要だった。
AI支援開発（Claude Code, GitHub Copilot）を前提とした設計にする必要があった。

**決定:**
- `@Observable` を採用（`ObservableObject` は使わない）
- 依存注入は手動の `AppDependency`（DI フレームワーク不使用）
- 永続化は SwiftData（CoreData は使わない）
- 非同期は async/await（Combine は使わない）
- ロジックは Swift Package として `App` から分離

**却下した選択肢:**
- `ObservableObject` + `@Published`: iOS 17 で `@Observable` が安定したため不要
- The Composable Architecture (TCA): 小規模チーム向けにはオーバーエンジニアリング
- Swinject などの DI フレームワーク: 手動 DI で十分なスケール感

**影響範囲:** プロジェクト全体

---

### 2026-10-07: Add the Privacy Manifest to the Template

**背景:** App Store Connect へのアップロードで、Apple が「理由の申告が必要な API」を使うアプリにプライバシーマニフェスト（`PrivacyInfo.xcprivacy`）を求める。7 つのアプリのどれにもマニフェストがなく、y-marui/swift-stick-mark#81 から順に追加した。今後作るアプリにも最初から含めるため、テンプレートに入れる。

**決定:**
- `App/PrivacyInfo.xcprivacy` を 1 つ追加し、`project.yml` の有効なターゲットと、コメントアウトされた iOS・Widget のターゲットの雛形の `sources` に含める。ターゲットごとに複製しない
- 雛形は、トラッキングなし、収集データなし、`UserDefaults` の理由 `CA92.1` と `1C8F.1`（`App/macOS/AppGroup.swift` が App Group の `UserDefaults` を使うため）
- 使い方は `DEVELOPING.md` の「Privacy Manifest」に書いた。一般方針は dev-charter の `topics/swift/SWIFT_DEV_ENV.md`（y-marui/dev-charter#186）

**却下した選択肢:**
- ターゲットごとに別々のマニフェストを置く: 内容が同じで、ずれる原因になる

**影響範囲:** `App/PrivacyInfo.xcprivacy`（新規）、`project.yml`、`DEVELOPING.md`、`docs/file-map.md`、`CHANGELOG.md`

---

### 2026-10-08: Warn About Stale Shared Packages

**背景:** 共通パッケージ `swift-app-monetization` の解決した版は、`Package.resolved` と xcodebuild のビルドキャッシュ（`build/SourcePackages/workspace-state.json`）に固定され、`branch: "main"` でも自動では上がらない。今後、課金を組み込むときに同じ問題が起きないよう、あらかじめ入れておく（まだ依存していないため、スクリプトは何もしない）（y-marui/swift-stick-mark の 2026-10-08 の事例）。

**決定:**
- `scripts/check-package-updates.sh` を追加し、`git ls-remote` で最新の `main`（タグ運用になったら最新のタグ）を調べて、手元の固定された版と比べる。古ければ警告する。依存していない場合と、ネットワークに届かない場合は、何も表示せず正常終了する
- `make build` の前に毎回実行する（`make ios`・`make deploy` は `build` を通る）。`make ios-release`・`make deploy-release` は `--strict` で、古い版ならエラーで止める。製品に古い課金ロジックが入るのを防ぐため
- `scripts/update-packages.sh`（`make update-packages`）で、`Package.resolved` の更新と、古いビルドキャッシュの削除を行う。次のビルドで最新の版を取り込む
- 常に最新を自動で取り込む案は採らず、警告と 1 コマンドの更新にする。ビルドのたびに依存が黙って変わると、共通パッケージの変更が、意図せず製品ビルドに入るため

**却下した選択肢:**
- ビルドの前に毎回、自動で最新へ更新する: 依存の更新が、ビルドの再現性を損なう。リリースビルドでは特に避けたい

**影響範囲:** `scripts/check-package-updates.sh`（新規）、`scripts/update-packages.sh`（新規）、`Makefile`、`README.md`・`README-jp.md`、`DEVELOPING.md`
