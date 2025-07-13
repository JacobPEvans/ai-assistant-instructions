# Project Status & Planning

## Current Session Progress

This session's work is complete. The following tasks were accomplished:

- Integrated expert AI best practices into the core instruction set.
- Introduced the "Memory Bank" concept for improved AI context management.
- Established and documented standards for workspace management and vendor-specific configuration.
- Consolidated `TODO.md` into this planning file.
- Performed a full repository cleanup to enforce DRY principles.

## Repository Context

- **Target**: Standardized, vendor-agnostic AI assistant instructions.
- **Purpose**: To provide a centralized, maintainable, and extensible knowledge base for consistent AI-assisted development workflows.
- **Tools**: GitHub Actions, Markdown linting, various AI assistants (Claude, Copilot, etc.).

### Key Files

- `.ai-instructions/` - The single source of truth for all instructions, commands, and concepts.
- `.claude/`, `.github/`, `.copilot/` - Vendor-specific directories that now contain only links to the files in `.ai-instructions`.
- `CHANGELOG.md` - Tracks all notable changes to the project.
- `PLANNING.md` - This file, used for planning future work.

## Known Issues

- **Unresolved PR Conversation Resolution**: The GitHub Pull Request conversation resolution system remains unresolved despite multiple investigation sessions. The specific issue is that PR comments/conversations are not being automatically resolved when the underlying issues are fixed. This blocks completion of PR #22. Multiple approaches have been attempted including GraphQL API investigation, but the core problem persists.

- **Persistent Markdown Linting Failures**: The `markdownlint-cli2` GitHub Action is consistently failing on pull request #22, citing
  `MD013/line-length` and `MD046/code-block-style` errors. Multiple attempts to fix these issues by re-writing files and using different tools have failed.
  The root cause appears to be a discrepancy between the local environment and the CI environment, or a fundamental misunderstanding of how the linter
  is configured in the action. Future attempts must start by disabling the `MD013` and `MD046` rules entirely in `.markdownlint.json` to establish a
  passing baseline, then re-introduce them one by one.

## Next Session Actions & Future Improvements

- **Multi-AI Agent Collaboration**: Develop a system where multiple AI agents can collaborate on a single task, handing off work between them.
- **Automated Link Checking**: Implement a GitHub Action to regularly check for broken markdown links.
- **Command Validation**: Explore creating a script that validates the structure of the vendor-specific directories.
- **Add More Granular Commands**: Consider breaking down the existing commands into even more granular tasks.
- **Expand Concepts**: Add more conceptual documents to the `.ai-instructions/concepts` directory.
- **Re-evaluate Markdown Rules**: Re-visit the disabled markdown rules in `.markdownlint.json` and fix the files to comply.
- **Create "Kick-off" Prompt**: Develop a new prompt that starts from scratch, reads all relevant instructions, and then kicks off an agent to begin the next task.
