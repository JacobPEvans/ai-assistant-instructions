# AI Assistant Instructions

> Teaching AI assistants how to help you better. Yes, it's AI instructions written with AI assistance. We've come full circle.

[![License][license-badge]][license-url]
[![Markdown Lint][markdownlint-badge]][markdownlint-url]
[![Claude Code Review][claude-badge]][claude-url]
[![pre-commit][precommit-badge]][precommit-url]

## What Is This?

A centralized collection of instructions, workflows, and configurations for AI coding assistants.
Drop these into your projects and get consistent, high-quality AI assistance across Claude, Copilot, and Gemini.

Think of it as a style guide, but for your AI pair programmer.

## Quick Start

```bash
# Clone the repo
git clone https://github.com/JacobPEvans/ai-assistant-instructions.git

# Copy the agentsmd directory to your project
cp -r ai-assistant-instructions/agentsmd your-project/

# Symlink vendor directories as needed
cd your-project
ln -s AGENTS.md CLAUDE.md
```

Or just browse the docs and cherry-pick what you need.

## Directory Structure

```text
.
├── AGENTS.md                  # Main AgentsMD entry point
├── agentsmd/                  # Supporting files
│   ├── commands/              # Reusable command prompts
│   ├── rules/                 # Core principles and standards
│   └── workflows/             # The 5-step development workflow
├── .claude/                   # Claude-specific symlinks
├── .copilot/                  # GitHub Copilot symlinks
├── .gemini/                   # Gemini symlinks
└── .github/                   # GitHub integration (prompts, workflows)
```

Everything in `.claude/`, `.copilot/`, and `.gemini/` symlinks back to `agentsmd/`. One source, multiple consumers. DRY principle in action.

## Supported AI Assistants

| Assistant | Integration | Notes |
| --------- | ----------- | ----- |
| **Claude** | `.claude/` directory | Full command support via Claude Code |
| **GitHub Copilot** | `.github/copilot-instructions.md` + prompts | Works in VS Code, GitHub.com, Visual Studio |
| **Gemini** | `.gemini/` directory | Style guide and config support |

## The 5-Step Workflow

This repo centers on a rigorous development workflow:

1. **Research & Explore** - Understand before you code
2. **Plan & Document** - Write the "what" and "why" before the "how"
3. **Define Success & PR** - Set acceptance criteria upfront
4. **Implement & Verify** - Build with tests, verify as you go
5. **Finalize & Commit** - Clean commits, passing CI

Full details in [`agentsmd/workflows/`](agentsmd/workflows/).

## Key Commands

### Initialization & Setup

| Command | Description |
| ------- | ----------- |
| `/init-worktree` | Initialize a clean worktree for development |

### Git & Repository Management

| Command | Description |
| ------- | ----------- |
| `/git-refresh` | Merge PRs, sync repo, cleanup stale worktrees |
| `/sync-prs-with-main` | Sync all open PRs with main branch |
| `/sync-permissions` | Sync AI assistant permissions to repo |

### Code Review & Quality

| Command | Description |
| ------- | ----------- |
| `/review-code` | Structured code review with quality checks |
| `/infrastructure-review` | Review Terraform/Terragrunt infrastructure |
| `/review-docs` | Review and improve documentation |
| `/generate-code` | Scaffold new code with standards |

### PR Lifecycle Management

| Command | Description |
| ------- | ----------- |
| `/pr` | Complete PR lifecycle management |
| `/pr-review-feedback` | Resolve PR review threads via GraphQL |
| `/fix-pr-ci` | Fix CI failures in current repo |
| `/fix-all-pr-ci-all-repos` | Fix CI failures across all owned repos |
| `/resolve-pr-review-thread-all` | Address review comments in current repo |
| `/resolve-pr-review-thread-all-repos` | Address review comments across all repos |

### Issue & Architecture Management

| Command | Description |
| ------- | ----------- |
| `/rok-shape-issues` | Shape raw ideas into actionable GitHub issues |
| `/rok-resolve-issues` | Analyze and implement GitHub issues |
| `/rok-review-pr` | Comprehensive PR review with systematic analysis |
| `/rok-resolve-pr-review-thread` | Resolve PR review feedback efficiently |

### Delegation & Integration

| Command | Description |
| ------- | ----------- |
| `/delegate-to-ai` | Delegate tasks to external AI assistants |

All 19 active commands live in [`agentsmd/commands/`](agentsmd/commands/). See the [Commands](agentsmd/commands/) reference for detailed documentation on each.

## Core Concepts

The documentation covers:

- **Code Standards** - Consistency across languages
- **Documentation Standards** - AI-friendly markdown
- **Infrastructure Standards** - Terraform/Terragrunt patterns
- **Permission System** - How AI tool permissions integrate with nix-config
- **DRY Principle** - Why everything symlinks to one place
- **Memory Bank** - Maintaining AI context across sessions
- **Remote Commit Workflow** - Making commits via GitHub API without local clone

Browse [`agentsmd/rules/`](agentsmd/rules/) and [`agentsmd/docs/`](agentsmd/docs/).

**Permission Integration**: See
[`agentsmd/docs/permission-system.md`](agentsmd/docs/permission-system.md) to understand how
permissions integrate with [nix-config](https://github.com/JacobPEvans/nix).

## Contributing

Contributions welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the details, though the short version
is: open a PR, don't be a jerk, and I'll probably merge it.

## License

[Apache 2.0](LICENSE) - Use it, modify it, just keep the attribution.

---

*Built by a human, refined by AI, used by both.*

[license-badge]: https://img.shields.io/badge/License-Apache_2.0-blue.svg
[license-url]: LICENSE
[markdownlint-badge]: https://github.com/JacobPEvans/ai-assistant-instructions/actions/workflows/markdownlint.yml/badge.svg
[markdownlint-url]: https://github.com/JacobPEvans/ai-assistant-instructions/actions/workflows/markdownlint.yml
[claude-badge]: https://github.com/JacobPEvans/ai-assistant-instructions/actions/workflows/claude.yml/badge.svg
[claude-url]: https://github.com/JacobPEvans/ai-assistant-instructions/actions/workflows/claude.yml
[precommit-badge]: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit
[precommit-url]: https://github.com/pre-commit/pre-commit
