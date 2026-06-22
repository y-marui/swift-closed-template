# Monetization — [AppName]

> **このファイルは正本（日本語版）です。**

## Platform

macOS App / iOS App

## Model

**Sublime Text 方式** — 全機能を無料で使用でき、一定期間の使用後に購入を促すダイアログを表示する。正式購入でダイアログを解除。

機能制限・試用期限・フリーミアムは採用しない。

## Purchase Prompt

- 表示タイミング：実装時に決定
- 購入後：ダイアログは表示されない

## IAP

- 種別：買い切り（一度限り）
- 内容：購入ダイアログの解除
- 価格：実装時に決定
- 実装：StoreKit 2

## Implementation Notes

- 購入状態の管理は `EntitlementManager` で行う
- 機能制限のためのゲート処理は追加しない
