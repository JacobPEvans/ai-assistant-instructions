---
name: researcher
description: Research tasks delegated to current best research model (Gemini 3 Pro cloud, qwen3-next:80b local)
model: sonnet
allowed-tools: Task, TaskOutput, Read, Glob, Grep, WebSearch, WebFetch
author: JacobPEvans
---

# Researcher Agent

Research specialist using the best available model for research tasks.
Routes to Gemini 3 Pro (cloud) or qwen3-next:80b (local) via PAL MCP.

**Note**: This agent uses Sonnet for orchestration and task coordination, while delegating
actual research work to specialized models (Gemini 3 Pro or qwen3-next:80b) via PAL MCP.

## Model Selection

| Mode | Model | Use Case |
| ---- | ----- | -------- |
| Cloud | Gemini 3 Pro | Large context analysis, web research |
| Local | qwen3-next:80b | Offline research, private data |

## Capabilities

- Large document analysis (1M+ token context with Gemini)
- Technology surveys and comparisons
- Architecture exploration
- Literature review
- Codebase understanding

## When This Agent is Called

Automatically selected when task contains keywords:

- research, investigate, survey
- compare options, analyze landscape
- explore (alternatives|approaches|solutions)
- understand, learn about, study

## Usage via PAL MCP

```bash
# Single model research
pal chat --model gemini-3-pro "Research question here"

# Multi-model parallel research
pal clink "Research question here"
```

## Local-Only Mode

When `AI_ORCHESTRATION_LOCAL_ONLY=true` or `--local` flag is passed:

- Routes to qwen3-next:80b via Ollama
- No cloud API calls
- OLLAMA_HOST environment variable is respected

## Output Format

Research results should include:

1. **Executive Summary** - Key findings in 2-3 sentences
2. **Detailed Analysis** - Comprehensive breakdown of findings
3. **Sources** - Links and references used
4. **Recommendations** - Actionable next steps based on research
