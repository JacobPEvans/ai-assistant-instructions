# Multi-Model AI Orchestration System

## Executive Summary

Implement a hybrid multi-model orchestration system enabling Claude (or any AI agent) to
automatically delegate tasks to specialized AI models (Gemini, Ollama local models, Copilot)
while acting as the primary orchestrator.

Uses existing tools (PAL MCP Server, LiteLLM, Anthropic Skills) with minimal custom code.
All configuration managed via Nix with proper modularization.

## December 2025 Model Reference

### Latest Frontier Models (as of Dec 2025)

| Model | Strengths | Use Case |
|-------|-----------|----------|
| **Claude Opus 4.5** | SWE-bench leader (80.9%), Terminal-bench (59.3%), 30+ hr autonomous | Orchestration, complex coding |
| **Claude Sonnet 4.5** | Fast coding, cost-effective | Day-to-day development |
| **Gemini 3 Pro** | LMArena Elo leader (1501), 1M token context, IMO gold | Research, reasoning, large docs |
| **GPT-5.2** | ARC-AGI-2 leader (54.2%), AIME 2025 (100%) | Mathematical reasoning |
| **DeepSeek V3.2** | IMO/IOI gold, 10-30x cheaper | Cost-effective complex tasks |
| **Llama 4** | 10M token context, open source, fine-tunable | Local/private, customization |

### Your Current Ollama Models (Audit Needed)

| Model | Size | Status | Recommendation |
|-------|------|--------|----------------|
| `qwen3-next:80b-a3b-instruct-q8_0` | 84 GB | KEEP | Latest Qwen3, excellent |
| `qwen3-next:latest` | 50 GB | KEEP | Good balance |
| `llama4:latest` / `llama4:scout` | 67 GB | KEEP | Current Llama 4 |
| `llama4:17b-scout-16e-instruct-q8_0` | 116 GB | TEST | May be too slow |
| `qwen3-vl:32b-instruct-bf16` | 66 GB | KEEP | Vision model |
| `deepseek-r1:70b-llama-distill-q8_0` | 74 GB | KEEP | Strong reasoning |
| `qwen3-coder:30b-a3b-q8_0` | 32 GB | KEEP | Good coding |
| `gemma3:27b-it-q8_0` | 29 GB | KEEP | Efficient |
| `codegemma:7b-*` | 5-17 GB | REVIEW | May be outdated |
| `gpt-oss:120b` | 65 GB | TEST | May be too slow |
| `gpt-oss:20b` | 13 GB | KEEP | Reasonable size |
| `deepseek-r1:32b-qwen-distill-q4_K_M` | 19 GB | KEEP | Fast reasoning |
| `qwen3-coder:30b` | 18 GB | DUPLICATE | Remove (have a3b version) |
| `llama3.1:70b-instruct-q8_0` | 74 GB | REVIEW | Outdated (have Llama 4) |
| `llama3.3:70b-instruct-q6_K` | 57 GB | REVIEW | Outdated (have Llama 4) |
| `codellama:70b-instruct-q5_K_M` | 48 GB | REVIEW | Outdated |
| `deepseek-coder-v2:16b-lite-base-q8_0` | 16 GB | REVIEW | May be outdated |

### Models to Add When Ollama Updates

```bash
# When available:
ollama pull devstral-2:latest    # Mistral's latest code model (needs newer Ollama)
```

### Model Research Protocol (For Future Updates)

```markdown
## How to Research Latest Models

1. Check official sources first:
   - https://ollama.ai/library (sorted by updated)
   - https://huggingface.co/spaces/lmsys/chatbot-arena-leaderboard
   - https://paperswithcode.com/sota

2. Search pattern: "[model family] latest December 2025"

3. Key metrics to verify:
   - Release date (within 30 days = current)
   - Benchmark scores (MMLU, HumanEval, SWE-bench)
   - Context window size
   - Quantization availability

4. Cross-reference with:
   - Model's official GitHub/blog
   - LMSys Chatbot Arena (live rankings)
   - Vertu/Azumo monthly rankings

5. NEVER assume your training data is current. ALWAYS web search.
```

---

## Architecture Overview

