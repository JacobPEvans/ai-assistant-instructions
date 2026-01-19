# AI Agents Configuration

Multi-model AI orchestration configuration for Claude, Gemini, Copilot, and local models.

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

### Model Selection for Subagents

Consider using Haiku or Sonnet when a task doesn't need Opus-level reasoning.

### Parallel Execution

When launching multiple subagents, send them in a single message to run in parallel.
Don't wait for one to complete before starting the next unless there's a true dependency.

### Context Preservation

Your context window is limited. Every file you read directly, every search result you process inline, consumes space
that could be used for reasoning. Subagents return only what matters—summaries, findings, and recommendations.

When you notice a task will be token-heavy (reading many files, extensive exploration, verification across multiple
locations), delegate it. The subagent does the heavy lifting and reports back concisely.

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

## Secrets & Sensitive Data Policy

**CRITICAL**: Never commit sensitive data to git. All git-committed files must use scrubbed values and variable references.

### What NOT to Commit

❌ API tokens, credentials, passwords
❌ Real IP addresses (internal or external)
❌ Real domain names or hostnames
❌ SSH private keys or certificates
❌ Database credentials
❌ AWS account IDs, ARNs, or API keys
❌ Encryption keys or secrets

### Scrubbed Values for Git-Committed Files

Use these placeholders consistently across all repositories:

| Type | Scrubbed Value | Examples |
|------|---|---|
| IPv4 Address | `192.168.0.*` | `192.168.0.1`, `192.168.0.100` (last octet can be accurate) |
| External Domain | `example.com` | For external/public services and APIs |
| Internal Domain | `example.local` | For internal/LAN hostnames and services |
| API Endpoint | `https://api.example.com:8006/api2/json` | Use scrubbed domain pattern |
| Username | `terraform`, `admin`, `user` | Generic role-based names |
| Tokens/Keys | `your-token-here` or `<token>` | Clearly marked as placeholder |

### Variable References in Git-Committed Code

Always use variable indirection for sensitive values in code committed to any branch:

```hcl
# ✅ CORRECT - References variables
provider "proxmox" {
  pm_api_url      = var.proxmox_api_endpoint
  pm_api_token_id = var.proxmox_api_token
  pm_user         = var.proxmox_username
}

# ❌ WRONG - Hardcoded real values
provider "proxmox" {
  pm_api_url      = "https://192.168.1.52:8006/api2/json"
  pm_api_token_id = "terraform@pam!abc123xyz="
  pm_user         = "terraform@pam"
}
```

### Runtime Secret Injection

**AI/Claude Projects:**
API keys retrieved at runtime from macOS Keychain (`ai-secrets` keychain).
Keys are NEVER stored in files or environment variables.

**Infrastructure Projects:**
Inject secrets at runtime via secure channels:

- **Doppler**: Centralized secret management with `doppler run --name-transformer tf-var`
- **Environment Variables**: CI/CD secrets or local .env (never committed)
- **AWS Secrets Manager / Parameter Store**: For AWS deployments
- **SSH Agent**: For private keys (agent forwarding only, never commit keys)
- **HashiCorp Vault**: For large organizations with compliance needs

See the `.docs/` folder at the repository root (not in worktrees) for project-specific implementation patterns.

### Documentation & Configuration Examples

```yaml
# ✅ GOOD - Scrubbed values with variable references
services:
  database:
    host: db.example.local
    port: 5432
    username: postgres
    password: ${DATABASE_PASSWORD}

  api:
    endpoint: https://api.example.com:8080
    token: ${API_TOKEN}

# ❌ BAD - Real values and hardcoded secrets
services:
  database:
    host: db-prod.company.internal
    port: 5432
    username: postgres
    password: SuperSecure!Pass123

  api:
    endpoint: https://api.prod.aws.amazon.com
    token: <actual-jwt-token-value>
```

### Pre-Commit Safety

GitHub secret scanning and branch protection help, but **personal responsibility is critical**:

- Review all diffs before committing
- Never copy-paste real credentials into code
- Use IDE plugins that highlight secrets
- If you accidentally commit secrets, revoke them immediately

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

Context tokens are limited. Beyond delegating to subagents, follow these principles:

### File Authoring

- Target 500 tokens per file (1,000 max)
- CLAUDE.md additions: bare minimum—link to rules/skills for details
- Single-purpose design: each skill/agent/rule does one thing

### DRY Principle

Define once, reference everywhere. Never duplicate patterns, thresholds, or explanations across files.

### Loading Strategy

Skills and agents load on-demand when invoked. Keep startup footprint minimal.

### Best Practices

**Frontmatter** (required, varies by type):

- **Skills**:

  ```yaml
  ---
  name: skill-name
  description: Pattern description
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

**Naming**: Skills use `noun-pattern`, agents use `noun-doer`, commands use `verb-noun`.

### Cross-Referencing

Within agentsmd files: reference by name only (e.g., "the github-cli-patterns skill").
In docs and external files: use normal markdown links.

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
- **Issue linking**: Use `Closes #<issue>` (features), `Fixes #<issue>` (bugs) for auto-closure
- **Bidirectional link**: After PR creation, run `gh issue comment <issue> --body "PR: #<pr>"`
- **Draft mode**: Use for WIP, convert to ready when tests pass
- **Merge gates**: 50-comment limit enforced, all review threads must be resolved

## Language Selection

**Prefer Python/Go over shell scripts.** Shell only for simple wrappers (<5 lines).

**Why**: Better error handling, testability, security (no injection/quoting issues), cross-platform portability.

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
| Fix all PR CI failures | `/fix-pr-ci all` | Repo | Fix CI across all PRs in parallel |
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
