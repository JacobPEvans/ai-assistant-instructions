# AI Agents Configuration

Multi-model AI orchestration configuration for Claude, Gemini, Copilot, and local models.

## Model Routing Rules

Route tasks to the best-suited model based on task type:

| Task Type | Cloud Model | Local Model | PAL MCP Tool |
| --- | --- | --- | --- |
| Research & Analysis | Gemini 3 Pro | qwen3-next:80b | `chat`, `clink` |
| Complex Coding | Claude Opus 4.5 | qwen3-coder:30b | `codereview` |
| Fast Tasks | Claude Sonnet 4.5 | qwen3-next:latest | `chat` |
| Code Review | Multi-model consensus | deepseek-r1:70b | `consensus` |
| Architecture | Claude Opus 4.5 | qwen3-next:80b | `planner` |
| Pre-commit | Claude Sonnet 4.5 | qwen3-coder:30b | `precommit` |

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

## Priority Order

When choosing implementations or tools:

1. **Anthropic Official** - Claude Code plugins, skills, patterns
2. **PAL MCP** - Multi-model orchestration tools
3. **Agent OS** - Structured development workflows
4. **Personal/Custom** - Only when no alternative exists

## Local-Only Mode

When `localOnlyMode` is enabled or `--local` flag is passed:

- All tasks route to Ollama models
- `OLLAMA_HOST` is passed to PAL MCP
- No cloud API calls are made

## Secrets

API keys are retrieved at runtime from macOS Keychain (`ai-secrets` keychain).
Keys are NEVER stored in files or environment variables.

## Worktree-Based Development

**All changes must be made on a dedicated worktree/branch.** This repo uses worktrees for session isolation.

See [Worktrees](./agentsmd/rules/worktrees.md) for structure and usage details.

**Key requirements:**

- **ALWAYS run `/init-worktree` before starting any new development work**
- Create worktrees from a synced main branch
- Keep main regularly updated: `cd ~/git/<repo>/main && git pull`
- See [Branch Hygiene](./agentsmd/rules/branch-hygiene.md) for sync rules

**Skip worktrees only for:**

- 1-line typo/config fixes on main
- Read-only exploration/research tasks
- Working in an already-initialized worktree

## Core Principles

- **Accuracy and Truth**: Prioritize correctness over pleasing the user
- **Idempotency**: Operations should be repeatable with consistent results
- **Best Practices**: Follow industry and project-specific standards
- **Clarity**: Ask for clarification when requests are ambiguous
- **No Sycophancy**: Provide correct advice, not validation of bad ideas

See [Soul](./agentsmd/rules/soul.md) for personality and voice guidelines.

## Token Conservation

**Critical**: Context tokens are limited (200K window). Minimize token usage at startup while maximizing capability through lazy-loading.

### File Size Limits

- **Maximum**: 1,000 tokens per file (hard limit)
- **Target**: 500 tokens per file (ideal)
- **CLAUDE.md additions**: Absolute bare minimum tokens - link to rules/agents/skills for details

### DRY Principle (Don't Repeat Yourself)

**NEVER duplicate**. Define once, reference everywhere:

- Numbers, thresholds, limits (e.g., 50-comment PR limit)
- Patterns, workflows, algorithms
- Documentation, descriptions, explanations
- Configuration values

Applies to: code, docs, todos, commands, agents, skills, rules.

**Single-Purpose Design**: Each command, agent, skill, and rule must have one clearly defined purpose. This constraint keeps files focused and token counts minimal.

### Hierarchy and Usage

**Preference order** (from least to most preferred):

1. **Commands** - Thin wrappers only. Orchestrate agents/skills, never contain logic.
2. **Rules** - For directory/file-specific patterns. Link from CLAUDE.md when universal.
3. **Skills** - Reusable patterns. Keep <500 tokens. Reference freely across commands/agents.
4. **Agents** - Execution workers. Can switch models for targeted tasks. Return only what orchestrator needs.

### Loading Strategy

**Always loaded** (startup):

- AGENTS.md (this file) - minimal, links to everything
- Universal skills: worktree-management, github-cli-patterns, subagent-batching, permission-patterns
- High-frequency patterns (used 50+ times)

**Load on-demand** (when command invokes):

- PR workflow skills: pr-comment-limit-enforcement, pr-health-check, pr-thread-resolution-enforcement, github-graphql
- Specialized skills used <20% of sessions
- Troubleshooting agents

Note: Claude Code loads skills when commands reference them, not at startup.

### Best Practices

**Frontmatter** (required, varies by type):

- **Skills**:

  ```yaml
  ---
  name: skill-name
  description: Pattern description
  version: "X.Y.Z"  # Increment patch for small fixes, minor for features, major for breaking changes (human-only)
  author: "JacobPEvans"
  ---
  ```

- **Agents**:

  ```yaml
  ---
  name: agent-name
  description: Action-focused description
  model: haiku  # or sonnet/opus
  author: JacobPEvans
  allowed-tools: [list of tools]
  ---
  ```

- **Commands**:

  ```yaml
  ---
  description: Workflow summary
  model: haiku  # or sonnet/opus
  author: JacobPEvans
  allowed-tools: [list of tools]
  ---
  ```

- **Rules**: No frontmatter required

**Naming conventions**:

- Skills: `noun-verb` (e.g., `permission-patterns`, `worktree-management`)
- Agents: `noun-doer` (e.g., `permissions-analyzer`, `code-reviewer`)
- Commands: `verb-noun` (e.g., `init-worktree`, `sync-main`)

