# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Calendar Versioning](https://calver.org/).

## [Unreleased]

### Removed

- **Consolidated Duplicate Commands**: Removed 4 redundant commands in favor of rok-* series
  - Removed `review-code` (replaced by `rok-review-pr` which has GitHub CLI integration and systematic workflow)
  - Removed `pull-request` (workflow covered by rok-* command series)
  - Removed `pull-request-review-feedback` (replaced by `rok-respond-to-reviews` with parallel sub-agents)
  - Removed `generate-code` (too generic, covered by implementation workflows and Agent OS patterns)
- **Rationale**: The rok-* commands from the Shape Up methodology provide more comprehensive, systematic approaches
  with better GitHub CLI integration and parallel processing capabilities
- **Migration Guide**: See [MIGRATION-GUIDE.md](.ai-instructions/MIGRATION-GUIDE.md) for detailed transition instructions

### Changed

- **Commands Count**: Reduced from 11 to 7 commands (3 core + 4 rok-* community commands)
- **Documentation**: Updated INSTRUCTIONS.md and README.md to reflect new command structure

## v0.8.0 - 2025-12-03

First formal release. This version consolidates all previous development work into a stable, documented release.

### Added

- **5-Step Development Workflow**: Rigorous workflow for automated, high-quality development
  - Research & Explore, Plan & Document, Define Success & PR, Implement & Verify, Finalize & Commit
- **Memory Bank Concept**: Structured external memory for AI context retention across sessions
- **PR Review Feedback Automation**: GraphQL queries for programmatic PR conversation resolution
- **Standard Open-Source Files**: CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md
- **Multi-Vendor Support**: Full integration with Claude, GitHub Copilot, and Gemini
- **11 Reusable Commands**: commit, generate-code, infrastructure-review, pull-request, review-code, review-docs, and rok-* community commands

### Changed

- **DRY Architecture**: All vendor directories now symlink to `.ai-instructions/` single source of truth
- **Consolidated Documentation**: Moved architecture and project-scope docs to `.ai-instructions/concepts/`
- **Overhauled README**: Expanded from minimal to comprehensive project overview
- **GitHub Actions**: Updated Claude workflow to use `CLAUDE_CODE_OAUTH_TOKEN`

### Infrastructure

- **Markdown Linting**: markdownlint-cli2 with pre-commit hooks
- **CI/CD**: GitHub Actions for automated code review and linting
- **Symlink Architecture**: 24 symlinks maintaining DRY principle across vendor directories

### Documentation

- 13 concept documents covering standards, principles, and patterns
- 5 workflow documents for the development lifecycle
- 6 Memory Bank documents for AI context management
- Comprehensive architecture and project scope documentation

---

*This changelog consolidates all development work from initial creation through December 3, 2025.*
