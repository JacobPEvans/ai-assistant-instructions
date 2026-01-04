# Documentation

Welcome to the AI Assistant Instructions documentation. This guide will help you understand, set up, and use this framework effectively.

## Quick Navigation

- **[Getting Started](#getting-started)** - New to this repo? Start here
- **[Guides](#guides)** - How-to articles for common tasks
- **[Architecture](#architecture)** - Understanding how everything works
- **[Reference](#reference)** - Complete documentation and API references

## Getting Started

### First Time Here?

1. Check the [Prerequisites](../README.md#prerequisites) in the main README
2. Follow the [Quick Start](../README.md#quick-start) guide
3. Read [Common Issues](troubleshooting.md) if you get stuck

### Setting Up Your Project

Create a new feature branch and initialize a worktree:

```bash
/init-worktree feat "your-feature-description"
```

Then follow the [Worktree Workflow](../agentsmd/rules/worktrees.md) guide.

## Guides

- [Branch Cleanup](BRANCH-CLEANUP.md) - Safely delete merged branches
- [Issue Linking](guidelines/issue-linking.md) - GitHub workflow best practices
- [Worktree Workflow](../agentsmd/rules/worktrees.md) - Development with git worktrees
- [Permission System](../agentsmd/docs/permission-system.md) - AI tool permission management

## Projects

Planning documents for major initiatives:

- [Multi-Model Orchestration](projects/multi-model-orchestration/PLAN.md) - Hybrid AI orchestration system design

## Optimization

Token and performance optimization analysis:

- [Command Optimization Plan](optimization/command-optimization-plan.md) - DRY principles for commands
- [Optimization Results](optimization/optimization-results.md) - Completed optimizations and savings

## Architecture

- [System Overview](../agentsmd/docs/permission-system.md) - How permissions integrate
- [Symlink Structure](../agentsmd/rules/) - Why and how we use symlinks
- [External Dependencies](../agentsmd/docs/permission-system.md#nix-config) - nix-config integration (optional)

## Reference

- [All Commands](../agentsmd/commands/) - Complete command documentation
- [Development Rules](../agentsmd/rules/) - Code and documentation standards
- [Workflow Templates](../agentsmd/workflows/) - 5-step development workflow

## Troubleshooting

Having issues? See [Troubleshooting](troubleshooting.md) for common problems and solutions.

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines.
