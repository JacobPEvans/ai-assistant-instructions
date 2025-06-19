# Claude Code Standardized Documentation

## Overview
This repository contains standardized Claude Code documentation, configurations, and best practices that apply across all projects. This serves as a centralized knowledge base for consistent development workflows.

## Repository Structure
```
.claude/
├── CLAUDE.md           # This file - standardized documentation
├── settings.local.json # Local Claude Code permissions
├── templates/          # Project templates and boilerplates
├── workflows/          # Common development workflows
└── best-practices/     # Technology-specific best practices
```

## Keep a Changelog Guidelines

### Purpose
Changelogs are for humans, not machines. They help users and contributors understand the evolution of software through clear, readable change documentation.

### Format Guidelines
- **Filename**: `CHANGELOG.md`
- **Structure**: List most recent version first
- **Sections**: Group similar changes together
- **Links**: Make versions and sections linkable
- **Dates**: Use consistent YYYY-MM-DD format
- **Versioning**: Follow Semantic Versioning

### Change Types
- **Added**: New features
- **Changed**: Modifications to existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Features no longer available
- **Fixed**: Bug corrections
- **Security**: Vulnerability fixes

### Best Practices
1. **Unreleased Section**: Track upcoming changes
2. **Human-Readable**: Avoid raw commit logs
3. **Clear Documentation**: Explain breaking changes and deprecations
4. **Comprehensive**: Include all notable changes
5. **Consistent Format**: Maintain formatting standards

### Example Structure
```markdown
# Changelog

## [Unreleased]
### Added
- New feature X

## [1.0.0] - 2024-01-15
### Added
- Initial release
### Changed
- Updated dependency Y
### Fixed
- Resolved issue with Z
```

## Claude Code Best Practices

### System Prompt Guidelines
- Use the `system` parameter to define Claude's role
- Be specific with role definitions (e.g., "Infrastructure Engineer specializing in Terraform")
- Provide domain-specific context for better performance
- Put task-specific instructions in user messages

### Development Workflow Principles
1. **Parallel Tool Execution**: Perform multiple independent operations simultaneously
2. **File Management**: Prefer editing existing files over creating new ones
3. **Cleanup**: Remove temporary files after task completion
4. **Explicit Instructions**: Provide detailed context and expectations
5. **Reflection**: Carefully analyze tool results before proceeding

### Code Quality Standards
- Follow existing code conventions and patterns
- Verify library/framework availability before use
- Implement security best practices
- Never expose secrets or credentials
- Focus on generalizable, robust solutions

### Infrastructure Automation
- Always plan before applying changes
- Use parallel tool calls for efficiency
- Implement proper error handling
- Document all processes and decisions
- Test in isolated environments first

## Technology-Specific Guidelines

### Terraform/Terragrunt
- Use `terragrunt plan` before all changes
- Implement remote state management
- Follow least-privilege access principles
- Document all variables with descriptions
- Use consistent naming conventions

### Git Workflow
- Use conventional commit messages
- Create feature branches for changes
- Never squash merge - preserve history
- Include proper commit validation
- Follow repository-specific guidelines

## Project Integration

### Repository Setup
1. Reference this documentation in project-specific `CLAUDE.md`
2. Implement project-specific overrides in `.claude/overrides/`
3. Use standardized templates from `.claude/templates/`
4. Follow established workflow patterns

### Documentation Standards
- Maintain project-specific context separately
- Reference generic guidelines from this document
- Keep security-sensitive information in private contexts
- Use placeholder values in public repositories

## Maintenance
- Regular updates to best practices
- Technology-specific guideline refinements
- Template improvements and additions
- Workflow optimization based on experience

## Version History
This document follows Keep a Changelog principles:

### [1.0.0] - 2024-06-19
#### Added
- Initial standardized Claude Code documentation
- Keep a Changelog guidelines and best practices
- Claude Code development workflow principles
- Technology-specific guidelines for Terraform and Git
- Project integration standards