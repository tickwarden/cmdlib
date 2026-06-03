# Contributing to cmdlib

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a branch: `git checkout -b feat/my-feature`
4. Make your changes
5. Commit using [Conventional Commits](#commit-messages)
6. Push and open a Pull Request against `main`

## Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/).

| Prefix | Use for |
|---|---|
| `feat:` | New functionality |
| `fix:` | Bug fixes |
| `docs:` | README, CONTRIBUTING, comments |
| `refactor:` | Code changes that don't add features or fix bugs |
| `chore:` | Maintenance (CI, deps, repo config) |

Examples:

```
feat: add prefix-match denylist for 1.20.2+
fix: correct forceload coordinate in core/init
docs: document batch execution gap behavior
```

## Code Style

- One command per line — no backslash continuation
- Comment blocks use `# ---` separators
- Internal functions are prefixed with `_` (e.g. `batch/_step`)
- All fake players use the `#` prefix in scoreboard commands
- No multi-spaces on command lines (spyglassmc strict parse)
- No `/return` — guard logic uses `#cmdlib.ok` flag chaining for 1.18.2 compatibility

## Pull Requests

- Keep PRs focused — one feature or fix per PR
- Update relevant comments in `.mcfunction` files if behavior changes
- If you add a new module, document it in `README.md`
- PRs that break 1.18.2 compatibility will not be merged unless the change is gated behind a version-specific overlay

## Reporting Issues

Use the issue templates provided in this repository.
