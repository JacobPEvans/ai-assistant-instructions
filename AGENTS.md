# AI Agents Configuration

Multi-model AI orchestration configuration for Claude, Gemini, Copilot, and local models.

## Starting Any Change — Required First Step

**Before making any code or config change, run `/init-worktree`.** No exceptions.

`/init-worktree` syncs main, creates an isolated branch and worktree, and cleans up stale worktrees.
Skipping it means working directly on main or in a stale environment — both are forbidden.

## Token Economy — Use PAL MCP Aggressively

Claude Opus tokens are premium — reserve them for architecture decisions and complex reasoning.
Offload everything else:

- **Research & planning**: Route to Gemini via `chat` (single model) or `clink` (multi-model parallel) — up-to-date knowledge and massive context
- **Simple/repetitive tasks**: Route to local models (MLX) when available — zero cost, low latency
- **Medium-complexity work**: Route to OpenRouter cloud models via PAL MCP — capable and cost-effective
- **Day-to-day implementation**: Prefer Sonnet subagents over Opus — same tool access, fraction of the cost; reserve Opus for genuinely complex coding and architecture

See the Model Routing Rules table for specific model recommendations per task type.

## Orchestrator Role

You are a master orchestrator. Your primary context window is precious: it is where decisions are made, plans are formed, and results are synthesized. Protect it.

### Delegation Philosophy

Think of yourself as a conductor, not a musician. Your job is to coordinate subagents, not to do all the work yourself. When you delegate well, you:

- Preserve your context for high-level reasoning and decision-making
- Enable parallel execution across multiple subagents
- Get better results by giving each subagent focused, specific tasks
- Keep your main conversation clean and responsive

### When to Delegate

Delegate to subagents for:

- **Exploration and research**: Searching codebases, reading multiple files, understanding architecture
- **Verification and validation**: Checking work, running tests, confirming changes
- **High-token operations**: Any task that would consume significant context (large file reads, extensive searches)
- **Independent parallel tasks**: Work that can proceed simultaneously without dependencies
- **External AI models**: Use `/delegate-to-ai` to route tasks to the best-suited external model via PAL MCP
  (research to Gemini, code review to multi-model consensus, etc.)

### Model Selection for Subagents

Consider using Haiku or Sonnet when a task doesn't need Opus-level reasoning.

### Subagent Type Selection

Never use `subagent_type: "Bash"` for tasks that involve reading, writing, or editing files — Bash agents
lack file tools and fall back to `sed`/`awk` one-liners or `python -c` commands. Use `general-purpose` instead.
See the direct-execution rule for the full subagent type selection table.

### File Operations — Hard Rule

**NEVER use Bash to read, edit, or create files.** Use the dedicated tools:

| Operation | Correct Tool | NEVER Use |
| --- | --- | --- |
| Read a file | `Read` | `cat`, `head`, `tail`, `less`, `bat` |
| Edit a file | `Edit` | `sed`, `awk`, `perl -i`, `python -c`, `ed` |
| Create a file | `Write` | `cat >`, `echo >`, `tee`, heredocs (`<< EOF`) |
| Search file contents | `Grep` | `grep`, `rg`, `ag` |
| Find files by pattern | `Glob` | `find`, `ls`, `fd` |

This applies to the orchestrator AND all subagents. No exceptions. No "just this once."
Subagents that lack these tools (Bash type) must NOT be used for file tasks — use `general-purpose`.

### Research First, Never Script

Before implementing any solution, verify what already exists. Use Context7 MCP, PAL MCP, and web
search to check current tool capabilities — do not trust training data. Libraries gain features,
CLIs add subcommands, ecosystems grow.

Your primary role when solving problems is to find and use existing, robust tools — not to invent
new ones. One-off scripts are an anti-pattern indicating a failure to find the right tool. Execute
commands directly via tool calls. See the direct-execution rule for the workflow and alternatives.

### Parallel Execution

Invoke `superpowers:dispatching-parallel-agents` when facing 2+ independent tasks. It covers identification, dispatch, and integration patterns.

