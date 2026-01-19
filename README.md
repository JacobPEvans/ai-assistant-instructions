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

## Prerequisites

- **Git 2.30+** (for worktree support)
- **GitHub CLI** (`gh`) 2.0+ (for PR/issue management)
- **(Optional) Python 3.8+** for validation hooks
- **(Optional) Node.js 18+** for markdown linting

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/JacobPEvans/ai-assistant-instructions.git

# 2. Copy agentsmd to your project
cp -r ai-assistant-instructions/agentsmd your-project/

# 3. Create vendor symlinks
cd your-project
ln -s AGENTS.md CLAUDE.md

# 4. Verify setup (if using Claude Code)
claude doctor
```

Or just browse the [documentation](docs/) and cherry-pick what you need.

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

See AGENTS.md "Commands" section for the complete command reference table.

All commands live in [`agentsmd/commands/`](agentsmd/commands/).

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

**Advanced**: This repo integrates with
[nix-config](https://github.com/JacobPEvans/nix) for unified permission
management across AI tools. This is **optional** - the basic setup works
standalone. See [`agentsmd/docs/permission-system.md`](agentsmd/docs/permission-system.md)
for details.

## Need Help?

- 📖 [Documentation Home](docs/) - Getting started guides and references
- 🐛 [Issues](https://github.com/JacobPEvans/ai-assistant-instructions/issues) - Report bugs or request features

## Contributing

Contributions welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the details, though the short version
is: open a PR, don't be a jerk, and I'll probably merge it.

## Security

Found a vulnerability? Please report it responsibly. See [SECURITY.md](SECURITY.md) for details.

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
