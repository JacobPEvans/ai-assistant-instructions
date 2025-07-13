# Project Status & Planning

## Current Session Progress

All major refactoring and consolidation of the AI instructions are complete.
The repository now follows the DRY principle with a single source of truth in the `.ai-instructions` directory.

## Repository Context

- **Target**: Standardized, vendor-agnostic AI assistant instructions.
- **Purpose**: To provide a centralized, maintainable, and extensible knowledge base for consistent AI-assisted development workflows.
- **Tools**: GitHub Actions, Markdown linting, various AI assistants (Claude, Copilot, etc.).

### Key Files

- `.ai-instructions/` - The single source of truth for all instructions, commands, and concepts.
- `.claude/`, `.github/`, `.copilot/` - Vendor-specific directories that now contain only links to the files in `.ai-instructions`.
- `CHANGELOG.md` - Tracks all notable changes to the project.
- `PLANNING.md` - This file, used for planning future work.

## Next Session Actions & Future Improvements

- **Multi-AI Agent Collaboration**: Develop a system where multiple AI agents can collaborate on a single task, handing off work between them.
- **Automated Link Checking**: Implement a GitHub Action to regularly check for broken markdown links.
- **Command Validation**: Explore creating a script that validates the structure of the vendor-specific directories.
- **Add More Granular Commands**: Consider breaking down the existing commands into even more granular tasks.
- **Expand Concepts**: Add more conceptual documents to the `.ai-instructions/concepts` directory.
- **Re-evaluate Markdown Rules**: Re-visit the disabled markdown rules in `.markdownlint.json` and fix the files to comply.
