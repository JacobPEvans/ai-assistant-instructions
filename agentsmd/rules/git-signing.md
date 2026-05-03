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

| Context | Identity | Key location |
| --- | --- | --- |
| Local Mac | `JacobPEvans` | GPG key in macOS keychain; nix-home reads identity from `$XDG_CONFIG_HOME/nix-home/local.nix` |
| GitHub Actions | action-specific bot | `GH_CLAUDE_SSH_SIGNING_KEY` repo secret; called only via the `_ai-action-with-signing.yml` reusable workflow |
| Anthropic Cloud Routines | `claude-routines-bot` | `CLAUDE_ROUTINES_SSH_SIGNING_KEY` cloud env; loaded by `bootstrap-signing.sh` at routine start |
| GitHub bots (Renovate, etc.) | the bot's GitHub identity | managed by GitHub; web-flow signed |

## Canonical sources (single source of truth, link don't duplicate)

- Architecture: this rule.
- Cloud-routine bootstrap: `bootstrap-signing.sh` in `JacobPEvans/claude-code-routines`.
- Local Mac identity values: `$XDG_CONFIG_HOME/nix-home/local.nix` (gitignored, out-of-tree).
- AI-action signing wrapper: `_ai-action-with-signing.yml` in `JacobPEvans/ai-workflows`.
- `claude-routines-bot` setup: `BOT_SETUP.md` in `JacobPEvans/claude-code-routines`.

If you're about to copy-paste signing prose into another file, link here instead.

## Adding a new context

Pick (or provision) an identity, distribute its key to the runtime,
configure git to sign at startup, then add a row to the table above.
Don't reinvent the bootstrap shape — copy `bootstrap-signing.sh` if at
all possible.
