# {Project Name}

> **This file is the English reference.**
> The canonical version (Japanese) is [README-jp.md](README-jp.md).

[![License: All Rights Reserved](https://img.shields.io/badge/License-All%20Rights%20Reserved-red.svg)](LICENSE)
[![CI](https://github.com/{user}/{repo}/actions/workflows/{workflow}.yml/badge.svg)](https://github.com/{user}/{repo}/actions/workflows/{workflow}.yml)
[![Charter Check](https://github.com/{user}/{repo}/actions/workflows/dev-charter-check.yml/badge.svg)](https://github.com/{user}/{repo}/actions/workflows/dev-charter-check.yml)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/[USERNAME]?style=social)](https://github.com/sponsors/[USERNAME])
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-donate-yellow.svg)](https://www.buymeacoffee.com/[BMC_USERNAME])

{One-line description: what it does, for whom, and how it helps.}

---

## Setup

```bash
git clone https://github.com/{user}/{repo}.git
cd {repo}
open "{Project Name}.xcodeproj"
```

---

## Usage

```bash
# macOS build
xcodebuild -project "{Project Name}.xcodeproj" -scheme "{Project Name}" -configuration Debug -destination "platform=macOS" build
```

| Command | Description |
|---|---|
| `make bootstrap` | Install dependencies / generate project |
| `make lint` | Run SwiftLint |
| `make format` | Run SwiftFormat |
| `make build` | Build the app |
| `make test` | Run tests |
| `make clean` | Remove build artifacts |

---

## License

All Rights Reserved — [LICENSE](LICENSE)

---
*This document has a Japanese canonical version [README-jp.md](README-jp.md). Update both in the same commit when editing.*
