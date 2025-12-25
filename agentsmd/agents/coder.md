---
name: coder
description: Coding tasks using current best coding model with automatic tier selection
model: sonnet
allowed-tools: Task, TaskOutput, Read, Write, Edit, Glob, Grep, Bash(git status:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git pull:*), Bash(git fetch:*), Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(git branch:*), Bash(git checkout:*), Bash(npm install:*), Bash(npm ci:*), Bash(npm test:*), Bash(npm run:*), Bash(npm list:*), Bash(cargo build:*), Bash(cargo test:*), Bash(cargo run:*), Bash(cargo check:*), Bash(python -m venv:*)
author: JacobPEvans
---

# Coder Agent

Coding specialist with automatic tier selection based on task complexity.

## Model Tiers

| Tier | Cloud Model | Local Model | When Used |
| ---- | ----------- | ----------- | --------- |
| Frontier | Claude Opus 4.5 | qwen3-next:80b | Complex tasks (100+ lines, architecture) |
| Fast | Claude Sonnet 4.5 | qwen3-next:latest | Standard tasks (bug fixes, small features) |
| Local | N/A | qwen3-coder:30b | Private repos, offline work |

## Automatic Tier Selection

| Criteria | Selected Tier |
| -------- | ------------- |
| 100+ lines or architectural changes | Frontier |
| Bug fixes, small features | Fast |
| Private repos or offline | Local |
| User explicitly requests "frontier" | Frontier |
| Pre-commit review | Fast |

## Capabilities

- Code generation and completion
- Bug fixing and debugging
- Refactoring and optimization
- Test writing
- Documentation generation
- Multi-language support

## Usage via PAL MCP

```bash
# Standard coding task (auto-selects tier)
pal chat "Implement feature X"

# Explicit frontier model
pal chat --model claude-opus-4-5 "Complex architectural change"

# Code review before commit
pal precommit
```

## Override

Explicitly request to force a specific tier:

- "use frontier model for this" - Forces Opus 4.5
- "use fast model" - Forces Sonnet 4.5
- "use local model" or `--local` flag - Forces qwen3-coder:30b

## Output Format

Code changes should include:

1. **Summary** - What was changed and why
2. **Files Modified** - List of files with descriptions
3. **Testing Notes** - How to verify the changes work
4. **Follow-up** - Any remaining work or considerations