```text
┌─────────────────────────────────────────────────────────────────┐
│              Any AI Agent (Claude/Gemini/Ollama)                │
│  - AGENTS.md routing rules (symlinked to all agents)            │
│  - Hooks for auto-triggering                                    │
│  - Skills for specialized tasks                                 │
│  - Subagents for model-specific delegation                      │
└─────────────────────┬───────────────────────────────────────────┘
                      │
         ┌────────────┼────────────┐
         │            │            │
         ▼            ▼            ▼
┌─────────────┐ ┌──────────┐ ┌──────────────┐
│  PAL MCP    │ │ LiteLLM  │ │  Anthropic   │
│  Server     │ │  Proxy   │ │  Skills      │
│  (Primary)  │ │ (Backup) │ │  (Official)  │
└──────┬──────┘ └────┬─────┘ └──────────────┘
       │             │
       ▼             ▼
┌──────────────────────────────────────┐
│           Model Providers            │
│  ┌─────────────┐ ┌─────────────────┐ │
│  │ Cloud APIs  │ │ Ollama Local    │ │
│  │ (Gemini,    │ │ (qwen3-next,    │ │
│  │  OpenAI)    │ │  deepseek-r1)   │ │
│  └─────────────┘ └─────────────────┘ │
└──────────────────────────────────────┘
```

---

## Workspace Setup

### Directory Structure

```text
~/git/ai-orchestration/           # New worktree root for this project
├── ai-assistant-instructions/    # Worktree: this repo
├── nix-config/                   # Worktree: ~/.config/nix
└── agentsmd/                     # Shared agent instructions (source of truth)
    ├── AGENTS.md                 # Main instructions (symlinked to ~/AGENTS.md)
    ├── rules/                    # Claude-native folder (renamed from concepts)
    ├── workflows/
    ├── commands/
    └── ...

# Symlink targets (all point to agentsmd/):
~/AGENTS.md → ~/git/ai-orchestration/agentsmd/AGENTS.md
~/.claude/ → ~/git/ai-orchestration/agentsmd/.claude/
~/.gemini/ → ~/git/ai-orchestration/agentsmd/.gemini/
~/.github/copilot-instructions.md → ~/git/ai-orchestration/agentsmd/.github/copilot-instructions.md
```

### Worktree Initialization

```bash
# Create orchestration workspace
mkdir -p ~/git/ai-orchestration
cd ~/git/ai-orchestration

# Create worktrees for each repo we modify
git -C ~/git/ai-assistant-instructions worktree add \
  ~/git/ai-orchestration/ai-assistant-instructions -b feat/multi-model-orchestration

git -C ~/.config/nix worktree add \
  ~/git/ai-orchestration/nix-config -b feat/ai-orchestration-module
```

---

## Implementation Phases

### Phase 0: Local Model Benchmarking

**Purpose**: Identify which Ollama models are usable vs too slow, establish baseline performance.

**Files to create:**

- `~/git/ai-orchestration/nix-config/modules/ai-orchestration/benchmark/default.nix`
- `~/git/ai-orchestration/nix-config/modules/ai-orchestration/benchmark/benchmark.py`

**Tasks:**

0.1. Create Python benchmark script (not shell)

```python
#!/usr/bin/env python3
"""Benchmark local Ollama models for token speed and usability."""

import subprocess
import time
import json
from datetime import datetime

MODELS_TO_TEST = [
    "qwen3-next:80b-a3b-instruct-q8_0",
    "qwen3-next:latest",
    "deepseek-r1:70b-llama-distill-q8_0",
    "llama4:latest",
    # ... all installed models
]

TEST_PROMPT = "Write a Python function to calculate fibonacci numbers."
MIN_TOKENS_PER_SEC = 5  # Below this = too slow for interactive use

def benchmark_model(model: str) -> dict:
    """Returns tokens/sec and recommendation."""
    start = time.time()
    result = subprocess.run(
        ["ollama", "run", model, TEST_PROMPT],
        capture_output=True, text=True, timeout=120
    )
    elapsed = time.time() - start
    output_tokens = len(result.stdout.split())
    tps = output_tokens / elapsed if elapsed > 0 else 0

    return {
        "model": model,
        "tokens_per_sec": round(tps, 2),
        "recommendation": "KEEP" if tps >= MIN_TOKENS_PER_SEC else "REMOVE",
        "tested": datetime.now().isoformat()
    }

def main():
    results = [benchmark_model(m) for m in MODELS_TO_TEST]
    print(json.dumps(results, indent=2))

    # Save to file for tracking over time
    with open("~/.config/ai-orchestration/model-benchmarks.json", "w") as f:
        json.dump(results, f, indent=2)

if __name__ == "__main__":
    main()
```

