---
name: git-signing
description: Where each AI execution context gets its commit signing identity in JacobPEvans repos. Every commit must be signed; required_signatures is enforced org-wide.
paths:
  - ".github/workflows/**"
  - "**/*.prompt.md"
  - "**/modules/git/**"
  - "**/git-guards/**"
  - "flake.nix"
---

# Git Signing — Identity Per Context

| Context | Identity | Auth | Signing path |
| --- | --- | --- | --- |
| Local Mac | `JacobPEvans` | local user | GPG; nix-home reads identity from `$XDG_CONFIG_HOME/nix-home/local.nix` |
| GitHub Actions | action-specific bot | workflow secret | SSH (`GH_APP_CLAUDE_SSH_SIGNING_KEY` via `use_commit_signing: true`); only via `_ai-action-with-signing.yml` reusable workflow |
| Anthropic Cloud Routines | `JacobPEvans-claude[bot]` | `GH_TOKEN` (long-lived PAT) | web-flow; commits land via `gh api .../contents/...` with `committer.*` overrides |
| GitHub bots (Renovate, etc.) | the bot's GitHub identity | managed by GitHub | web-flow |

## Cloud-routine commit shape

Routines never run `git commit` / `git push`. All commits go through
the Contents API; GitHub web-flow signs them automatically. The routine
env supplies `GH_TOKEN`, `GIT_COMMITTER_NAME`, `GIT_COMMITTER_EMAIL`
(set once on the shared cloud env).

```bash
gh api repos/{owner}/{repo}/contents/{path} \
  -X PUT \
  -f message="..." \
  -f content="$(base64 < file)" \
  -f branch="..." \
  -f committer.name="$GIT_COMMITTER_NAME" \
  -f committer.email="$GIT_COMMITTER_EMAIL"
```

Branch creation: `gh api repos/.../git/refs`. PR creation: `gh pr create`. Result: `verification.verified: true, reason: "valid"`, `author.login: "JacobPEvans-claude[bot]"`.

## Canonical sources (single source of truth, link don't duplicate)

- Architecture: this rule.
- Cloud-routine operator setup: `docs/CLOUD_ROUTINES_AUTH.md` in `JacobPEvans/claude-code-routines`.
- Local Mac identity values: `$XDG_CONFIG_HOME/nix-home/local.nix` (gitignored, out-of-tree).
- AI-action signing wrapper: `_ai-action-with-signing.yml` in `JacobPEvans/ai-workflows`.

If you're about to copy-paste signing prose into another file, link here instead.

## Adding a new context

Pick a real identity (App, user, or bot — never anonymous). Decide auth:
long-lived PAT for sandboxes that can't refresh env; installation token
for actions that mint per-run. Decide signing: web-flow if commits go
through GitHub APIs; SSH/GPG if they go through `git commit`. Add a row
to the table above; document operator setup in the consuming repo.
