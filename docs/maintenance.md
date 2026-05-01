# Docs Maintenance

ローカル LLM で `docs/` ファイルをメンテナンスするためのプロンプト集。

---

## docs/architecture.md を更新する

```
このプロジェクトの docs/architecture.md を更新してください。

手順：
1. ディレクトリ構造を確認する（App/, Packages/Core/Sources/Core/ 以下）
2. Package.swift を読んでターゲット・依存関係を把握する
3. 既存の docs/architecture.md を読む（存在する場合）
4. 以下のフォーマットで docs/architecture.md を上書き保存する：

---
# Architecture

## Overview
<!-- プロジェクト全体像を3行以内で記述 -->

## Entry Points
- `パス/ファイル` — 説明

## Directory Structure
| ディレクトリ | 役割 |
|---|---|
| `App/` | アプリエントリーポイント（SwiftUI App / Scene） |
| `Packages/Core/Sources/Core/Features/` | 機能モジュール（View / ViewModel） |
| `Packages/Core/Sources/Core/Domain/` | モデル・プロトコル・UseCase |
| `Packages/Core/Sources/Core/Infrastructure/` | Network・Persistence・Services |
| `Packages/Core/Sources/Core/Shared/` | 汎用ユーティリティ・拡張 |

## Key Dependencies
| ライブラリ / モジュール | 用途 |
|---|---|
| （主要な依存のみ列挙） | |

## Architecture Change Log
| 日付 | 変更内容 | 理由 |
|---|---|---|
| （変更があった場合のみ追記） | | |
---

注意：
- Overview は3行以内に収める
- ファイルレベルの詳細は記載しない（file-map.md に委譲）
- 全依存を網羅せず、主要なもののみ列挙する
- 上書き保存を最終ステップとして必ず実行する
```

---

## docs/file-map.md を更新する

```
このプロジェクトの docs/file-map.md を更新してください。

手順：
1. 最近変更または参照したファイルを特定する
2. 既存の docs/file-map.md を読む（存在する場合）
3. 以下のフォーマットで docs/file-map.md を上書き保存する（未探索ファイルは追加しない）：

---
# File Map

_最終更新: YYYY-MM-DD_

## [モジュール / 機能名]
| ファイル | 役割 | 主な依存先 |
|---|---|---|
| `Packages/Core/Sources/Core/Features/FeatureName/FeatureNameView.swift` | SwiftUI View | `FeatureNameViewModel` |
| `Packages/Core/Sources/Core/Features/FeatureName/FeatureNameViewModel.swift` | ViewModel（@MainActor @Observable） | `FeatureNameUseCase` |
---

注意：
- 全ファイルを網羅しなくてよい（参照・編集したファイルのみ追記）
- 未探索ファイルは記載しない（不正確な記述を避ける）
- 更新のたびに「最終更新」日付を今日の日付に更新する
- 上書き保存を最終ステップとして必ず実行する
```