0.2. Create model freshness tracker

```python
"""Track model release dates and flag outdated models."""

MODEL_RELEASE_DATES = {
    "qwen3-next": "2025-12-01",
    "llama4": "2025-11-15",
    "deepseek-r1": "2025-11-20",
    # Updated via web search
}

MAX_AGE_DAYS = 90  # Flag models older than this
```

---

### Phase 1: Nix Module Structure (ai-orchestration)

**Create standalone, importable module - NOT under ai-cli.**

**Files to create:**

- `~/git/ai-orchestration/nix-config/modules/ai-orchestration/default.nix`
- `~/git/ai-orchestration/nix-config/modules/ai-orchestration/pal-mcp/default.nix`
- `~/git/ai-orchestration/nix-config/modules/ai-orchestration/litellm/default.nix`
- `~/git/ai-orchestration/nix-config/modules/ai-orchestration/skills/default.nix`
- `~/git/ai-orchestration/nix-config/modules/ai-orchestration/agents/default.nix`

**Tasks:**

1.1. Create master ai-orchestration module

```nix
# modules/ai-orchestration/default.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.services.ai-orchestration;
in {
  imports = [
    ./pal-mcp
    ./litellm
    ./skills
    ./agents
    ./benchmark
  ];

  options.services.ai-orchestration = {
    enable = lib.mkEnableOption "Multi-model AI orchestration";

    localOnlyMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use only local Ollama models (no cloud APIs)";
    };

    defaultResearchModel = lib.mkOption {
      type = lib.types.str;
      default = "gemini-3-pro";
      description = "Model for research tasks (can be local or cloud)";
    };

    defaultCodingModel = lib.mkOption {
      type = lib.types.str;
      default = "claude-opus-4-5";
      description = "Model for complex coding tasks";
    };

    secretsBackend = lib.mkOption {
      type = lib.types.enum [ "bitwarden" "aws-vault" ];
      default = "bitwarden";
      description = "How to retrieve API keys at runtime";
    };
  };

  config = lib.mkIf cfg.enable {
    # Submodules enabled by default
    services.ai-orchestration.pal-mcp.enable = true;
    services.ai-orchestration.litellm.enable = true;
  };
}
```

1.2. PAL MCP as Nix-managed flake input (not git clone)

```nix
# modules/ai-orchestration/pal-mcp/default.nix
{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.services.ai-orchestration.pal-mcp;
  secretsCmd = if config.services.ai-orchestration.secretsBackend == "bitwarden"
    then "bws secret get"
    else "aws-vault exec default -- printenv";
in {
  options.services.ai-orchestration.pal-mcp = {
    enable = lib.mkEnableOption "PAL MCP Server";
  };

  config = lib.mkIf cfg.enable {
    # PAL MCP pulled via flake input, not git clone
    home.packages = [ inputs.pal-mcp-server.packages.${pkgs.system}.default ];

    # MCP server config - secrets injected at runtime via wrapper
    xdg.configFile."claude/mcp-servers/pal-wrapper.py".text = ''
      #!/usr/bin/env python3
      """Wrapper that injects secrets from ${config.services.ai-orchestration.secretsBackend}."""
      import os
      import subprocess

      # Get secrets at runtime (never stored in files)
      gemini_key = subprocess.check_output(
        ["${secretsCmd}", "GEMINI_API_KEY"], text=True
      ).strip()

      os.environ["GEMINI_API_KEY"] = gemini_key
      os.environ["OLLAMA_HOST"] = "http://localhost:11434"

      # Launch PAL MCP
      os.execvp("pal-mcp-server", ["pal-mcp-server"])
    '';
  };
}
```

1.3. Add PAL MCP flake input to root flake.nix

```nix
# In flake.nix inputs:
inputs.pal-mcp-server = {
  url = "github:BeehiveInnovations/pal-mcp-server";
  flake = false;  # Or true if they have a flake
};
```

1.4. Package definitions within ai-orchestration module

```nix
# modules/ai-orchestration/packages.nix
{ pkgs, ... }:
{
  # All AI orchestration packages defined here, not in common
  packages = with pkgs; [
    python3Packages.litellm
    python3Packages.ollama
    # PAL MCP from flake input
  ];
}
```

---

### Phase 2: Auto-Triggering Infrastructure (Python, not shell)

