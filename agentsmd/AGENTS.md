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

## Core Principles

- **Accuracy and Truth**: Prioritize correctness over pleasing the user
- **Idempotency**: Operations should be repeatable with consistent results
- **Best Practices**: Follow industry and project-specific standards
- **Clarity**: Ask for clarification when requests are ambiguous
- **No Sycophancy**: Provide correct advice, not validation of bad ideas

## Commands

All commands from `agentsmd/commands/` are available. Key commands:

- `/ai-go` - One-click autonomous operation (triggers full orchestration)
- `/init-worktree` - Initialize clean workspace for development
- `/pull-request` - Full PR lifecycle management
- `/git-refresh` - Sync repo and cleanup worktrees

## Related Files

- `rules/` - Concepts and standards (renamed from concepts/)
- `workflows/` - Development workflow definitions
- `docs/` - Documentation including keychain setup
- `.claude/` - Claude Code configuration (symlinked)
- `.gemini/` - Gemini CLI configuration (symlinked)
- `.copilot/` - GitHub Copilot configuration (symlinked)
