# UI Design

UI 設計・コンポーネント仕様を記録します。

---

## Appearance Modes

ライト・ダーク・システムの 3 モードに対応し、ユーザーが設定から選択できるようにする。

## Color Palette

| モード | 背景 | 文字 | 強調（テキスト） |
|---|---|---|---|
| ライト | #FFFFFF | #4e454a | #000000 |
| ダーク | #000000 | #bab1b6 | #FFFFFF |

- アクセントカラーと装飾: ライト/ダーク間で色相・彩度を維持しつつ明度を反転
- システムカラーを優先
- ネイティブ UI コンポーネントを優先

## Iconography

- **SF Symbols を絶対優先** (`Image(systemName: "...")`)
- **Unicode 絵文字禁止**: ボタン・ラベル・装飾等における使用は原則禁止（SF Symbols を使う）

## Window Sizing (macOS)

`WindowGroup` のウィンドウサイズを SwiftUI のデフォルト任せにしない。以下は実際に配布した複数アプリを大画面・MacBook Air 相当の幅で確認した上で決めた基準値。

- 各 `WindowGroup` に `.defaultSize(width:height:)` を必ず明示指定する
- メインウィンドウの `View`（`RootView` 等）に `.frame(minWidth:minHeight:)` を必ず明示指定する
- 単純な一覧・詳細程度の構成の基準値:
  - `minWidth: 600, minHeight: 400`
  - `defaultSize(width: 800, height: 600)`
- 週間ボード・カレンダーの週表示など列数が多い/横幅を要する画面は、上記より広い `minWidth` が必要になることがある（実例: 7 カラムの週間ボードで `minWidth: 600` だとテキストが1文字ずつ縦に折り返されて読めなくなり、`minWidth: 800` まで広げて解消した）
- `NavigationSplitView` でサイドバーを持つ画面は、サイドバー列に `.navigationSplitViewColumnWidth(min:ideal:max:)` を必ず指定する。未指定だと、過去にユーザーがドラッグで狭めた列幅がそのまま復元され続け、日本語のリスト名・フォルダ名が省略されて読めなくなることがある（実例で確認済み）

  ```swift
  NavigationSplitView {
      SidebarView(...)
          .navigationSplitViewColumnWidth(min: 220, ideal: 240, max: 320)
  } detail: {
      DetailView(...)
  }
  ```

- 検証方法: ソースからビルドした実機で `defaultSize` と `minWidth`/`minHeight` ぎりぎりの両方の大きさでウィンドウを表示し、ラベルの省略・不自然な折り返し・ツールバー項目が「その他のツールバー項目」に畳まれていないかを確認する

---

## Component Specification

> プロジェクト固有の UI コンポーネントをここに記載してください。

### Common Components

<!-- プロジェクト開始後に追記 -->

---

## Screen List

> 各画面のレイアウト・遷移を記載してください。

| 画面名 | 概要 | 遷移先 |
|---|---|---|
| ExampleView | サンプル一覧（削除対象） | - |
