# AI Agents Configuration

Commands, skills, agents, and hooks are delivered via [JacobPEvans/claude-code-plugins](https://github.com/JacobPEvans/claude-code-plugins).

## Starting Any Change

Run `/refresh-repo`, then create a worktree at `~/git/<repo>/<type>/<name>`
on a `<type>/<name>` branch off `main`. No exceptions.

## Scope Boundary

Always one-shot a working local solution. You may mention a suspected upstream
bug as an FYI to the user, but never file issues, open PRs, or push fixes to
upstream projects outside the user's organizations.

If a true one-shot is not achievable, recommend creating GitHub issues in the
user's own repos for persistent tracking — do not use Claude Code's internal
TODO system as a substitute for durable issue tracking.

## No Scripts — Iron Law

**A custom script is the LAST RESORT. Search first, script only when every tier comes up empty AND the user explicitly approves.**

### Mandatory Search (every tier, every time)

Before any script or inline code with logic, search and document each tier:

1. **Native CLIs / builtins** — `jq`, `gh`, `git`, `curl`, system utilities
2. **Ecosystem primitives** — Ansible modules, Terraform resources, Nix functions, marketplace Actions, pre-commit hooks
3. **Third-party packaged tools** — Homebrew, apt, pip, npm, cargo
4. **Popular community solutions** — well-starred GitHub projects, official plugins, awesome-* lists

Use a cheap model via Bifrost (`listmodels`) + Context7; include a one-line-per-tier search log
(tool → found/not found, reason) — empty rows or "n/a" are rejected.

### The 10-Line Gate

Auto-approval only when search is empty AND the script is under 10 non-comment lines
(shebang, code, heredoc/multi-line-string, and continuation lines count; blank and pure-comment lines don't; no semicolon-stuffing).
At 10+, ASK and wait for an unambiguous yes. Hook blocks are TERMINAL DENIALS.

## Orchestrator Role

Protect your context window — delegate exploration and high-token operations to subagents.
Never use `subagent_type: "Bash"` for file reads/writes/edits; use `general-purpose`.
See the `tool-use` rule.

## Token Economy — Use Bifrost + Native Subagents Aggressively

- **Single-model calls**: Bifrost at `http://localhost:30080/v1/chat/completions`
- **Multi-model parallel / agreement**: PAL MCP `clink` / `consensus`
- **Research, planning, simple / repetitive tasks**: local MLX or cheap cloud via Bifrost
- **External-model delegation**: `/delegate-to-ai`
- **Day-to-day implementation**: prefer Sonnet-class over Opus-class

## Output Format

- Lead with the result. No preamble.
- Short sentences. Tools before explanation. Tables over prose.
- One-line acks for simple confirmations.
- Preserve depth for root cause analysis and architecture decisions.

## Commit & PR Style

See soul.md section 4 — no emoji; conventional-commit prefixes for subjects/titles; plain prose everywhere else.

## Model Routing

Resolve model names at call time via `listmodels`.

| Task class | Where to route |
| --- | --- |
| Research & analysis | Cloud frontier model via Bifrost, or `clink` for consensus |
| Complex coding & architecture | Top-tier reasoning model (Claude Code subscription) |
| Fast / repetitive tasks | Sonnet-class or local MLX via Bifrost |
| Code review | Multi-model `consensus` or local MLX via Bifrost |
| Pre-commit checks | Sonnet-class or local MLX via Bifrost |

Bifrost routing details in the `bifrost-routing` rule (lazy-loaded).

## Auto-Loaded Rules

Sources: `agentsmd/rules/` via `.claude/rules/`.

**Universal:** `tool-use`, `soul`, `skill-execution-integrity`, `secrets-policy`
**Path-scoped:** `nix-tool-policy`, `nix-package-placement`, `ci-cd-policy`, `config-secrets`, `bifrost-routing`

## On-Demand Standards (Plugins)

| Plugin | Skills | Trigger |
| --- | --- | --- |
| `git-standards` | `/git-workflow-standards`, `/pr-standards` | Branch / PR / issue work |
| `code-standards` | `/code-quality-standards`, `/review-standards` | Writing / reviewing code |
| `infra-standards` | `/infrastructure-standards` | Terraform / Ansible / Proxmox |
| `project-standards` | `/agentsmd-authoring`, `/workspace-standards`, `/skills-registry` | Instruction-file edits |

## Cross-Repo Boundary

Universal config — import into per-repo `CLAUDE.md` via `@AGENTS.md`. Repo-specific guidance belongs in the per-repo `CLAUDE.md` or `~/git/CLAUDE.md`.

## Related Files

- `agentsmd/rules/` — auto-loaded rules
- `agentsmd/workflows/` — 5-step development workflow
- `agentsmd/permissions/` — permission framework
- [JacobPEvans/claude-code-plugins](https://github.com/JacobPEvans/claude-code-plugins)
