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

# Copy the .ai-instructions directory to your project
cp -r ai-assistant-instructions/.ai-instructions your-project/

# Symlink vendor directories as needed
cd your-project
ln -s .ai-instructions/INSTRUCTIONS.md CLAUDE.md
```

Or just browse the docs and cherry-pick what you need.

## Directory Structure

```text
.
├── .ai-instructions/          # The single source of truth
│   ├── INSTRUCTIONS.md        # Main entry point
│   ├── commands/              # Reusable command prompts
│   ├── concepts/              # Core principles and standards
│   └── workflows/             # The 5-step development workflow
├── .claude/                   # Claude-specific symlinks
├── .copilot/                  # GitHub Copilot symlinks
├── .gemini/                   # Gemini symlinks
└── .github/                   # GitHub integration (prompts, workflows)
```

Everything in `.claude/`, `.copilot/`, and `.gemini/` symlinks back to `.ai-instructions/`. One source, multiple consumers. DRY principle in action.

## Supported AI Assistants

| Assistant | Integration | Notes |
|-----------|------------|-------|
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

Full details in [`.ai-instructions/workflows/`](.ai-instructions/workflows/).

## Key Commands

| Command | Description |
|---------|-------------|
| `/generate-code` | Scaffold new code with standards |
| `/git-refresh` | Merge PRs, sync repo, cleanup worktrees |
| `/infrastructure-review` | Review Terraform/Terragrunt code |
| `/pull-request` | Create well-documented PRs |
| `/review-code` | Structured code review |
| `/review-docs` | Review and improve documentation |

**Community commands** (rok-* series): `/rok-shape-issues`, `/rok-resolve-issues`, `/rok-review-pr`, `/rok-respond-to-reviews`

All 10 commands live in [`.ai-instructions/commands/`](.ai-instructions/commands/).

## Core Concepts

The documentation covers:

- **Code Standards** - Consistency across languages
- **Documentation Standards** - AI-friendly markdown
- **Infrastructure Standards** - Terraform/Terragrunt patterns
- **DRY Principle** - Why everything symlinks to one place
- **Memory Bank** - Maintaining AI context across sessions

Browse [`.ai-instructions/concepts/`](.ai-instructions/concepts/).

## Contributing

Contributions welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the details, though the short version is: open a PR, don't be a jerk, and I'll probably merge it.

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