**Descriptions**: Follow verb/noun patterns matching entity names - describe what the entity
does. For skills use noun phrases; for agents/commands use verb phrases.

### Cross-Referencing

Within commands/agents/skills/rules: Reference by name only (e.g., "the github-cli-patterns skill"). Claude has all names loaded - links waste tokens.

In `docs/` and all files outside `agentsmd/`: Use normal markdown links.

## Git Workflow Patterns

Universal patterns for git worktree and branch management. Commands reference these patterns to avoid duplication.

### Worktree Structure

Repository structure follows this pattern:

```text
~/git/<repo-name>/
├── .git/                    # Shared git directory (bare repo)
├── main/                    # Main branch worktree
├── feat/<branch-name>/      # Feature worktrees (e.g., feat/add-dark-mode/)
└── fix/<branch-name>/       # Fix worktrees (e.g., fix/login-bug/)
```

**Key points**:

- Main worktree is always at `~/git/<repo>/main/`
- Branch names use conventional format with slashes (e.g., `feat/add-dark-mode`)
- Worktree paths mirror branch names exactly (no sanitization)

### Branch Naming

Follows [Conventional Branch](https://conventional-branch.github.io/) standard:

- **Format**: `<type>/<description>`
- **Types**: `feat/`, `fix/`, `docs/`, `refactor/`, `test/`, `chore/`, `hotfix/`
- **Rules**: lowercase, hyphens separate words, alphanumeric + hyphens only
- **Examples**:
  - "add dark mode" → `feat/add-dark-mode`
  - "fix login bug" → `fix/login-bug`
  - "update readme" → `docs/update-readme`

### Worktree Lifecycle

1. **Create**: `git worktree add ~/git/<repo>/<branch> -b <branch> main`
2. **Switch**: `cd ~/git/<repo>/<branch>`
3. **Work**: Make changes, commit
4. **Cleanup**: Remove merged/deleted branches, run `git worktree prune`

### Main Branch Synchronization

Always sync main before creating worktrees:

1. Switch to main: `cd ~/git/<repo>/main && git switch main`
2. Fetch: `git fetch --all --prune`
3. Pull: `git pull`
4. Return: `cd -`

Main worktree is always located at `~/git/<repo>/main/` - no search required.

### Stale Worktree Detection

Worktrees are stale when:

- **Branch merged**: `git branch --merged main | grep "^  $BRANCH$"`
- **Remote deleted**: `git branch -vv | grep "\[gone\]"`
- **Cleanup**: `git worktree remove <path>` + `git branch -d <branch>` + `git worktree prune`

### PR Creation Pattern

- **Title format**: `<type>: <description>` (e.g., "feat: add dark mode")
- **Body structure**: Summary bullets + test plan + related issues
- **Draft mode**: Use for WIP, convert to ready when tests pass
- **Merge gates**: 50-comment limit enforced, all review threads must be resolved

## Architecture

Commands, sub-agents, and skills follow a **three-tier architecture** for maintainability:

- **Commands** (`agentsmd/commands/`) - Orchestrate user-facing workflows
- **Sub-Agents** (`.claude/agents/`) - Execute specialized tasks
- **Skills** (`agentsmd/skills/`) - Canonical patterns referenced by commands and agents

See [Command-Agent-Skill Architecture](./agentsmd/rules/command-agent-skill-architecture.md) for the complete pattern.

## Cross-Referencing Convention

**Within commands, agents, skills, and rules**: Reference by name only (e.g., "the github-cli-patterns skill").
Claude has all names loaded at startup - file links waste tokens.

**In docs, workflows, and other files**: Use normal markdown links. These aren't Claude Code features.

## Commands

All commands from `agentsmd/commands/` are available. Use this table to select the right one:

| Intent | Command | Scope | Notes |
| --- | --- | --- | --- |
| Start new development | `/init-worktree` | Repo | Always first for new work |
| Sync permissions across repos | `/sync-permissions` | Repo | Merge local settings to repo permissions |
| Sync current branch with main | `/sync-main` | Branch | Update main, merge into current |
| Sync all PRs with main | `/sync-main all` | Repo | Update main, merge into all open PRs |
| Fix current PR CI failures | `/fix-pr-ci` | Single PR | Fix CI on current PR |
| Fix all PR CI failures | `/fix-pr-ci all` | Repo | Fix CI across all PRs (batches of 5) |
| Sync repo, merge PRs | `/git-refresh` | Repo | Also cleans worktrees |
| Create a GitHub issue | `/shape-issues` | Repo | Shape before creating |
| Implement an issue | `/resolve-issues` | Repo | For shaped issues |
| Review a PR | `/review-pr` | Single PR | Systematic review |
| Resolve PR review feedback | `/resolve-pr-review-thread` | Single PR | After review comments |
| Resolve all PR review threads | `/resolve-pr-review-thread all` | Repo | Address comments on all PRs |
| Manage your own PR | `/manage-pr` | Single PR | PR author workflow |
| Review documentation | `/review-docs` | Repo | Markdown validation |

**PR Comment Limit**: All PR-related commands respect a **50-comment limit per PR** to prevent infinite review cycles.
See [PR Comment Limits rule](./agentsmd/rules/pr-comment-limits.md) for details.
When a PR reaches 50 comments, all future comments are automatically resolved.

## Related Files

- `agentsmd/rules/` - Standards and guidelines
- `agentsmd/workflows/` - 5-step development workflow
- `agentsmd/commands/` - Slash command definitions
- `agentsmd/docs/` - Setup documentation
- `.claude/`, `.gemini/`, `.copilot/` - Vendor configs (symlinked)
