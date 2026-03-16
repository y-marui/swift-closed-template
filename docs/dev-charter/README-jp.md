# Dev Charter (開発憲章)

> **このファイルは正本（日本語版）です。**
> 英語版（参照）は [README.md](README.md) を参照してください。

AI支援ソフトウェアプロジェクトのための共有開発憲章。

このリポジトリは、プロジェクト横断的に使用される共通の哲学、アーキテクチャ原則、
および開発ルールを定義します。

## ドキュメント一覧

| ファイル | 内容 |
|---|---|
| [PRINCIPLES.md](PRINCIPLES.md) | 開発哲学・デザイン・アーキテクチャ原則 |
| [CODE_STYLE.md](CODE_STYLE.md) | コードスタイル |
| [AI_COLLABORATION_RULES.md](AI_COLLABORATION_RULES.md) | AI 協働ルールと役割分担 |
| [AI_CONTEXT_HIERARCHY.md](AI_CONTEXT_HIERARCHY.md) | AI コンテキスト優先階層 |
| [LANGUAGE_POLICY.md](LANGUAGE_POLICY.md) | 言語ポリシー（正本＝日本語） |
| [LOCALIZATION_POLICY.md](LOCALIZATION_POLICY.md) | ローカライゼーションポリシー |
| [PROJECT_LIFECYCLE.md](PROJECT_LIFECYCLE.md) | プロジェクトライフサイクルと体制 |
| [UI_GUIDELINES.md](UI_GUIDELINES.md) | UI ガイドライン・カラー・アイコン |
| [MONETIZATION_POLICY.md](MONETIZATION_POLICY.md) | マネタイズポリシーとプラットフォーム別方針 |
| [SECURITY_POLICY.md](SECURITY_POLICY.md) | セキュリティポリシーとフック設定リファレンス |

## 使い方

### 1. プロジェクトに追加する
`git subtree` を使い、`docs/dev-charter/` に取り込む。ファイルはコミットし、`.gitignore` しない。これにより、オフラインでも参照可能でバージョン管理された状態を保てる。

### 2. プロジェクト初回に AI_CONTEXT.md を生成する
新規プロジェクトの開始時に、AI に dev-charter を読ませ、プロジェクトルートの `AI_CONTEXT.md` を生成・編集させる。これにより、憲章をプロジェクト固有のコンテキストファイルにコンパイルする。

### 3. 通常セッションでは AI_CONTEXT.md のみ読ませる
以降のセッションでは、AI は dev-charter を直接読まず `AI_CONTEXT.md` のみを読む。トークン消費を最小化しながら、憲章の原則を継続的に反映させる。

### 4. 憲章が更新されたら
`git subtree pull` 後、AI に差分を確認させ、必要に応じて `AI_CONTEXT.md` を更新する。

## インストール (git subtree)

```
git remote add dev-charter https://github.com/y-marui/dev-charter
git fetch dev-charter
git subtree add --prefix=docs/dev-charter dev-charter main --squash
```

## 更新

```
git subtree pull --prefix=docs/dev-charter dev-charter main --squash
```

## Makefile ヘルパー

```
update-charter:
	git subtree pull --prefix=docs/dev-charter dev-charter main --squash
```
