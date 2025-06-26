# Changelog

<!-- markdownlint-disable-file MD024 -->

All notable changes to the ai-assistant-instructions project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Calendar Versioning](https://calver.org/).

## 2025-06-26

### Added

- Consolidated AI assistant instructions in new `instructions/INSTRUCTIONS.md` file combining all content from CLAUDE.md and copilot-instructions.md
- Comprehensive AI assistant methodology covering all platforms (Claude, Copilot, etc.)

### Changed

- Streamlined CLAUDE.md and copilot-instructions.md to reference single source of truth
- Enhanced documentation organization with logical consolidation of overlapping sections
- Improved structure with proper hierarchical markdown formatting

## 2025-06-24

### Added

- Enhanced infrastructure automation permissions (terraform init, terragrunt apply, terragrunt state)

### Changed

- Enhanced Claude Code documentation with clearer methodology section titles
- Improved commit workflow documentation with critical emphasis on change review
- Reverted Claude GitHub Actions workflow to default Sonnet 4 model for optimal performance
- Fixed GitHub Actions Terraform workflow YAML syntax (timeout_minutes → timeout-minutes)
- Cleaned up CHANGELOG.md references to maintain accuracy

## 2025-06-22

### Added

- GitHub GraphQL API documentation for PR comment analysis and external conversation reading
- Enhanced Claude settings with echo command permissions for improved debugging
- Git Standard Commits reference integration in commit workflow
- AWS DynamoDB permissions for infrastructure monitoring (list-tables, scan)
- Comprehensive security scanning including SSH keys and usernames
- Precise Terraform/Terragrunt permissions with version checking
- Enhanced Claude Code repository structure following .claude/ standards

### Changed

- Optimized Claude GitHub Actions workflow for automatic pull request reviews
- Consolidated duplicate workflows into single streamlined claude.yml configuration
- Enhanced commit workflow documentation with auto-merge support
- Enhanced Claude Code documentation standards with improved structure and clarity
- Updated implementation guide to reflect dual AI system architecture (GitHub Copilot + Claude Code)
- Modernized README with comprehensive dual AI system integration details
- Fixed markdown linting compliance across all documentation files
- Improved gitignore organization with enhanced credential pattern matching
- Standardized pull request template with proper markdown structure
- Modernized git workflow to use git status -v -v for change analysis
- Optimized GitHub Actions timeouts for improved CI/CD efficiency
- Streamlined commit workflow validation requirements
- Refined changelog documentation for clarity
- Enhanced parallel execution guidelines for better performance
- Enhanced commit workflow with changelog cleanup and validation guidelines
- Fixed CHANGELOG.md markdown linting compliance with MD024 directive
- Converted PR template from YAML to proper markdown format following GitHub best practices
- Refined Claude Code permissions for better security and specificity

### Removed

- Redundant claude-code-review.yml workflow (consolidated into main claude.yml)

### Security

- Expanded sensitive data scanning to include SSH keys and usernames
- Implemented precise permission controls replacing broad wildcards

## 2025-06-21

### Added

- Comprehensive 6-step commit workflow with validation and security scanning
- Enhanced Claude Code permissions for terraform and infrastructure operations
- PR template for consistent pull request formatting
- Terraform workflow for infrastructure validation

### Changed

- Standardized markdown linting with markdownlint-cli2 for consistency
- Calendar versioning adoption (YY.M.DD format) for release tracking
- Enhanced AI assistant instructions with plan-first methodology
- Updated documentation standards with PLANNING.md requirements

### Fixed

- Markdown formatting issues across documentation files
- Workflow configurations for better automation

## 2025-06-19

### Released

- Initial standardized Claude Code documentation
- Keep a Changelog guidelines and best practices
- Claude Code development workflow principles
- Technology-specific guidelines for Terraform and Git
- Project integration standards
- Anthropic official methodology for plan-first development
- Comprehensive PLANNING.md structure template
- System prompt guidelines and development workflow principles
- Code quality standards and infrastructure automation guidelines
- Project planning templates for complex development tasks
- Documentation standards for public/private repository separation
- Proper separation of security-sensitive information
- Guidelines for placeholder values in public repositories
- Best practices for secrets management and access control