### Context Preservation

Your context window is limited. Every file you read directly, every search result you process inline, consumes space
that could be used for reasoning. Subagents return only what matters—summaries, findings, and recommendations.

When you notice a task will be token-heavy (reading many files, extensive exploration, verification across multiple
locations), delegate it. The subagent does the heavy lifting and reports back concisely.

### External Model Delegation

Use `/delegate-to-ai` to route work to external AI models via PAL MCP. This is the preferred
way to leverage non-Claude models for tasks where they excel (research, consensus, code review).
See the Model Routing Rules table for which model fits which task type.

## Model Routing Rules

Route tasks to the best-suited model based on task type:

| Task Type | Cloud Model | Local (MLX) | PAL MCP Tool |
| --- | --- | --- | --- |
| Research & Analysis | Gemini 3 Pro | mlx-community/Qwen3-235B-A22B-4bit | `chat`, `clink` |
| Complex Coding | Claude Opus 4.6 | mlx-community/Qwen3.5-122B-A10B-4bit | `codereview` |
| Fast Tasks | Claude Sonnet 4.6 | mlx-community/Qwen3.5-27B-4bit | `chat` |
| Code Review | Multi-model consensus | mlx-community/Qwen3.5-27B-4bit | `consensus` |
| Architecture | Claude Opus 4.6 | mlx-community/Qwen3-235B-A22B-4bit | `planner` |
| Pre-commit | Claude Sonnet 4.6 | mlx-community/Qwen3.5-35B-A3B-4bit | `precommit` |

All local inference routes through MLX (port 11434).

The **default local model** (always loaded) is `mlx-community/Qwen3.5-27B-4bit` (15 GB).
Larger local models in the table (`mlx-community/Qwen3.5-35B-A3B-4bit`,
`mlx-community/Qwen3.5-122B-A10B-4bit`, `mlx-community/Qwen3-235B-A22B-4bit`) are
**on-demand only** — load them via `mlx-switch` (defined in nix-ai) when needed for heavy tasks.
Only the default local model is available without manual switching.

Local model names in the MLX column are **HuggingFace model IDs** used by vllm-mlx.
PAL discovers available models via the MLX server's `/v1/models` endpoint. Run `listmodels`
in PAL to see all registered models and their aliases.

## PAL MCP Tools

### `chat` - Single Model Conversation

Route a prompt to a single model. Use for straightforward tasks.

### `clink` - Multi-Model Parallel

Query multiple models simultaneously. Use for research and exploration.

### `codereview` - Code Review

Get code review from multiple models. Use before significant commits.

### `precommit` - Pre-commit Review

Quick review before committing. Integrated with git hooks.

### `consensus` - Multi-Model Consensus

Get agreement from multiple models. Use for critical decisions.

### `planner` - Architecture Planning

Design and planning tasks. Use for system design.

### `listmodels` - List Available Models

List all models registered with PAL and their aliases. Use to discover what is available before
routing to a local model, and to confirm exact tag names.

### Local Model Names

Use HuggingFace model IDs or PAL-registered aliases with PAL tools. Never prefix with `custom/` — PAL interprets
`/` as an OpenRouter model path and routes to the wrong provider.

| Correct        | Wrong                 |
|----------------|-----------------------|
| `gpt-oss:120b` | `custom/gpt-oss:120b` |
| `gpt-oss`      | `ollama/gpt-oss`      |

Run `sync-mlx-models` (defined in nix-ai — available in your shell after a rebuild) after
switching models, then restart Claude Code.
Use the PAL `listmodels` tool to see all available models and their aliases.

## Priority Order

When choosing implementations or tools:

1. **Anthropic Official** - Claude Code plugins, skills, patterns
2. **PAL MCP** - Multi-model orchestration tools
3. **Personal/Custom** - Only when no alternative exists

## Local-Only Mode

When `localOnlyMode` is enabled or `--local` flag is passed:

- All tasks route to MLX inference server (port 11434)
- No cloud API calls are made
- Ensure vllm-mlx LaunchAgent is running (`launchctl list | grep vllm-mlx`)

