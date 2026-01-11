---
name: agents
description: Directory of Claude sub-agents for specialized task execution
---

# Claude Sub-Agents

Sub-agents are specialized, reusable AI assistants that can be invoked by slash commands or other sub-agents to perform focused tasks.
They provide modular capabilities that can be composed together for complex workflows.

> **Note:** Per [Claude Code docs](https://code.claude.com/docs/en/sub-agents), the folder is named `agents/` but we refer to them as "sub-agents" in documentation.

## What Are Sub-Agents?

Sub-agents are markdown-based configurations that define:

- A specific role or responsibility
- Specialized capabilities and knowledge
- Input/output formats
- Working constraints

Unlike slash commands (which orchestrate workflows), sub-agents are workers that perform focused tasks when invoked.

## Sub-Agents vs Slash Commands

| Aspect | Slash Commands | Sub-Agents |
| --- | --- | --- |
| **Purpose** | Orchestrate workflows | Perform focused tasks |
| **Invocation** | User-initiated | Command or agent-initiated |
| **Scope** | Multi-step processes | Single responsibility |
| **Reusability** | Task-specific | Highly reusable |
| **Composition** | Can invoke sub-agents | Can be composed together |

## How to Use Sub-Agents

### Direct Invocation

You can reference a sub-agent in your prompt to Claude:

```text
@.claude/agents/code-reviewer.md
Please review the authentication module for security issues.
```

### From Slash Commands

Slash commands can delegate to sub-agents:

```markdown
## Step 2: Code Review

Invoke the code-reviewer sub-agent:
@.claude/agents/code-reviewer.md

Focus areas:
- Security validation
- Error handling
```

### From Other Sub-Agents

Sub-agents can invoke other sub-agents for specialized tasks:

```markdown
For documentation concerns, delegate to:
@.claude/agents/docs-reviewer.md
```

## Available Sub-Agents

All sub-agents are located directly in `.claude/agents/`:

### Review Sub-Agents

- **code-reviewer.md**: Comprehensive code review with security, quality, and maintainability checks
- **docs-reviewer.md**: Documentation validation including markdownlint compliance and link checking

### PR Management Sub-Agents

- **ci-fixer.md**: Analyzes and fixes CI failures in pull requests without bypassing checks
- **pr-thread-resolver.md**: Resolves PR review threads through implementation or explanation with GraphQL resolution

### Issue Management Sub-Agents

- **issue-resolver.md**: Analyzes GitHub issue requirements, implements solutions, and creates comprehensive tests

### Utility Sub-Agents

- **test-runner.md**: Executes test suites, analyzes failures, and suggests fixes across multiple test frameworks
- **linter-fixer.md**: Runs linters and automatically fixes code quality issues without bypassing checks
- **dependency-checker.md**: Checks for outdated dependencies and security vulnerabilities across multiple ecosystems

### Orchestrator Sub-Agents

These agents support multi-model orchestration and task routing via PAL MCP:

- **researcher.md**: Research tasks using Gemini 3 Pro (cloud) or qwen3-next:80b (local) for large context analysis
- **coder.md**: Coding tasks with automatic tier selection (Opus for complex, Sonnet for standard, local for private)
- **reviewer.md**: Multi-model consensus code review synthesizing perspectives from multiple models
- **planner.md**: Architecture and design specialist using strong reasoning models for system planning

## Creating New Sub-Agents

Sub-agents follow this format:

```markdown
---
name: my-sub-agent
description: Brief description of what this sub-agent does
author: YourName
allowed-tools: Task, TaskOutput, Bash(git status:*)
---

# Sub-Agent Name

## Purpose

Clear statement of this sub-agent's role and responsibility.

## Capabilities

What this sub-agent can do.

## Input Format

What information this sub-agent expects.

## Output Format

How this sub-agent structures its responses.

## Usage Examples

Practical examples of invoking this sub-agent.
```

## Best Practices

1. **Single Responsibility**: Each sub-agent should have one clear purpose
2. **Composability**: Design sub-agents to work together
3. **Clear Interfaces**: Define expected inputs and outputs
4. **Reusability**: Make sub-agents general enough to be reused
5. **Documentation**: Provide usage examples and constraints
6. **Explicit Tools**: Always specify allowed-tools explicitly (never use `*`)

## Directory Structure

```text
.claude/agents/
├── README.md             # This file
├── ci-fixer.md           # PR CI failure fixer
├── code-reviewer.md      # Code review agent
├── coder.md              # Multi-tier coding specialist
├── dependency-checker.md # Dependency security checker
├── docs-reviewer.md      # Documentation reviewer
├── issue-resolver.md     # GitHub issue resolver
├── linter-fixer.md       # Linting fixer
├── planner.md            # Architecture/design specialist
├── researcher.md         # Research specialist
├── reviewer.md           # Multi-model consensus reviewer
├── test-runner.md        # Test execution agent
└── pr-thread-resolver.md # PR thread resolver
```

## Related Documentation

- commands directory - User-facing workflow commands
- rules directory - Project standards and guidelines
- workflows directory - Multi-step development processes
