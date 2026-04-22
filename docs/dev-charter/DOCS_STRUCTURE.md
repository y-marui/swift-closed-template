# Docs Structure

プロジェクトのドキュメント構成を定義する。

**目的：**

- AI が自律的に開発できるようにする
- AI が全探索せずに済むようにする（token 効率の改善）
- 人間・AI 共用のナレッジベースとして維持する

---

## Typical Structure

```
project-root/
├── README.md                        # セットアップ・使い方（ユーザー向け）
├── README-jp.md                     # 日本語版（日英ペアで管理）
├── CONTRIBUTING.md                  # 開発フロー・命名規則（開発者・AI向け）
├── CHANGELOG.md                     # リリース履歴
├── LICENSE                          # ライセンス
├── Makefile                         # 開発タスク統一インターフェース
├── AI_CONTEXT.md                    # AI エントリーポイント
├── CLAUDE.md                        # @AI_CONTEXT.md + Claude Code 固有設定
├── GEMINI.md                        # @AI_CONTEXT.md + Gemini CLI 固有設定
├── .github/
│   └── copilot-instructions.md      # AI_CONTEXT.md 参照 + Copilot 固有設定
└── docs/
    ├── architecture.md              # モジュール・コンポーネント構造
    ├── file-map.md                  # ファイルレベルの依存関係（AI が追記）
    ├── specification.md             # 機能仕様・データフロー
    └── ui-design.md                 # UI 設計（UI がない場合は「該当なし」）
```

---

## Root Files

プロジェクトルートに配置する標準ファイルと、その責務を定める。

| ファイル | 責務 |
|---|---|
| `README.md` / `README-jp.md` | セットアップ・使い方・runbook・`docs/` への索引 |
| `CONTRIBUTING.md` | 開発フロー・命名規則・コードレビューチェックリスト等 |
| `CHANGELOG.md` | リリース履歴・破壊的変更の記録 |
| `LICENSE` | ライセンス（[LEGAL_POLICY.md](LEGAL_POLICY.md) 参照） |
| `Makefile` | 開発タスクの統一インターフェース（ビルド・テスト・lint 等）。プロジェクト固有のツール（npm scripts 等）で代替可能な場合を除き必須 |
| `AI_CONTEXT.md` | AI エントリーポイント（後述） |
| `CLAUDE.md` | `@AI_CONTEXT.md` + Claude Code 固有設定 |
| `GEMINI.md` | `@AI_CONTEXT.md` + Gemini CLI 固有設定 |
| `.github/copilot-instructions.md` | `AI_CONTEXT.md` 参照 + Copilot 固有設定 |

> ユーザー向けファイルは開発者も参照し、ユーザーおよび開発者向けファイルは AI も参照する。

AI ツール設定ファイルの詳細な構成仕様（セクション定義・重複排除ルール等）は [AI_TOOL_SETUP.md](AI_TOOL_SETUP.md) を参照。

### Responsibility Boundaries

- 開発者向けルール（命名規則・レビューチェックリスト等）は `CONTRIBUTING.md` に記述する
- `README.md` は `docs/` の詳細ファイルを参照する形にし、情報を重複させない
- `README.md` と `README-jp.md` は日英ペアで管理し、同一コミットで更新する
  - プロジェクト README の構成詳細: [topics/PROJECT_README_GUIDELINES.md](topics/PROJECT_README_GUIDELINES.md)
  - テンプレートリポジトリ自体の README 設計: [topics/TEMPLATE_README_GUIDELINES.md](topics/TEMPLATE_README_GUIDELINES.md)

---

## docs/ Directory

プロジェクト内の `docs/` ディレクトリに配置する標準ファイルを定める。

### Common Files (全プロジェクト共通)

| ファイル | 内容 |
|---|---|
| `docs/architecture.md` | モジュール・コンポーネント間の依存関係、エントリーポイント |
| `docs/file-map.md` | ファイルレベルの依存関係（AI が作業のたびに追記していく運用） |
| `docs/specification.md` | 機能仕様・動作定義・データフロー |
| `docs/ui-design.md` | UI 設計・コンポーネント仕様（UI がない場合は「該当なし」と記載） |

`docs/file-map.md` は AI が初回探索後に追記していく運用とし、初期状態は最小限でよい。

### Project-Type-Specific Files

| プロジェクト種別 | ファイル | 内容 |
|---|---|---|
| Alfred ワークフロー | `docs/configuration-builder.md` | 設定ビルダーの仕様 |

---

## AI_CONTEXT.md — Reference Order

`AI_CONTEXT.md` の冒頭に、AI が作業開始時に参照する順序を明記する。

```
## Reference Order

AI はタスク開始時に以下の順で参照する:

1. README.md（概要・セットアップ）
2. CONTRIBUTING.md（開発フロー・命名規則・レビューチェックリスト）

必要に応じて以下を参照する（順不同）:
- docs/architecture.md（モジュール・コンポーネント構造）
- docs/file-map.md（ファイルレベルの依存関係 ※情報が足りない・古い場合は適宜探索し、追記・更新する）
- docs/specification.md（機能仕様・データフロー）
- docs/ui-design.md（UI 設計・コンポーネント仕様）
```

これにより、AI は全ファイルを探索せず必要なドキュメントに直接アクセスできる。

`AI_CONTEXT.md` の全体的な構成仕様（セクション定義・AIツール設定ファイルとの関係）は
[AI_TOOL_SETUP.md](AI_TOOL_SETUP.md) を参照すること。
