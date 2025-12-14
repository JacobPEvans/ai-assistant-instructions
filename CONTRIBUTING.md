# Contributing

First off, thanks for considering contributing to this project. It's just me here, so any help is genuinely appreciated.

## The Short Version

1. Fork it
2. Create your feature branch (`git checkout -b feature/cool-thing`)
3. Commit your changes (`git commit -m 'Add some cool thing'`)
4. Push to the branch (`git push origin feature/cool-thing`)
5. Open a Pull Request

That's it. I'm not picky.

## Reporting Issues

Found a bug? Something unclear? Open an issue. Describe what you expected, what happened instead, and any relevant context. Screenshots are nice but not required.

## Pull Requests

For detailed PR workflow guidance, see [PR Review Guidance](.ai-instructions/concepts/pr-review-guidance.md).

### Before You Start

- Check if there's already an issue or PR for what you're planning
- For big changes, maybe open an issue first to discuss (or don't, I'm not your boss)

### AI Reviewers

PRs are reviewed by AI assistants. You can also manually summon them:

- **Claude**: Comment `@claude` on the PR
- **Gemini**: Comment `/gemini review` on the PR
- **Copilot**: Tag `@copilot` on the PR

AI feedback is suggestions - use your judgment on what to address.

### Code Style

This repo has markdown linting via `markdownlint-cli2`. The pre-commit hooks will catch most issues, but if you want to check locally:

```bash
markdownlint-cli2 "**/*.md"
```

Follow the existing patterns in `.ai-instructions/`. If you're not sure about something, just make your best guess. I can always tweak it during review.

### Commit Messages

Use conventional commits if you remember:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `refactor:` for code changes that don't add features or fix bugs

But honestly, as long as your commit message explains what you did, we're good.

## What Gets Accepted

Pretty much anything that:

- Improves the documentation
- Adds useful AI assistant workflows
- Fixes bugs or typos
- Makes the codebase more maintainable

I'll probably accept most reasonable PRs. This is a documentation repo, not a nuclear reactor.

## What Might Not Get Accepted

- Breaking changes without discussion
- Vendor-specific instructions that don't fit the multi-AI philosophy
- Changes that make the repo significantly more complex without clear benefit

## Development Setup

1. Clone the repo
2. Install pre-commit: `pip install pre-commit && pre-commit install`
3. Make changes
4. Commit and push

That's the whole setup. No build system, no dependencies to install, no configuration files to create.

## Questions?

Open an issue. I'll respond when I can.

---

*Thanks for reading this far. Most people don't.*
