# {プロジェクト名}

> **このファイルは正本（日本語版）です。**
> 英語版（参照）は [README.md](README.md) を参照してください。

[![License: All Rights Reserved](https://img.shields.io/badge/License-All%20Rights%20Reserved-red.svg)](LICENSE)
[![CI](https://github.com/{user}/{repo}/actions/workflows/{workflow}.yml/badge.svg)](https://github.com/{user}/{repo}/actions/workflows/{workflow}.yml)
[![Charter Check](https://github.com/{user}/{repo}/actions/workflows/dev-charter-check.yml/badge.svg)](https://github.com/{user}/{repo}/actions/workflows/dev-charter-check.yml)

{一行概要：「何を・誰のために・どう解決するか」を 1 文で}

---

## Setup

```bash
git clone https://github.com/{user}/{repo}.git
cd {repo}
open "{プロジェクト名}.xcodeproj"
```

---

## Usage

```bash
# macOS ビルド
xcodebuild -project "{プロジェクト名}.xcodeproj" -scheme "{プロジェクト名}" -configuration Debug -destination "platform=macOS" build
```

| コマンド | 内容 |
|---|---|
| `make bootstrap` | 依存関係のインストール・プロジェクト生成 |
| `make lint` | SwiftLint によるコードチェック |
| `make format` | SwiftFormat によるフォーマット |
| `make build` | アプリのビルド |
| `make test` | テスト実行 |
| `make clean` | ビルド成果物の削除 |

---

## License

All Rights Reserved — [LICENSE](LICENSE)

---
*この文書には英語版 [README.md](README.md) があります。編集時は同一コミットで更新してください。*
