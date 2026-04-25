---
description: Bifrost AI gateway, PAL MCP multi-model tools, and provider quirks — niche routing details, lazy-loaded
paths:
  - "**/.claude/**"
  - "**/.gemini/**"
  - "**/bifrost*"
  - "**/pal*"
  - "flake.nix"
---

# Bifrost & Multi-Model Routing

Detailed conventions for the local AI gateway and multi-model tools.
Loaded only when files in the matching paths are in context.

## Bifrost Gateway

OpenAI-compatible HTTP endpoint at `http://localhost:30080/v1/chat/completions`.
Multi-provider routing fan-out to OpenAI, Gemini, OpenRouter, and local MLX.

**Never hardcode model identifiers** in committed config.
Models change weekly; identifiers rot.
Use task classes (Research, Coding, Review, Pre-commit, etc.)
and resolve to a current model via `listmodels` at call time.

### Local Model Prefix Convention

The `mlx-local/` prefix is a Bifrost-only requirement.
Bifrost expects `provider/model` format,
so local MLX models are addressed as `mlx-local/<huggingface-model-id>`.
PAL MCP's `custom_models.json` and `CUSTOM_MODEL_NAME` are pre-configured with this prefix.

When calling the vllm-mlx server **directly** (port 11434, bypassing Bifrost),
use the bare HuggingFace model id without the `mlx-local/` prefix.

For OpenRouter / cloud models, never add a provider-style prefix yourself —
the gateway handles routing.

## PAL MCP Tools

| Tool | Purpose |
| --- | --- |
| `clink` | Multi-model parallel. Research and exploration. |
| `consensus` | Multi-model agreement. Critical decisions. |

All other PAL tools have native Claude Code equivalents.
See [nix-ai#450](https://github.com/JacobPEvans/nix-ai/issues/450) for the audit matrix.
For single-model calls, use Bifrost directly.

## Local-Only Mode

When `localOnlyMode` is enabled or `--local` flag is passed:

- All tasks route to the MLX inference server (port 11434)
- No cloud API calls are made
- Verify the vllm-mlx LaunchAgent is running before invoking:
  `launchctl list | grep vllm-mlx`

## Priority Order for Tooling Choices

1. **Anthropic Official** — Claude Code plugins, skills, patterns
2. **Bifrost AI Gateway** — Multi-provider routing at `localhost:30080`
3. **PAL MCP** — Only for `clink` / `consensus` multi-model tools
4. **Personal/Custom** — Only when no alternative exists