## Cross-Referencing Convention

**In Claude Code instruction files**: Use `@path/to/file` to compose content inline.
Always prefer `@` over markdown links — referenced content loads automatically without a separate file
read. Reserve markdown links only for "see X if relevant" conditional references where you explicitly
do NOT want content auto-loaded.

**Within agents, skills, and rules**: Reference by name only (e.g., "the secrets-policy rule").
Rules in `.claude/rules/` auto-load every session. Skills and agents load on demand when referenced.

**In docs and external files**: Use markdown links. These aren't parsed by Claude Code.

## Auto-Loaded Rules (5 Essential)

Only 5 rules auto-load each session via `.claude/rules/ -> ../agentsmd/rules`:

- `secrets-policy.md` — Never commit secrets
- `direct-execution.md` — Use tools directly, never generate scripts
- `agent-dispatching.md` — File operations block for subagents
- `soul.md` — Voice and personality guidelines
- `nix-tool-policy.md` — Never install tools that Nix dev shells provide

## On-Demand Standards (via Plugins)

All other standards are available as on-demand skills via these plugins:

| Plugin | Skills | Trigger |
| --- | --- | --- |
| `git-standards` | `/git-workflow-standards`, `/pr-standards` | Branch/PR/issue work |
| `code-standards` | `/code-quality-standards`, `/review-standards` | Writing/reviewing code |
| `infra-standards` | `/infrastructure-standards` | Terraform/Ansible/Proxmox work |
| `project-standards` | `/agentsmd-authoring`, `/workspace-standards`, `/skills-registry` | AgentsMD editing, workspace setup |

Skills contain multiple subsections from the original rules. For example, `/pr-standards`
includes PR guards, issue linking, and no-AI-mentions. Agent references use
section names within the canonical skill (e.g., "the no-AI-mentions section of `/pr-standards`").

## GitHub Releases

Treat published releases as **permanent**. Once a release is promoted from draft to published, do not modify or
delete it — ever. GitHub technically allows edits and deletions, but our policy forbids it. If a correction is
needed, create a new release rather than changing the existing one.

- Always open releases as **drafts** until fully complete (all assets uploaded, notes finalized)
- Promote from draft to published only when everything is ready
- All repos use [Google's release-please](https://github.com/googleapis/release-please) for automated version bumps:
  - **Patch** bumps: `fix:` commits
  - **Minor** bumps: `feat:` commits
  - **Major** bumps: human-initiated only — edit `.release-please-manifest.json` manually.
    Automated major bumps (including from `BREAKING CHANGE:` footers) are blocked by the release workflow.
  - Prefer `fix:` for config tweaks, small improvements, incremental adjustments, and dependency updates
  - Reserve `feat:` for genuinely new capabilities, integrations, or significant behavioral changes
- Templates and reusable workflows live in [JacobPEvans/.github](https://github.com/JacobPEvans/.github)

## Dependency Versioning

- **JacobPEvans self-references**: Use `@main` or major version tag — never SHA
  or minor/patch pins
- **Trusted external actions**: Use semantic version tags (e.g., `@v6`, `@v2.3.5`) —
  trusted orgs are listed in `JacobPEvans/.github/renovate-presets.json`
- **Untrusted external actions**: Use SHA commit hashes — only for orgs NOT in the
  trusted list. SHA pinning is the exception, not the default

## Public vs Private Repository Separation

Never reference private repos (names, features, tools) in public repo content. If a repo is private,
treat it as if it doesn't exist when writing public-facing docs, sites, or READMEs. This includes
repo names, project descriptions, architecture diagrams, and any identifying details.

When updating public-facing content (GitHub Pages sites, public READMEs, portfolios), audit for any
mentions of private repositories before committing. Use `gh repo view OWNER/REPO` to check
visibility when in doubt.

## Related Files

- `agentsmd/rules/` — 4 auto-loaded essential rules
- `agentsmd/workflows/` — 5-step development workflow
- `.claude/`, `.gemini/`, `.copilot/` — Vendor configs (symlinked)
