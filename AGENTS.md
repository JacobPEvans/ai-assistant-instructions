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

## Cross-Referencing Convention

**In Claude Code instruction files**: Use `@path/to/file` to compose content inline.
Always prefer `@` over markdown links — referenced content loads automatically without a separate file
read. Reserve markdown links only for "see X if relevant" conditional references where you explicitly
do NOT want content auto-loaded.

**Within agents, skills, and rules**: Reference by name only (e.g., "the code-standards rule").
Rules in `.claude/rules/` auto-load every session. Other files load on demand when referenced.

**In docs and external files**: Use markdown links. These aren't parsed by Claude Code.

## Auto-Loaded Rules

All files in `agentsmd/rules/` auto-load every session via `.claude/rules/ -> ../agentsmd/rules`.
This includes: secrets policy, worktree patterns, branch hygiene, code standards, authoring standards,
architecture, soul/voice guidelines, and more.

@agentsmd/skills-registry.md

## Related Files

- `agentsmd/rules/` - Standards and guidelines (auto-loaded via `.claude/rules/`)
- `agentsmd/workflows/` - 5-step development workflow
- `agentsmd/docs/` - Setup documentation
- `.claude/`, `.gemini/`, `.copilot/` - Vendor configs (symlinked)
