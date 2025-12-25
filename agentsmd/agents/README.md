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
@.claude/agents/review/code-reviewer.md
Please review the authentication module for security issues.
```

### From Slash Commands

Slash commands can delegate to sub-agents:

```markdown
## Step 2: Code Review

Invoke the code-reviewer sub-agent:
@.claude/agents/review/code-reviewer.md

Focus areas:
- Security validation
- Error handling
```

### From Other Sub-Agents

Sub-agents can invoke other sub-agents for specialized tasks:

```markdown
For infrastructure concerns, delegate to:
@.claude/agents/review/infrastructure-reviewer.md
```

## Available Sub-Agents

### Review Sub-Agents

Located in `.claude/agents/review/`:

- **code-reviewer.md**: Comprehensive code review with security, quality, and maintainability checks
- **docs-reviewer.md**: Documentation validation including markdownlint compliance and link checking
- **infrastructure-reviewer.md**: Infrastructure as Code (Terraform/Terragrunt) security and cost review

### PR Management Sub-Agents

Located in `.claude/agents/pr/`:

- **ci-fixer.md**: Analyzes and fixes CI failures in pull requests without bypassing checks
- **thread-resolver.md**: Resolves PR review threads through implementation or explanation with GraphQL resolution

### Issue Management Sub-Agents

Located in `.claude/agents/issue/`:

- **issue-resolver.md**: Analyzes GitHub issue requirements, implements solutions, and creates comprehensive tests

### Code Generation Sub-Agents

Located in `.claude/agents/code/`:

- **code-generator.md**: Generates high-quality, maintainable, and secure code following project standards

### Utility Sub-Agents

Located in `.claude/agents/util/`:

- **worktree-manager.md**: Manages git worktrees including creation, cleanup of stale worktrees, and synchronization
- **test-runner.md**: Executes test suites, analyzes failures, and suggests fixes across multiple test frameworks
- **linter-fixer.md**: Runs linters and automatically fixes code quality issues without bypassing checks
- **dependency-checker.md**: Checks for outdated dependencies and security vulnerabilities across multiple ecosystems

## Creating New Sub-Agents

Sub-agents follow this format:

```markdown
---
name: my-sub-agent
description: Brief description of what this sub-agent does
author: YourName
allowed-tools: Task, TaskOutput, Bash(git status:*), Read(**)
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
├── README.md                          # This file
├── review/                            # Review-focused sub-agents
│   ├── code-reviewer.md
│   ├── docs-reviewer.md
│   └── infrastructure-reviewer.md
├── pr/                                # PR management sub-agents
│   ├── ci-fixer.md
│   └── thread-resolver.md
├── issue/                             # Issue management sub-agents
│   └── issue-resolver.md
├── code/                              # Code generation sub-agents
│   └── code-generator.md
├── util/                              # Utility sub-agents
│   ├── worktree-manager.md
│   ├── test-runner.md
│   ├── linter-fixer.md
│   └── dependency-checker.md
└── [future categories]/               # Additional sub-agent categories
```

## Related Documentation

- [Slash Commands](../commands/) - User-facing workflow commands
- [Rules](../rules/) - Project standards and guidelines
- [Workflows](../workflows/) - Multi-step development processes
