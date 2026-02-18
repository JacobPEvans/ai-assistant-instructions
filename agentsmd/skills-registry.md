# Skills & Tools Registry

Use this registry to find the right tool for your task.

## Plugin Slash Commands

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

## Hook-Only Plugins

Plugins that provide hooks (no slash commands):

| Plugin | Source | Purpose |
| --- | --- | --- |
| `git-guards` | `git-guards@jacobpevans-cc-plugins` | Pre-commit guards for git operations |
| `content-guards` | `content-guards@jacobpevans-cc-plugins` | Content validation hooks |

## Superpowers Skills

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

## Official Plugins & Task Agents

| Intent | Name | Type | Source | Notes |
| --- | --- | --- | --- | --- |
| Review a PR | `pr-review-toolkit` | plugin | `claude-plugins-official` | Multi-agent PR review |
| Review code | `code-reviewer` | Task agent | Repo (`.claude/agents/code-reviewer.md`) | Confidence-scored review |
| Resolve PR threads | `pr-thread-resolver` | Task agent | Repo (`.claude/agents/pr-thread-resolver.md`) | After review comments |
| Fix CI failures | `ci-fixer` | Task agent | Repo (`.claude/agents/ci-fixer.md`) | Fix CI on PRs |
| Implement issues | `issue-resolver` | Task agent | Repo (`.claude/agents/issue-resolver.md`) | For shaped issues |
| Review documentation | `docs-reviewer` | Task agent | Repo (`.claude/agents/docs-reviewer.md`) | Markdown validation |