**Files to create:**

- `~/git/ai-orchestration/agentsmd/hooks/task_router.py`
- `~/git/ai-orchestration/agentsmd/AGENTS.md` (renamed from INSTRUCTIONS.md)

**Tasks:**

2.1. Create Python task router (not shell script)

```python
#!/usr/bin/env python3
"""Route tasks to appropriate models based on content analysis."""

import sys
import json
import re
from typing import Literal

TaskType = Literal["research", "coding", "review", "planning", "local-only"]

# Keywords that trigger specific routing (NOT using 'explore' - Claude skill conflict)
ROUTING_PATTERNS = {
    "research": r"(research|investigate|survey|compare options|analyze landscape)",
    "coding": r"(implement|write code|fix bug|refactor|create function)",
    "review": r"(review|audit|check|validate)",
    "planning": r"(plan|design|architect|roadmap)",
}

def detect_task_type(prompt: str) -> TaskType:
    """Analyze prompt and return recommended task type."""
    prompt_lower = prompt.lower()

    for task_type, pattern in ROUTING_PATTERNS.items():
        if re.search(pattern, prompt_lower):
            return task_type

    return "coding"  # Default

def get_model_recommendation(task_type: TaskType, local_only: bool = False) -> str:
    """Return recommended model for task type."""
    if local_only:
        return {
            "research": "ollama/qwen3-next:80b",
            "coding": "ollama/qwen3-coder:30b",
            "review": "ollama/deepseek-r1:70b",
            "planning": "ollama/qwen3-next:80b",
        }.get(task_type, "ollama/qwen3-next:latest")

    return {
        "research": "gemini-3-pro",  # Current best for research
        "coding": "claude-opus-4-5",  # Current best for coding
        "review": "consensus",  # Multi-model
        "planning": "gemini-3-pro",
    }.get(task_type, "claude-sonnet-4-5")

if __name__ == "__main__":
    prompt = sys.argv[1] if len(sys.argv) > 1 else ""
    local_only = "--local" in sys.argv

    task_type = detect_task_type(prompt)
    model = get_model_recommendation(task_type, local_only)

    print(json.dumps({
        "task_type": task_type,
        "recommended_model": model,
        "local_only": local_only
    }))
```

2.2. Update AGENTS.md with orchestration rules (rename from INSTRUCTIONS.md)

```markdown
# AGENTS.md - Multi-Model Orchestration Rules

## Automatic Task Routing

When encountering these task types, use PAL MCP tools:

| Task Type | Trigger Keywords | Default Model | PAL Tool |
|-----------|------------------|---------------|----------|
| Research | research, investigate, survey | gemini-3-pro | `chat` |
| Code Review | review, audit | consensus | `codereview` |
| Planning | plan, design, architect | gemini-3-pro | `planner` |
| Consensus | compare approaches | multi-model | `consensus` |
| Local/Private | --local flag | ollama/* | `chat` |

## Local-Only Mode

When `AI_ORCHESTRATION_LOCAL_ONLY=true` or `--local` flag:
- All tasks route to local Ollama models
- No cloud API calls
- Use qwen3-next:80b for research, qwen3-coder:30b for coding

## Model Selection (Current Best - Update Monthly)

- **Research/Reasoning**: Gemini 3 Pro (Dec 2025)
- **Complex Coding**: Claude Opus 4.5 (Nov 2025)
- **Fast Coding**: Claude Sonnet 4.5 (Nov 2025)
- **Local Coding**: qwen3-coder:30b
- **Local Research**: qwen3-next:80b
```

2.3. Use existing Anthropic research patterns (not custom /research)

Instead of creating `/research`, configure existing Anthropic skills:

```bash
# Install and use Anthropic's research patterns
claude plugin marketplace add anthropics/skills
# Use built-in research workflows from skills
```

---

### Phase 3: Anthropic Skills Integration (via Nix)

**Files to create:**

- `~/git/ai-orchestration/nix-config/modules/ai-orchestration/skills/default.nix`
- `~/git/ai-orchestration/agentsmd/skills/multi-model-router/SKILL.md`

**Tasks:**

3.1. Install ALL Anthropic plugins via Nix

