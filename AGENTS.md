# AI Agents Configuration

Commands, skills, agents, and hooks are delivered via [JacobPEvans/claude-code-plugins](https://github.com/JacobPEvans/claude-code-plugins).

## No Scripts — Iron Law

**A custom script is the LAST RESORT. Search first; script only when every
tier comes up empty AND approval is granted (see the 10-line gate below).**

### Scripts must be dedicated files

Scripts MUST be standalone files with a proper extension (`.sh`, `.py`,
`.ts`, `.js`, `.rb`, `.pl`) under one of: `scripts/`, `.github/scripts/`,
`.claude/hooks/`, `tests/`, or `plugins/<name>/hooks/` directories. **Never
comingled in non-script files. No exceptions.**

### What counts as an inline script (BANNED)

These are scripts even when they don't end in `.sh` — all forbidden in
non-script files:

- YAML `run:` blocks with logic — `if`, `for`, `while`, `case`, multi-step
  retry, or more than 3 lines of shell.
- Markdown code blocks intended for copy-paste-execute, when they contain
  logic.
- `Bash` tool commands with embedded multi-line control flow
  (`while ...; do ...; done`, `for x in ...; do ...; done`,
  `if [[ ... ]]; then ...; fi`) inside a single `command` string.
- Heredoc payloads (`<<EOF`, `<<'EOF'`, `<<-EOF`) feeding logic to a target
  — `bash <<EOF`, `python <<EOF`, `cat <<EOF | sh`.
- Command-substitution heredocs smuggling a script body into a one-liner:
  `git commit -m "$(cat <<'EOF' ... EOF)"`,
  `gh pr create --body "$(cat <<'EOF' ... EOF)"` *when the body is
  generated logic* (pre-written prose body is fine — see Allowed below).
- `python -c '...'`, `node -e '...'`, `perl -e '...'`, `ruby -e '...'`,
  `sh -c '<multiline>'`, `bash -c '<multiline>'`.

### What is allowed (not a script; rule does not trigger)

- Single-line shell commands and pipelines, however clever
  (`gh api ... | jq -r ... | xargs -I{} gh api --method DELETE ...`).
- One-line heredocs feeding **pre-existing prose** to a CLI:
  `gh pr create --body "$(cat <<'EOF' ... EOF)"` where the body is the PR
  description text the user will see, not generated logic.
- YAML `run:` blocks of 1–3 lines with no control flow (`run: pnpm install`,
  `run: terraform validate`).
- Inline shell inside a single `Bash` call WITHOUT control flow keywords
  AND WITHOUT newlines (`a && b && c` is fine; multi-line is not).

### Mandatory four-tier search (before any new dedicated script file)

Search and document each tier:

1. **Native CLIs / builtins** — `jq`, `gh`, `git`, `curl`, system utilities
2. **Ecosystem primitives** — Ansible modules, Terraform resources, Nix
   functions, marketplace Actions, pre-commit hooks
3. **Third-party packaged tools** — Homebrew, apt, pip, npm, cargo
4. **Popular community solutions** — well-starred GitHub projects, official
   plugins, awesome-* lists

Use a cheap model via Bifrost (`listmodels`) + Context7; include a
one-line-per-tier search log (`<Tier>: <tool> - <found / not found>, <reason>`) — empty
rows or "n/a" are rejected.

### The 10-line gate (only after search is empty)

When a dedicated script file is genuinely required:

- Under 10 non-comment lines AND search empty: auto-approved.
  (Counting: shebang counts; every code line, heredoc/multi-line-string
  line, and continuation line counts; blank and pure-comment lines don't;
  no semicolon-stuffing.)
- 10+ non-comment lines: ASK the user and wait for an unambiguous yes.

Hook blocks are TERMINAL DENIALS. When a hook blocks an action, stop and
reconsider — do not look for a workaround.

See `agentsmd/rules/no-scripts.md` for full rationale, worked examples,
and the dedicated-directory allow-list.

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

**Universal:** `tool-use`, `soul`, `skill-execution-integrity`, `secrets-policy`, `no-scripts`
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
