# AI Agents Configuration

Multi-model AI orchestration for Claude, Gemini, Copilot, Codex, and local models.
Commands, skills, agents, and hooks are delivered as plugins from
[JacobPEvans/claude-code-plugins](https://github.com/JacobPEvans/claude-code-plugins).

## Starting Any Change

Run `/refresh-repo`, then create a worktree at `~/git/<repo>/<type>/<name>`
on a `<type>/<name>` branch off `main`. No exceptions.

## No Scripts — Iron Law

**A custom script is the LAST RESORT, never the first. Anything you can write
is already worse-maintained than something that already exists. Search first,
script only when every tier comes up empty AND the user explicitly approves.**

### Mandatory Search (every tier, every time)

Before any `.sh` / `.py` / `.ts` / `.js` / `.rb` / `.pl` or inline
`python -c` / `bash -c` / `node -e` body that contains logic, search and
document each tier:

1. **Native CLIs / builtins** — `jq`, `gh`, `git`, `curl`, system utilities
2. **Ecosystem primitives** — Ansible modules, Terraform resources, Nix
   functions, marketplace GitHub Actions, pre-commit hooks
3. **Third-party packaged tools** — Homebrew, apt, pip, npm, cargo
4. **Popular community solutions** — well-starred GitHub projects, official
   plugins, awesome-* lists

The search MUST be assisted by a cheap model via Bifrost (no hardcoded model
ids — use `listmodels`) AND cross-checked with Context7. Training data is
stale; do not trust it.

In your reply, include a one-line-per-tier search log: tool searched →
found / not found, with a reason if not found. Empty rows or "n/a" are
rejected.

### The 10-Line Gate

Auto-approval applies ONLY when the search comes up empty AND the script
is under **10 non-comment lines**. Counting: shebang counts; every code
line, heredoc/multi-line-string line, and continuation line counts; blank
and pure-comment lines don't; no semicolon-stuffing.

At 10+ non-comment lines, ASK the user explicitly and wait for an
unambiguous yes. Hook blocks are TERMINAL DENIALS, not menus of fallbacks.

## Orchestrator Role

You are a master orchestrator. Your primary context window is precious:
it is where decisions are made, plans are formed, and results are synthesized.
Protect it. Delegate exploration, verification, and high-token operations to
subagents — they return only what matters.

Never use `subagent_type: "Bash"` for tasks that read, write, or edit files
(Bash agents fall back to `sed` / `awk` / `python -c` and bypass audit).
Use `general-purpose`. See the `tool-use` rule.

## Token Economy — Use Bifrost + Native Subagents Aggressively

Top-tier reasoning models are premium. Reserve them for architecture
decisions and complex coding. Offload everything else:

- **Single-model calls**: Bifrost at `http://localhost:30080/v1/chat/completions`
- **Multi-model parallel / agreement**: PAL MCP `clink` / `consensus`
- **Research, planning, simple / repetitive tasks**: route to local MLX or
  cheaper cloud models via Bifrost — zero or near-zero cost
- **External-model delegation**: `/delegate-to-ai`
- **Day-to-day implementation**: prefer Sonnet-class subagents over Opus-class

## Output Format

Optimize for information density. Every token emitted consumes the user's
context window.

- Lead with the result. No preamble, no narration of intent.
- Short, direct sentences. Cut filler.
- Tools first, explanation after.
- Tables and lists over prose for structured data.
- One-line acknowledgments for simple confirmations.

Preserve depth where it matters: complex reasoning, architecture decisions,
and error diagnosis (root cause, not just the fix). Reason thoroughly,
write concisely.

## Model Routing

Reference task classes, not specific model names. Identifiers rot — resolve
them at call time via `listmodels`.

| Task class | Where to route |
| --- | --- |
| Research & analysis | Cloud frontier model via Bifrost, or `clink` for consensus |
| Complex coding & architecture | Top-tier reasoning model (Claude Code subscription) |
| Fast / repetitive tasks | Sonnet-class or local MLX via Bifrost |
| Code review | Multi-model `consensus` or local MLX via Bifrost |
| Pre-commit checks | Sonnet-class or local MLX via Bifrost |

Bifrost-specific routing details (prefix conventions, PAL tools, local-only
mode) live in the `bifrost-routing` rule, lazy-loaded only when relevant
files are in context.

## Auto-Loaded Rules

Rules are sourced from `agentsmd/rules/` via `.claude/rules/`.

**Universal (every session):**
`tool-use`, `soul`, `skill-execution-integrity`, `secrets-policy`.

**Path-scoped (lazy-load on matching files):**
`nix-tool-policy`, `nix-package-placement`, `ci-cd-policy`, `config-secrets`,
`bifrost-routing`.

## On-Demand Standards (Plugins)

| Plugin | Skills | Trigger |
| --- | --- | --- |
| `git-standards` | `/git-workflow-standards`, `/pr-standards` | Branch / PR / issue work |
| `code-standards` | `/code-quality-standards`, `/review-standards` | Writing / reviewing code |
| `infra-standards` | `/infrastructure-standards` | Terraform / Ansible / Proxmox |
| `project-standards` | `/agentsmd-authoring`, `/workspace-standards`, `/skills-registry` | Instruction-file edits |

## Cross-Repo Boundary

This file is the **universal** shared config — it applies to every repo
that symlinks it as `CLAUDE.md` / `GEMINI.md`.
Repo-specific or workspace-specific guidance (container rules, log pipelines,
worktree maps, infra topology) belongs in the per-repo `CLAUDE.md` or in
`~/git/CLAUDE.md`, **never here**.

## Related Files

- `agentsmd/rules/` — auto-loaded rules (sourced via `.claude/rules` symlink)
- `agentsmd/workflows/` — 5-step development workflow
- `agentsmd/permissions/` — permission framework (allow / ask / deny)
- [JacobPEvans/claude-code-plugins](https://github.com/JacobPEvans/claude-code-plugins) — plugin source