```nix
# modules/ai-orchestration/skills/default.nix
{ config, lib, pkgs, inputs, ... }:

{
  options.services.ai-orchestration.skills = {
    enable = lib.mkEnableOption "Anthropic Skills and Plugins";
  };

  config = lib.mkIf config.services.ai-orchestration.skills.enable {
    # Register Anthropic marketplaces via Nix
    programs.claude.extraKnownMarketplaces = {
      "anthropics/skills" = {
        source = { type = "git"; url = "https://github.com/anthropics/skills"; };
      };
      "anthropics/claude-plugins-official" = {
        source = { type = "git"; url = "https://github.com/anthropics/claude-plugins-official"; };
      };
    };

    # Enable specific plugins
    programs.claude.enabledPlugins = {
      "document-skills@anthropic-agent-skills" = true;
      "example-skills@anthropic-agent-skills" = true;
    };
  };
}
```

3.2. Create multi-model router skill (generic name, not model-specific)

```yaml
---
name: multi-model-router
description: Routes tasks to optimal model based on task type. Uses current best models.
---

# Multi-Model Router Skill

Routes tasks to the most appropriate model without hardcoding model names.

## Configuration
Model selection defined in: `~/.config/ai-orchestration/model-config.yaml`

## Routing Logic
1. Detect task type from prompt
2. Look up current best model for task type
3. Use PAL MCP to delegate
4. Return synthesized results

## Local-Only Support
Set `AI_ORCHESTRATION_LOCAL_ONLY=true` to use only Ollama models.
```

---

### Phase 4: Generic Subagent Definitions (Not Model-Named)

**Files to create:**

- `~/git/ai-orchestration/agentsmd/agents/researcher.md`
- `~/git/ai-orchestration/agentsmd/agents/coder.md`
- `~/git/ai-orchestration/agentsmd/agents/reviewer.md`

**Tasks:**

4.1. Create generic researcher agent (NOT "gemini-researcher")

```markdown
---
name: researcher
description: Research tasks delegated to current best research model
---

# Researcher Agent

Research specialist using the best available model for research tasks.

## Current Model Selection (Update as needed)
- **Cloud**: Gemini 3 Pro (1M token context, strong reasoning)
- **Local**: qwen3-next:80b (when local-only mode)

## Capabilities
- Large document analysis
- Technology surveys
- Architecture exploration

## Usage
Automatically selected when task contains research keywords.
Model can be overridden via config.
```

4.2. Create generic coder agent with latest model support

```markdown
---
name: coder
description: Coding tasks using current best coding model
---

# Coder Agent

## Model Tiers
- **Complex tasks**: Use current frontier model (Claude Opus 4.5 as of Dec 2025)
- **Standard tasks**: Use fast model (Claude Sonnet 4.5)
- **Local/Private**: Use best local model (qwen3-coder:30b)

## Automatic Tier Selection
- 100+ lines or architectural changes → frontier
- Bug fixes, small features → standard
- Private repos or offline → local

## Override
Explicitly request: "use frontier model for this" to force best available.
```

---

### Phase 5: LiteLLM as Submodule (Not in ai-cli)

**Files to modify:**

- `~/git/ai-orchestration/nix-config/modules/ai-orchestration/litellm/default.nix`

**Tasks:**

5.1. Migrate LiteLLM from ai-cli to ai-orchestration submodule

```nix
# modules/ai-orchestration/litellm/default.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.services.ai-orchestration.litellm;
in {
  options.services.ai-orchestration.litellm = {
    enable = lib.mkEnableOption "LiteLLM proxy (fallback routing)";
  };

  config = lib.mkIf cfg.enable {
    # LiteLLM config with current models
    xdg.configFile."litellm/config.yaml".text = ''
      model_list:
        - model_name: research-model
          litellm_params:
            model: gemini/gemini-3-pro
            # Key injected at runtime via wrapper

        - model_name: coding-model
          litellm_params:
            model: anthropic/claude-opus-4-5-20251101

        - model_name: local-research
          litellm_params:
            model: ollama/qwen3-next:80b
            api_base: http://localhost:11434

        - model_name: local-coding
          litellm_params:
            model: ollama/qwen3-coder:30b
            api_base: http://localhost:11434

      litellm_settings:
        fallback_on_errors:
          - RateLimitError
          - ServiceUnavailableError
    '';
  };
}
```

---

### Phase 6: Autonomous Operation (Python-based)

**Files to create:**

- `~/git/ai-orchestration/agentsmd/workflows/autonomous.py`
- `.github/workflows/claude-autonomous.yml`

