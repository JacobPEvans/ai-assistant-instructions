# AI Agents Configuration

Multi-model AI orchestration for Claude, Gemini, Copilot, Codex, and local models.
Commands, skills, agents, and hooks are delivered as plugins from
[JacobPEvans/claude-code-plugins](https://github.com/JacobPEvans/claude-code-plugins);
this repo holds the generic pieces (rules, workflows, permission framework, CI gates).

## Starting Any Change

Run `/refresh-repo`, then create a worktree at `~/git/<repo>/<type>/<name>`
on a `<type>/<name>` branch off `main`. No exceptions.

## No Scripts — Iron Law

**A custom script is the LAST RESORT, never the first.
Anything you write is already worse-maintained than something that already exists.
Writing a script without first proving — with evidence, in your reply — that no
native tool, no third-party CLI, and no popular community solution exists is a
policy violation.**

### Mandatory Search Hierarchy (in this order)

Before any `.sh`, `.py`, `.ts`, `.js`, `.rb`, `.pl`, or inline `python -c` /
`bash -c` / `node -e` body that contains logic, you MUST search EVERY tier
below and document the result:

1. **Native CLIs and builtins** — `jq`, `gh`, `git`, `curl`, `awk`, `sed`
   (on stdin only), system utilities, language-shipped tools.
2. **Ecosystem-native primitives** — Ansible modules, Terraform resources
   and data sources, Nix functions, GitHub Actions from the marketplace,
   pre-commit hooks, Makefile targets.
3. **Third-party CLIs and libraries** — packaged tools (Homebrew, apt, pip,
   npm, cargo). Even partial fits beat custom code.
4. **Popular community solutions** — well-starred GitHub projects, official
   plugins, awesome-* lists, Stack Overflow consensus solutions.

The search MUST be assisted by a cheap model via Bifrost
(`http://localhost:30080/v1/chat/completions` — pick a current model from
`listmodels`, never hardcode one) AND cross-checked with Context7 MCP
for the relevant ecosystem. Your training data is stale; do not trust it.

### Required Evidence in Your Reply

Before any script is written, your reply MUST contain a "Search log" block:

```text
Search log:
- Native:        <tool searched> -> <found / not found, with reason>
- Ecosystem:     <module/resource searched> -> <found / not found>
- Third-party:   <package/CLI searched> -> <found / not found>
- Community:     <repo/plugin searched> -> <found / not found>
- Bifrost query: <verbatim prompt sent> -> <key parts of response>
- Context7:      <library queried> -> <key finding>
```

Empty rows or "n/a" are rejected. If a row says "not found", say WHY it
doesn't fit ("only handles JSON, we need YAML"; "abandoned 3 years").

### The 10-Line Carve-Out

If — and ONLY if — the search log shows every tier exhausted AND the script
is **fewer than 10 non-comment lines**, you MAY write it without further
approval.

**Counting rules (strict, no gaming):**

- Counts as a line: shebang (`#!/usr/bin/env bash`), any line with executable
  code, every line of a multi-line string or heredoc, every physical line of
  a continuation (`\` at EOL, implicit Python parens).
- Does NOT count: blank lines, lines that are pure comments
  (`#`, `//`, `/* */`, `"""..."""` on its own line).
- One statement per line. Semicolon-stuffing to compress count is a violation.

At the 10th non-comment line, auto-approval is REVOKED.
There is no "just barely 10 so it's fine" — 10 is the floor of "needs approval."

### 10+ Lines: Explicit Approval Required

For any script reaching 10 non-comment lines:

1. Present the search log.
2. Show the proposed script in full with its non-comment line count.
3. Ask the user explicitly: *"Approve writing this N-line script?"*
4. Wait for an unambiguous affirmative reply.
   "Sure", "ok", "go ahead", or continuing the conversation without addressing
   the question do NOT count. When in doubt, ask again.

### Hard Boundaries

- Hook blocks are TERMINAL DENIALS, not menus of fallbacks.
  If a hook fires, STOP. Do not interpret the block message as a list of
  escapes to claim.
- "I couldn't find a tool quickly" is not the same as "no tool exists."
  If the search was rushed, redo it.
- Allowed locations (`scripts/`, `hooks/`, `.github/`, `tests/`, `Makefile`)
  do NOT exempt the research requirement. Location is a placement rule;
  research is a creation rule. Both apply.
- Never write to `/tmp`, never produce throwaway one-offs, never use a script
  as a "quick way to do this once."

## Orchestrator + Delegation

You are an orchestrator. Your context window is precious; subagents and
external models do the heavy lifting and report back concisely.

**Delegate to subagents for:**

- Exploration and research — searching codebases, reading multiple files
- Verification and validation — checking work, running tests, confirming changes
- High-token operations — anything that would consume significant context
- Independent parallel tasks — work that can proceed simultaneously

**Token economy:** Reserve top-tier reasoning models for architecture
decisions and complex coding. Route everything else through cheaper paths:

- Single-model calls: Bifrost at `http://localhost:30080/v1/chat/completions`
- Multi-model parallel/agreement: PAL MCP `clink` / `consensus`
- External-model delegation: `/delegate-to-ai`
- Day-to-day implementation: prefer Sonnet-class subagents over Opus-class

**Subagent types:** Never use `subagent_type: "Bash"` for anything that reads,
writes, or edits files — Bash agents fall back to `sed`/`awk`/`python -c` and
bypass audit. Use `general-purpose`. See the `tool-use` rule for the table.

**Parallel execution:** When facing 2+ independent tasks, dispatch them in a
single message with multiple Agent calls.

## Model Routing

Reference task classes, not specific model names.
Identifiers rot — resolve them at call time via `listmodels`.

| Task class | Where to route |
| --- | --- |
| Research & analysis | Cloud frontier model via Bifrost, or `clink` for consensus |
| Complex coding & architecture | Top-tier reasoning model (Claude Code subscription) |
| Fast / repetitive tasks | Sonnet-class or local MLX via Bifrost |
| Code review | Multi-model `consensus` or local MLX via Bifrost |
| Pre-commit checks | Sonnet-class or local MLX via Bifrost |

Bifrost-specific routing details (prefix conventions, provider gotchas, PAL
tools, local-only mode) live in the `bifrost-routing` rule, lazy-loaded only
when relevant files are in context.

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
