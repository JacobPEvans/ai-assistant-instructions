# Subagent Specifications

This directory contains specifications for specialized subagents used in [Autonomous Orchestration](../concepts/autonomous-orchestration.md).

## Subagent Index

| Subagent | Purpose | Model Tier |
|----------|---------|------------|
| [Web Researcher](./web-researcher.md) | Research external information | Medium |
| [Coder](./coder.md) | Implement code changes | Medium |
| [Tester](./tester.md) | Write and execute tests | Medium |
| [Git Handler](./git-handler.md) | Manage git operations | Small |
| [PR Resolver](./pr-resolver.md) | Handle GitHub PR comments | Medium |
| [Doc Reviewer](./doc-reviewer.md) | Validate documentation | Small |
| [Security Auditor](./security-auditor.md) | Security review | Medium |
| [Dependency Manager](./dependency-manager.md) | Manage project dependencies | Small |

## Subagent Contract

Every subagent must adhere to this contract:

### Input Format

```markdown
## Task Assignment

**Task ID**: TASK-XXX
**Objective**: [Clear, specific goal]
**Context Files**: [List of relevant files]
**Constraints**: [What the subagent cannot do]
**Output Format**: [Expected structure of results]
**Timeout**: [Maximum execution time]
```

### Output Format

```markdown
## Task Result

**Task ID**: TASK-XXX
**Status**: success | failure | partial
**Summary**: [Brief description of what was done]
**Files Modified**: [List of files changed]
**Artifacts**: [Any outputs created]
**Errors**: [Any errors encountered]
**Recommendations**: [Suggestions for orchestrator]
```

## Model Tier Guidelines

- **Large**: Reserved for orchestrator only
- **Medium**: Complex reasoning, code generation, research
- **Small**: Simple validation, formatting, quick lookups

## Context Budget

Each subagent has a maximum context budget:

| Tier | Max Context | Typical Use |
|------|-------------|-------------|
| Medium | 15k tokens | Full task context |
| Small | 3k tokens | Minimal, focused context |

## Adding New Subagents

1. Create specification file in this directory
2. Define input/output contract
3. Specify model tier and context budget
4. Document failure modes
5. Update orchestrator to recognize new subagent