**Tasks:**

6.1. Create Python automation script (not shell)

```python
#!/usr/bin/env python3
"""Autonomous operation tasks for scheduled runs."""

import subprocess
from typing import List
from dataclasses import dataclass

@dataclass
class Task:
    name: str
    prompt: str
    allowed_tools: List[str]

SCHEDULED_TASKS = [
    Task(
        name="issue-triage",
        prompt="Review open issues. Research similar solutions, draft responses.",
        allowed_tools=["PAL:*", "Bash(gh:*)"]
    ),
    Task(
        name="pr-review",
        prompt="Review open PRs using multi-model consensus.",
        allowed_tools=["PAL:codereview", "PAL:consensus"]
    ),
    Task(
        name="dependency-check",
        prompt="Check for outdated dependencies and security issues.",
        allowed_tools=["Bash(npm:*)", "Bash(pip:*)"]
    ),
]

def run_task(task: Task):
    """Execute a scheduled task via Claude Code."""
    subprocess.run([
        "claude", "--print", "--dangerously-skip-permissions",
        f"--allowedTools={','.join(task.allowed_tools)}",
        task.prompt
    ])

if __name__ == "__main__":
    import sys
    task_name = sys.argv[1] if len(sys.argv) > 1 else "issue-triage"
    task = next((t for t in SCHEDULED_TASKS if t.name == task_name), SCHEDULED_TASKS[0])
    run_task(task)
```

---

### Phase 7: Rename and Symlink Structure

**Tasks:**

7.1. Rename folders

- `.ai-instructions/concepts/` → `agentsmd/rules/`
- `.ai-instructions/INSTRUCTIONS.md` → `agentsmd/AGENTS.md` (also symlink to repo root)

7.2. Create symlinks from all agent config dirs to agentsmd/

```bash
# All agent configs point to agentsmd/
ln -sf ~/git/ai-orchestration/agentsmd/AGENTS.md ~/AGENTS.md
ln -sf ~/git/ai-orchestration/agentsmd/.claude ~/.claude
ln -sf ~/git/ai-orchestration/agentsmd/.gemini ~/.gemini
# etc.
```

7.3. Update all imports in Nix to use new paths

---

## Critical Files Summary

| File | Purpose |
|------|---------|
| `~/git/ai-orchestration/nix-config/modules/ai-orchestration/default.nix` | Master orchestration module |
| `~/git/ai-orchestration/nix-config/modules/ai-orchestration/pal-mcp/default.nix` | PAL MCP Nix submodule |
| `~/git/ai-orchestration/nix-config/modules/ai-orchestration/litellm/default.nix` | LiteLLM Nix submodule |
| `~/git/ai-orchestration/agentsmd/AGENTS.md` | Main instructions (symlinked everywhere) |
| `~/git/ai-orchestration/agentsmd/hooks/task_router.py` | Python task routing |
| `~/git/ai-orchestration/agentsmd/agents/researcher.md` | Generic researcher agent |
| `~/git/ai-orchestration/agentsmd/agents/coder.md` | Generic coder agent |

## Related Issues to Close

- **#101**: Add subagents/commands to summon external AIs → PAL + skills
- **#96**: Integrate Local Ollama Models → PAL + local-only mode
- **#69**: Pre-commit AI Code Review → PAL `precommit` tool
- **#40**: Consolidate Duplicate AI Commands → Unified orchestration
- **#27**: Split Claude slash commands → Agents created

## New Issue to Create

- **claude-flow Integration**: Evaluate claude-flow swarm orchestration (future)

## Success Criteria

1. Standalone ai-orchestration Nix module (not under ai-cli)
2. All secrets from bws/aws-vault (never env vars or files)
3. Local-only mode works with Ollama
4. Generic agent names (not model-specific)
5. Python for automation (not shell scripts)
6. agentsmd/ as source of truth with symlinks
7. AGENTS.md at repo root
8. Model benchmarking identifies slow/outdated models

## Sources

- [PAL MCP Server](https://github.com/BeehiveInnovations/pal-mcp-server)
- [Anthropic Skills](https://github.com/anthropics/skills)
- [Claude Code Plugins](https://www.anthropic.com/news/claude-code-plugins)
- [LLM Rankings Dec 2025](https://vertu.com/lifestyle/top-8-ai-models-ranked-gemini-3-chatgpt-5-1-grok-4-claude-4-5-more/)
