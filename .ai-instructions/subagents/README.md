# Subagent Specifications

This directory contains specifications for specialized subagents used in [Autonomous Orchestration](../concepts/autonomous-orchestration.md).

## Core Rule: No Clarification Requests

Per [Self-Healing](../concepts/self-healing.md), subagents **NEVER** request clarification. They must:

1. Resolve ambiguity autonomously using the decision hierarchy
2. Document all assumptions with confidence scores
3. Return partial results rather than blocking
4. Queue retry tasks for truly unresolvable issues

## Subagent Index

### Session Management Subagents

These subagents handle cross-session context bridging, inspired by
[Anthropic's research on long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents).

| Subagent | Purpose | Model Tier | User Interactive |
|----------|---------|------------|-----------------|
| [Session Initializer](./session-initializer.md) | First context window setup | Small | No |
| [Context Compactor](./context-compactor.md) | Intelligent context summarization | Medium | No |

### Development Subagents

| Subagent | Purpose | Model Tier | User Interactive |
|----------|---------|------------|-----------------|
| [Coder](./coder.md) | Implement code changes | Medium | No |
| [Tester](./tester.md) | Write and execute tests | Medium | No |
| [QA Validator](./qa-validator.md) | Post-implementation quality assurance | Medium | No |
| [Git Handler](./git-handler.md) | Manage git operations | Small | No |

### Research & Review Subagents

| Subagent | Purpose | Model Tier | User Interactive |
|----------|---------|------------|-----------------|
| [Web Researcher](./web-researcher.md) | Research external information | Small | No |
| [Doc Reviewer](./doc-reviewer.md) | Validate documentation | Small | No |
| [Security Auditor](./security-auditor.md) | Security review | Medium | No |
| [Commit Reviewer](./commit-reviewer.md) | Review commits for quality/security | Medium | No |

### GitHub Integration Subagents

| Subagent | Purpose | Model Tier | User Interactive |
|----------|---------|------------|-----------------|
| [PR Resolver](./pr-resolver.md) | Handle GitHub PR comments | Medium | No |
| [Issue Creator](./issue-creator.md) | Create GitHub issues from user input | Medium | **Yes** |
| [Issue Resolver](./issue-resolver.md) | Autonomously resolve GitHub issues | Medium | No |

### Maintenance Subagents

| Subagent | Purpose | Model Tier | User Interactive |
|----------|---------|------------|-----------------|
| [Dependency Manager](./dependency-manager.md) | Manage project dependencies | Small | No |

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

## Timeout Budgets

Every subagent has a maximum execution time:

| Subagent | Timeout | On Timeout Action |
|----------|---------|-------------------|
| Web Researcher | 5 min | Return partial findings |
| Coder | 10 min | Return partial implementation with TODOs |
| Tester | 10 min | Return partial test suite |
| Git Handler | 2 min | Return partial status, queue retry |
| PR Resolver | 10 min | Return partial resolution status |
| Doc Reviewer | 3 min | Return partial lint results |
| Security Auditor | 10 min | Return partial audit |
| Dependency Manager | 5 min | Return partial audit |
| Issue Creator | 10 min | Create best-effort issue with assumptions |
| Issue Resolver | 30 min | Return partial resolution, queue remaining |
| Commit Reviewer | 5 min | Return partial review with warning |

## Adding New Subagents

1. Create specification file in this directory
2. Define input/output contract
3. Specify model tier and context budget
4. Document failure modes with **autonomous recovery** (no clarification requests)
5. Specify timeout budget
6. Update orchestrator to recognize new subagent
7. Reference [Self-Healing](../concepts/self-healing.md) in failure modes section
