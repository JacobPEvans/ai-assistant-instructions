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

Invoke `superpowers:dispatching-parallel-agents` when facing 2+ independent tasks. It covers identification, dispatch, and integration patterns.

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
3. **Personal/Custom** - Only when no alternative exists

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
❌ User-specific absolute paths

### Scrubbed Values for Git-Committed Files

Use these placeholders consistently across all repositories:

| Type | Scrubbed Value | Examples |
| --- | --- | --- |
| IPv4 Address | `192.168.0.*` | `192.168.0.1`, `192.168.0.100` (last octet can be accurate) |
| IPv6 Address | `2001:db8::*` | `2001:db8::1` (documentation prefix) |
| External Domain | `example.com` | For external/public services and APIs |
| Internal Domain | `example.local` | For internal/LAN hostnames and services |
| API Endpoint | `https://api.example.com:8006/api2/json` | Use scrubbed domain pattern |
| Username | `terraform`, `admin`, `user` | Generic role-based names |
| Tokens/Keys | `your-token-here` or `<token>` | Clearly marked as placeholder |

### Portable Path References

**NEVER commit absolute user paths in git-tracked files.** This includes `/Users/{username}/*`, `/home/{username}/*`, `$HOME/*`, and `~/*` patterns. Use these alternatives:

| Bad (User-Specific) | Good (Portable) | Use Case |
| --- | --- | --- |
| `/Users/john/.local/bin/tool` | `tool` | Use PATH lookup for system commands |
| `entry: /Users/john/.local/bin/ansible-lint` | `entry: ansible-lint` | Pre-commit hooks, scripts |
| `~/.ssh/id_rsa` | Placeholder comment (e.g., `# /path/to/your/ssh/key`) | Example files, templates |
| `$HOME/git/nix-config/main` | `${NIX_CONFIG_PATH}/main` (env var) | Configurable paths in scripts |
| `/home/user/project/file.txt` | `./file.txt` or `../file.txt` | Relative paths within project |

**When to use environment variables:**

- Scripts that reference external projects
- Tool paths that vary by installation
- Any path outside the current repository

**When to use relative paths:**

- Files within the same repository
- Cross-references between project files

**When to comment out with placeholders:**

- Example configuration files (`.example` suffix)
- Template files that users copy and customize

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
API keys are retrieved at runtime from macOS Keychain (`ai-secrets` keychain).
Keys are NEVER stored in files or environment variables.

**Infrastructure Projects:**
Inject secrets at runtime via secure channels:

- **Doppler**: Centralized secret management with `doppler run --name-transformer tf-var`
- **SOPS + age**: Encrypt secrets at rest in git (see the sops-integration rule)
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
    endpoint: https://api.example.com
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

**Naming**: Skills use `noun-pattern`, agents use `noun-doer`.

### Cross-Referencing

Within agentsmd files: reference by name only (e.g., "the github-cli-patterns skill").
In docs and external files: use normal markdown links.

## Git Workflow Patterns

Universal patterns for git worktree and branch management. Commands reference these patterns to avoid duplication.

### Worktree Structure

All repositories live under `~/git/`. Each repository follows this exact structure:

```text
~/git/<repo-name>/
├── .git/                    # Shared git directory (bare repo)
├── .docs/                   # Project-specific docs (secrets, setup, architecture)
├── AGENTS.md                # Project-specific AI instructions (may contain sensitive info)
├── main/                    # Main branch worktree (always present)
├── feat/<feature-name>/     # Feature worktrees (e.g., feat/add-dark-mode/)
├── fix/<bug-name>/          # Bug fix worktrees (e.g., fix/login-timeout/)
├── docs/<doc-name>/         # Documentation worktrees
├── refactor/<name>/         # Refactoring worktrees
├── test/<name>/             # Test worktrees
├── chore/<name>/            # Chore worktrees
└── hotfix/<name>/           # Hotfix worktrees
```

**Key points**:

- All repos at `~/git/<repo-name>/` (not nested deeper)
- `.docs/` folder at repo root contains project-specific documentation (not in worktrees)
- Main worktree always at `~/git/<repo>/main/`
- Worktree paths mirror branch names exactly: `feat/add-dark-mode` → `~/git/<repo>/feat/add-dark-mode/`
- Never work directly in the bare repo root—always use a worktree

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
- **Merge gates**: All review threads must be resolved

## Language Selection

**Prefer Python/Go over shell scripts.** Shell only for simple wrappers (<5 lines).

**Why**: Better error handling, testability, security (no injection/quoting issues), cross-platform portability.

## Architecture

Skills and sub-agents follow a **two-tier architecture**:

- **Sub-Agents** (`.claude/agents/`) - Execute specialized tasks
- **Skills** (`agentsmd/skills/`) - Canonical patterns referenced by agents

Skills in plugins auto-create slash commands. No separate command files needed.

See [Command-Agent-Skill Architecture](./agentsmd/rules/command-agent-skill-architecture.md) for the complete pattern.

## Cross-Referencing Convention

**Within commands, agents, skills, and rules**: Reference by name only (e.g., "the github-cli-patterns skill").
Claude has all names loaded at startup - file links waste tokens.

**In docs, workflows, and other files**: Use normal markdown links. These aren't Claude Code features.

## Available Skills & Tools

Use this section to find the right tool for your task:

### Plugin Slash Commands

External plugins that auto-create slash commands:

