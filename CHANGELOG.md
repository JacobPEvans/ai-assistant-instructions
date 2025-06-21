# Changelog

All notable changes to the ai-assistant-instructions project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive 6-step commit workflow with systematic validation and security scanning
- Enhanced pre-commit validation framework for infrastructure, security, and code quality
- Mandatory CHANGELOG.md update process with calendar versioning guidance
- Error handling and recovery strategies for validation failures and workflow issues
- Integration with Claude Code best practices including plan-first methodology
- Expanded Claude Code permissions for comprehensive git, terraform, and web operations
- Comprehensive markdown linting GitHub Action for all *.md files with markdownlint-cli2
- Markdownlint configuration with 120-character line length limit
- .copilot/instructions.md for GitHub Copilot custom instructions
- .github/prompts/ directory with infrastructure and development prompt templates
- Comprehensive prompt templates for code review, problem-solving, and refactoring
- Infrastructure-specific prompts for Terraform development and security review

### Changed
- Complete rewrite of commit workflow from basic terraform process to enterprise-grade methodology
- Calendar versioning adoption (YY.M.DD format) for consistent release tracking
- Documentation standards enhanced with plan-first methodology and custom commands integration
- Claude Code settings optimization with improved organization and expanded capabilities
- Enhanced repository structure to support GitHub Copilot integration
- Improved AI instruction organization for better context management

## [25.6.19] - 2025-06-19

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

### Security
- Proper separation of security-sensitive information
- Guidelines for placeholder values in public repositories
- Best practices for secrets management and access control
