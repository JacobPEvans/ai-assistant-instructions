---
description: Delegate tasks to external AI models via PAL MCP tools
model: haiku
author: JacobPEvans
allowed-tools: Task, TaskOutput
---

# Delegate to External AI

Routes tasks to specialized models based on task type and constraints using PAL MCP tools.

## When to Delegate

Delegate when Claude is not the best tool:

- **Large context** (1M+ tokens) → Gemini 3 Pro via PAL `chat` tool
- **Math/reasoning** → DeepSeek R1 via PAL `chat` tool
- **Private/offline** → Local Ollama via PAL `chat` tool
- **Code review consensus** → Multi-model via PAL `consensus` tool
- **Architecture planning** → Claude Opus or Gemini via PAL `planner` tool

## PAL MCP Tools

Your project has **PAL MCP** configured for multi-model orchestration. See CLAUDE.md for:

- **`chat`** - Single model for straightforward tasks
- **`clink`** - Parallel queries across multiple models
- **`consensus`** - Multi-model agreement for critical decisions
- **`codereview`** - Structured code review with multiple perspectives
- **`planner`** - Architecture and design planning
- **`precommit`** - Quick validation before committing

## Workflow

1. **Identify task type** (research, coding, review, architecture, planning)
2. **Select PAL MCP tool** based on type and constraints
3. **Execute via Task tool** with appropriate agent subtype
4. **Synthesize results** if using multi-model tools

## Example

```bash
# Get research consensus across multiple models
# (Use Task tool with subagent_type=researcher)
/delegate-to-ai --task-type=research --multi-model

# Cost-sensitive coding task (use local Ollama)
# (Set AI_ORCHESTRATION_LOCAL_ONLY=true in environment)
/delegate-to-ai --task-type=coding --local-only
```

## References

- CLAUDE.md - Model routing rules and PAL MCP setup
- AGENTS.md - Subagent types and capabilities
- worktrees rule - Session isolation for delegated work
