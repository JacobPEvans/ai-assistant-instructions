---
description: Use marketplace actions and reusable workflows over custom scripts — allowed script locations for committed artifacts
paths:
  - ".github/**"
  - "Makefile"
  - "scripts/**"
  - "hooks/**"
---

# CI/CD Policy

## Prefer Native CI/CD Constructs

| Task | Use This | Not This |
| --- | --- | --- |
| CI/CD automation | Marketplace actions, reusable workflows, composite actions | Custom shell script |
| GitHub Actions logic | Expressions, `fromJSON()`, matrix strategies | Python/bash in step |

## Committed Script Rules

When scripts ARE needed as committed artifacts (CI/CD workflows, pre-commit hooks, `Makefile`s):

1. Place in an allowed directory: `scripts/`, `hooks/`, `.github/`, or `tests/`
2. Use proper file extension (.sh, .py)
3. NEVER create temp/throwaway scripts — if it's not committed, it's not needed
