# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Calendar Versioning](https://calver.org/).

## 2025-06-29

### Changed

- **Major Refactoring**: Centralized all AI instructions into a single `.ai-instructions` directory to act as the single source of truth (DRY).
- **Consolidated Instructions**: Merged all vendor-specific instructions into a unified set of `commands` and `concepts`.
- **Standardized Vendor Files**: Updated all vendor-specific files to be simple pointers to the new centralized instructions.
- **Simplified Structure**: Merged `main.md` into `INSTRUCTIONS.md` and removed the `prompts` vs. `commands` distinction.
- **Updated `IMPLEMENTATION_GUIDE.md`**: Merged essential content into the new `.ai-instructions` and removed the redundant file.

### Removed

- Obsolete and redundant entries from before the major refactoring.

## 2025-06-26

### Added

- Initial consolidation of AI assistant instructions into a single `instructions/INSTRUCTIONS.md` file.
- Streamlined `CLAUDE.md` and `copilot-instructions.md` to reference the single source of truth.

## 2025-06-24

### Added

- Enhanced infrastructure automation permissions for Terraform and Terragrunt.

### Changed

- Improved commit workflow documentation with a critical emphasis on change review.
- Reverted Claude GitHub Actions workflow to the default Sonnet 3.5 model for optimal performance.
- Fixed GitHub Actions Terraform workflow YAML syntax.

## 2025-06-22

### Added

- **Comprehensive Security**: Enhanced security scanning for SSH keys and usernames, and implemented precise, least-privilege permissions.
- **GraphQL for PRs**: Added documentation for using the GitHub GraphQL API to analyze PR comments.
- **`.claude/` Structure**: Adopted the official `.claude/` directory structure for commands and settings.

### Changed

- **Optimized CI/CD**: Consolidated duplicate workflows into a single, streamlined `claude.yml` and optimized GitHub Actions timeouts.
- **Modernized Git Workflow**: Updated the standard git workflow to use `git status -v -v` for more detailed change analysis.
- **Improved Documentation**: Modernized the `README.md` and all other documentation with a focus on a dual AI system.

### Removed

- Redundant `claude-code-review.yml` workflow.