| Intent | Command | Plugin Source | Notes |
| --- | --- | --- | --- |
| Start new development | `/init-worktree` | `git-workflows@jacobpevans-cc-plugins` | Always first for new work |
| Sync branch with main | `/sync-main` | `git-workflows@jacobpevans-cc-plugins` | Update main, merge into current |
| Sync repo, cleanup worktrees | `/refresh-repo` | `git-workflows@jacobpevans-cc-plugins` | Also merges PRs |
| Rebase + merge PR | `/rebase-pr` | `git-workflows@jacobpevans-cc-plugins` | Local rebase-merge workflow |
| Squash + merge PR | `/squash-merge-pr` | `git-workflows@jacobpevans-cc-plugins` | Squash-merge workflow |
| Troubleshoot rebase | `/troubleshoot-rebase` | `git-workflows@jacobpevans-cc-plugins` | Recover from failed rebases |
| Troubleshoot worktrees | `/troubleshoot-worktree` | `git-workflows@jacobpevans-cc-plugins` | Fix worktree/branch/refname |
| Troubleshoot pre-commit | `/troubleshoot-precommit` | `git-workflows@jacobpevans-cc-plugins` | Fix pre-commit hook failures |
| Manage your PR | `/finalize-pr` | `github-workflows@jacobpevans-cc-plugins` | PR author workflow |
| Finalize PRs across repos | `/finalize-prs` | `github-workflows@jacobpevans-cc-plugins` | Multi-repo merge readiness |
| Create GitHub issues | `/shape-issues` | `github-workflows@jacobpevans-cc-plugins` | Shape before creating |
| Resolve PR review threads | `/resolve-pr-threads` | `github-workflows@jacobpevans-cc-plugins` | Systematic thread resolution |
| Resolve CodeQL alerts | `/resolve-codeql` | `codeql-resolver@jacobpevans-cc-plugins` | Analyze and fix CodeQL alerts |
| Autonomous maintenance | `/auto-maintain` | `ai-delegation@jacobpevans-cc-plugins` | Continuously finds work |
| Delegate to AI models | `/delegate-to-ai` | `ai-delegation@jacobpevans-cc-plugins` | External AI via PAL MCP |
| Sync permissions | `/sync-permissions` | `config-management@jacobpevans-cc-plugins` | Merge local to repo permissions |
| Add tool permissions | `/quick-add-permission` | `config-management@jacobpevans-cc-plugins` | Quick always-allow setup |
| Orchestrate infrastructure | `/orchestrate-infra` | `infra-orchestration@jacobpevans-cc-plugins` | Cross-repo terraform+ansible |
| Sync terraform inventory | `/sync-inventory` | `infra-orchestration@jacobpevans-cc-plugins` | Distribute terraform outputs |
| E2E pipeline test | `/test-e2e` | `infra-orchestration@jacobpevans-cc-plugins` | Validate full stack |

### Hook-Only Plugins

Plugins that provide hooks (no slash commands):

| Plugin | Source | Purpose |
| --- | --- | --- |
| `git-guards` | `git-guards@jacobpevans-cc-plugins` | Pre-commit guards for git operations |
| `content-guards` | `content-guards@jacobpevans-cc-plugins` | Content validation hooks |

### Superpowers Skills

Skills from the official `superpowers` plugin. Use via Skill tool or slash commands:

| Intent | Skill | Notes |
| --- | --- | --- |
| Receive code review feedback | `superpowers:receiving-code-review` | After review comments received |
| Request code review | `superpowers:requesting-code-review` | Before merge, after work complete |
| Verify work completion | `superpowers:verification-before-completion` | Before claiming "done" |
| TDD workflow | `superpowers:test-driven-development` | For features/bugfixes |
| Debug systematically | `superpowers:systematic-debugging` | For bugs/failures |
| Finalize development branch | `superpowers:finishing-a-development-branch` | All tests pass, ready for review |
| Brainstorm solutions | `superpowers:brainstorming` | Before creating features |
| Write implementation plans | `superpowers:writing-plans` | Multi-step task planning |
| Execute plans | `superpowers:executing-plans` | Run plans in separate context |
| Dispatch parallel agents | `superpowers:dispatching-parallel-agents` | 2+ independent tasks |
| Find superpowers | `superpowers:using-superpowers` | Discover available superpowers |
| Multi-agent development | `superpowers:subagent-driven-development` | Execute plans with agents |
| Create/edit skills | `superpowers:writing-skills` | Skill development |
| Use git worktrees | `superpowers:using-git-worktrees` | Feature isolation |
| Interactive CLI tools | `superpowers:using-tmux-for-interactive-commands` | vim, git rebase -i, etc. |

### Official Plugins & Task Agents

| Intent | Name | Type | Source | Notes |
| --- | --- | --- | --- | --- |
| Review a PR | `pr-review-toolkit` | plugin | `claude-plugins-official` | Multi-agent PR review |
| Review code | `code-reviewer` | Task agent | Repo (`.claude/agents/code-reviewer.md`) | Confidence-scored review |
| Resolve PR threads | `pr-thread-resolver` | Task agent | Repo (`.claude/agents/pr-thread-resolver.md`) | After review comments |
| Fix CI failures | `ci-fixer` | Task agent | Repo (`.claude/agents/ci-fixer.md`) | Fix CI on PRs |
| Implement issues | `issue-resolver` | Task agent | Repo (`.claude/agents/issue-resolver.md`) | For shaped issues |
| Review documentation | `docs-reviewer` | Task agent | Repo (`.claude/agents/docs-reviewer.md`) | Markdown validation |

## Related Files

- `agentsmd/rules/` - Standards and guidelines
- `agentsmd/workflows/` - 5-step development workflow
- `agentsmd/docs/` - Setup documentation
- `.claude/`, `.gemini/`, `.copilot/` - Vendor configs (symlinked)
