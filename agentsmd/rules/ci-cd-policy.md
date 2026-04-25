---
description: CI/CD automation rules — marketplace actions over custom scripts, release-please conventions, action-version pinning
paths:
  - ".github/**"
  - "Makefile"
  - "scripts/**"
  - "hooks/**"
  - "tests/**"
---

# CI/CD Policy

## Prefer Native CI/CD Constructs

| Task | Use This | Not This |
| --- | --- | --- |
| CI/CD automation | Marketplace actions, reusable workflows, composite actions | Custom shell script |
| GitHub Actions logic | Expressions, `fromJSON()`, matrix strategies | Python/bash in step |

## GitHub Releases

Treat published releases as **permanent**.
Once a release is promoted from draft to published, do not modify or delete it — ever.
GitHub technically allows edits and deletions, but our policy forbids it.
If a correction is needed, create a new release rather than changing the existing one.

- Always open releases as **drafts** until fully complete
  (all assets uploaded, notes finalized).
- Promote from draft to published only when everything is ready.
- All repos use [release-please](https://github.com/googleapis/release-please)
  for automated version bumps:
  - **Patch** bumps: `fix:` commits
  - **Minor** bumps: `feat:` commits
  - **Major** bumps: human-initiated only — edit `.release-please-manifest.json` manually.
    Automated major bumps (including from `BREAKING CHANGE:` footers) are blocked
    by the release workflow.
- Conventional-commit style preference:
  - Prefer `fix:` for config tweaks, small improvements, incremental adjustments,
    and dependency updates.
  - Reserve `feat:` for genuinely new capabilities, integrations, or significant
    behavioral changes.
- Templates and reusable workflows live in
  [JacobPEvans/.github](https://github.com/JacobPEvans/.github).

## Dependency Versioning

- **Self-references (JacobPEvans/\*)**: Use `@main` or a major version tag —
  never SHA or minor/patch pins.
- **Trusted external actions**: Use version tags (major like `@v6` or full
  SemVer like `@v2.3.5`).
  Trusted orgs are listed in `JacobPEvans/.github/renovate-presets.json`.
- **Untrusted external actions**: Use SHA commit hashes — only for orgs NOT
  in the trusted list. SHA pinning is the exception, not the default.
