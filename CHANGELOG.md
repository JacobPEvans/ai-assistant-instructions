# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Calendar Versioning](https://calver.org/).

## 2025-07-13

### Added

- **New 5-Step Workflow**: Created a new, rigorous 5-step workflow
  (`.ai-instructions/workflows/`) designed for automated, high-quality,
  test-driven development.
- **PRD Integration**: Integrated Product Requirements Document (PRD) principles
  into the planning step (Step 2) to ensure the "why" is documented before the
  "how".
- **Memory Bank Concept**: Introduced the "Memory Bank" (`.ai-instructions/concepts/memory-bank/`) as a structured external brain for the AI, improving
  context retention and session management.
- **AI Best Practices**: Integrated several expert-level AI interaction best practices, including adversarial testing, checklist-driven plans, and TDD.
- **Workspace and Vendor Standards**: Added new concepts for managing multi-repository workspaces and standardizing vendor-specific configuration files to
  enforce DRY principles.
- **PR Review Feedback Automation**: Created comprehensive `pull-request-review-feedback.md` documentation with exact, tested GraphQL queries for:
  - Retrieving ALL pull request conversations and comments with resolution status
  - Resolving individual conversations after fixing underlying issues  
  - Batch resolution of multiple conversations
  - Complete workflow examples with variable substitution
  - Troubleshooting guide and success criteria

### Changed

- **Updated Core Instructions**: The main `INSTRUCTIONS.md` and `README.md` now
  reference the new 5-step workflow as the primary process.
- **Refined `PLANNING.md`**: Added future-looking goal of multi-AI agent
  collaboration.
- **Improved Commit Workflow**: Updated the `commit.md` command to align with
  the new 5-step, test-first process.

### Fixed

- **Broken Links**: Corrected multiple broken internal links in `.github`
  pointer files.

### Fixed

- **✅ MAJOR BREAKTHROUGH: PR Conversation Resolution**: Successfully resolved the GitHub PR conversation/comment resolution issue that was blocking PR automation.
  Developed and tested working GraphQL queries that can reliably:
  1. Get ALL pull request review threads and comments with resolution status
  2. Resolve individual conversations after fixing underlying issues
  
  **Impact**: This breakthrough enables fully automated PR management workflows. The exact working GraphQL queries are documented in
  `pull-request-review-feedback.md` with detailed variable substitution examples.
  
  **Technical Details**: 
  - Query: `repository.pullRequest.reviewThreads` with nested comments
  - Mutation: `resolveReviewThread(input: {threadId})` 
  - Successfully tested on python-template PR #2, resolving all 6 conversations
  - Added critical rule: NEVER suppress linters - always fix root causes

## 2025-06-29

### Changed

- **Major Refactoring**: Centralized all AI instructions into a single
  `.ai-instructions` directory to act as the single source of truth (DRY).
- **Consolidated Instructions**: Merged all vendor-specific instructions into a
  unified set of `commands` and `concepts`.
- **Standardized Vendor Files**: Updated all vendor-specific files to be simple
  pointers to the new centralized instructions.
- **Simplified Structure**: Merged `main.md` into `INSTRUCTIONS.md` and removed
  the `prompts` vs. `commands` distinction.
- **Updated `IMPLEMENTATION_GUIDE.md`**: Merged essential content into the new
  `.ai-instructions` and removed the redundant file.

### Removed

- Obsolete and redundant entries from before the major refactoring.

## 2025-06-26

### Added

- Initial consolidation of AI assistant instructions into a single
  `instructions/INSTRUCTIONS.md` file.
- Streamlined `CLAUDE.md` and `copilot-instructions.md` to reference the single
  source of truth.

## 2025-06-24

### Added

- Enhanced infrastructure automation permissions for Terraform and Terragrunt.

### Changed

- Improved commit workflow documentation with a critical emphasis on change
  review.
- Reverted Claude GitHub Actions workflow to the default Sonnet 3.5 model for
  optimal performance.
- Fixed GitHub Actions Terraform workflow YAML syntax.

## 2025-06-22

### Added

- **Comprehensive Security**: Enhanced security scanning for SSH keys and
  usernames, and implemented precise, least-privilege permissions.
- **GraphQL for PRs**: Added documentation for using the GitHub GraphQL API to
  analyze PR comments.
- **`.claude/` Structure**: Adopted the official `.claude/` directory structure
  for commands and settings.

### Changed

- **Optimized CI/CD**: Consolidated duplicate workflows into a single,
  streamlined `claude.yml` and optimized GitHub Actions timeouts.
- **Modernized Git Workflow**: Updated the standard git workflow to use
  `git status -v -v` for more detailed change analysis.
- **Improved Documentation**: Modernized the `README.md` and all other
  documentation with a focus on a dual AI system.

### Removed

- Redundant `claude-code-review.yml` workflow.
