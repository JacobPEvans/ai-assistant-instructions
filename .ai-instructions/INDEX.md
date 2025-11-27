# AI Navigation Index

Quick-reference map for AI agents. Find relevant documentation fast.

## By Task

### I need to

| Task | Start Here |
|------|------------|
| Understand the workflow | [INSTRUCTIONS.md](./INSTRUCTIONS.md) → [Workflows](./workflows/) |
| Start a new session | [Session Initializer](./subagents/session-initializer.md) → [Progress Checkpoint](./concepts/progress-checkpoint.md) |
| Resume from checkpoint | [Progress Checkpoint](./concepts/progress-checkpoint.md) → `/resume` command |
| Hand off to next session | [Workflow Transitions](./commands/workflow-transitions.md) → `/handoff` command |
| Write code | [Coder Subagent](./subagents/coder.md) → [Code Standards](./concepts/code-standards.md) |
| Write tests | [Tester Subagent](./subagents/tester.md) |
| Validate quality | [QA Validator](./subagents/qa-validator.md) |
| Create a PR | [PR Command](./commands/pull-request.md) |
| Handle PR feedback | [PR Resolver](./subagents/pr-resolver.md) → [GraphQL Snippets](./_shared/snippets/github-graphql.md) |
| Commit changes | [Commit Command](./commands/commit.md) |
| Work autonomously | [Autonomous Orchestration](./concepts/autonomous-orchestration.md) |
| Handle errors | [Self-Healing](./concepts/self-healing.md) |
| Run overnight | [User Presence Modes](./concepts/user-presence-modes.md) |
| Choose model tier | [Model Routing](./_shared/model-routing.md) |
| Compact context | [Context Compactor](./subagents/context-compactor.md) → `/compact` command |
| Create GitHub issues | [Issue Creator](./subagents/issue-creator.md) |
| Resolve GitHub issues | [Issue Resolver](./subagents/issue-resolver.md) |

## By Concept

### Core Patterns

| Concept | File | When to Use |
|---------|------|-------------|
| Autonomous Operation | [autonomous-orchestration.md](./concepts/autonomous-orchestration.md) | Running without user |
| Progress Checkpoint | [progress-checkpoint.md](./concepts/progress-checkpoint.md) | Cross-session context bridging |
| Self-Healing | [self-healing.md](./concepts/self-healing.md) | Error recovery, ambiguity |
| Hard Protections | [hard-protections.md](./concepts/hard-protections.md) | Safety constraints |
| User Modes | [user-presence-modes.md](./concepts/user-presence-modes.md) | Attended vs unattended |
| Parallelism | [parallelism.md](./concepts/parallelism.md) | Running tasks in parallel |
| Model Routing | [model-routing.md](./_shared/model-routing.md) | Choosing model tier |

### Standards

| Standard | File |
|----------|------|
| Code | [code-standards.md](./concepts/code-standards.md) |
| Style | [styleguide.md](./concepts/styleguide.md) |
| Documentation | [documentation-standards.md](./concepts/documentation-standards.md) |
| Infrastructure | [infrastructure-standards.md](./concepts/infrastructure-standards.md) |
| DRY Principle | [dry-principle.md](./concepts/dry-principle.md) |

## Directory Structure

```text
.ai-instructions/
├── INSTRUCTIONS.md      # Start here - main entry point
├── INDEX.md             # This file - navigation
├── _shared/             # Reusable components (DRY)
│   ├── subagent-contract.md
│   ├── timeout-budgets.md
│   ├── model-routing.md # Model tier selection rules
│   └── snippets/        # Copy-paste code snippets
├── concepts/            # Core patterns and standards
├── commands/            # Slash command definitions
├── subagents/           # Specialized agent specs (14 total)
└── workflows/           # 5-step development process
```

## Quick Links

### Most Used

- [Main Instructions](./INSTRUCTIONS.md)
- [Progress Checkpoint](./concepts/progress-checkpoint.md)
- [Self-Healing](./concepts/self-healing.md)
- [Model Routing](./_shared/model-routing.md)
- [Subagent Contract](./_shared/subagent-contract.md)
- [Timeout Budgets](./_shared/timeout-budgets.md)

### Memory Bank

- [README](./concepts/memory-bank/README.md)
- [Active Context](./concepts/memory-bank/active-context.md)
- [Task Queue](./concepts/memory-bank/task-queue.md)
- [Progress Checkpoint](./concepts/progress-checkpoint.md)

### Workflows

1. [Research](./workflows/1-research-and-explore.md)
2. [Plan](./workflows/2-plan-and-document.md)
3. [Define Success](./workflows/3-define-success-and-pr.md)
4. [Implement](./workflows/4-implement-and-verify.md)
5. [Finalize](./workflows/5-finalize-and-commit.md)

## File Size Guide

Files are optimized for AI context windows:

| Size | Classification | Action |
|------|---------------|--------|
| <100 lines | Optimal | Read fully |
| 100-200 lines | Good | Read fully |
| 200-300 lines | Acceptable | Skim first |
| >300 lines | Large | Use sections |

## See Also

- [Architecture Diagrams](./concepts/architecture-diagrams.md) - Visual overviews
- [Multi-Agent Patterns](./concepts/multi-agent-patterns.md) - Orchestration
