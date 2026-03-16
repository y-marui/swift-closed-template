# Dev Charter

> **This is the reference (English) version.**
> For the canonical (Japanese) version, see [README-jp.md](README-jp.md).

Shared development charter for AI-assisted software projects.

This repository defines common philosophy, architecture principles,
and development rules used across projects.

## Documents

| File | Description |
|---|---|
| [PRINCIPLES.md](PRINCIPLES.md) | Development philosophy, design and architecture principles |
| [CODE_STYLE.md](CODE_STYLE.md) | Code style guide |
| [AI_COLLABORATION_RULES.md](AI_COLLABORATION_RULES.md) | AI collaboration rules and role assignments |
| [AI_CONTEXT_HIERARCHY.md](AI_CONTEXT_HIERARCHY.md) | AI context priority hierarchy |
| [LANGUAGE_POLICY.md](LANGUAGE_POLICY.md) | Language policy (canonical = Japanese) |
| [LOCALIZATION_POLICY.md](LOCALIZATION_POLICY.md) | Localization and supported languages |
| [PROJECT_LIFECYCLE.md](PROJECT_LIFECYCLE.md) | Project lifecycle and team structure |
| [UI_GUIDELINES.md](UI_GUIDELINES.md) | UI guidelines, color palette, iconography |
| [MONETIZATION_POLICY.md](MONETIZATION_POLICY.md) | Monetization policy and platform-specific guidelines |
| [SECURITY_POLICY.md](SECURITY_POLICY.md) | Security policy and hook configuration reference |

## How to Use

### 1. Add to your project
Use `git subtree` to pull dev-charter into `docs/dev-charter/`. Commit the files — do not `.gitignore` them. This keeps the charter version-controlled, reproducible, and accessible offline.

### 2. Generate AI_CONTEXT.md at project setup
At the start of a new project, have the AI read the dev-charter files and generate or update `AI_CONTEXT.md` at the project root. This compiles the charter into a project-specific context file.

### 3. Use AI_CONTEXT.md in day-to-day sessions
In subsequent sessions, the AI reads only `AI_CONTEXT.md` — not the dev-charter directly. This minimizes token consumption while keeping the principles in effect.

### 4. Update when the charter changes
After `git subtree pull`, have the AI review the diff and update `AI_CONTEXT.md` as needed.

## Install (git subtree)

```
git remote add dev-charter https://github.com/y-marui/dev-charter
git fetch dev-charter
git subtree add --prefix=docs/dev-charter dev-charter main --squash
```

## Update

```
git subtree pull --prefix=docs/dev-charter dev-charter main --squash
```

## Makefile helper

```
update-charter:
	git subtree pull --prefix=docs/dev-charter dev-charter main --squash
```
