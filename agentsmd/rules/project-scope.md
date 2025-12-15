# AI Assistant Instructions Project

## Project Overview

This repository contains comprehensive AI assistant instructions and workspace configurations designed to provide
consistent, high-quality assistance across multiple development environments and project types.

## Project Scope

### Primary Purpose

- Centralized AI instruction management for development workflows
- Standardized coding practices and documentation requirements
- Reusable templates and configurations for various project types

### Target Environments

- **Infrastructure Projects**: Infrastructure automation and deployment
- **Cloud Infrastructure**: Cloud deployments with cost-conscious approach
- **Development Tools**: IDE configurations and development templates
- **Documentation Systems**: Consistent markdown standards, AI-friendly formatting

### Project Boundaries

#### What's Included

- GitHub Copilot custom instructions and prompt files
- Workspace-specific coding standards and best practices
- Technology-agnostic guidelines for common development patterns
- Security and compliance requirements
- Cost management principles for cloud resources

#### What's Excluded

- Production secrets or sensitive configuration data
- Large binary files or application-specific data
- Temporary or experimental configurations without documentation

## Change Approval Workflow

### File Modification Guidelines

1. **`.github/copilot-instructions.md`**: Core repository-wide instructions
   - Changes require validation against GitHub Copilot best practices
   - Must maintain compatibility with VS Code, GitHub web interface, and Visual Studio

2. **`.copilot/` Directory**: Symlinks to `.ai-instructions/` for Copilot integration
   - All files are symlinks pointing to canonical sources in `.ai-instructions/`
   - Changes should be made in `.ai-instructions/`, not in vendor directories

3. **`.github/prompts/`**: Reusable prompt templates
   - New prompts must include clear purpose and usage examples
   - Test prompts before committing to ensure expected behavior

### Review Process

- All changes should be committed with descriptive commit messages
- Use conventional commit prefixes: `feat:`, `fix:`, `docs:`, `refactor:`
- Document breaking changes in commit messages and update related files

## Integration Points

### Referenced Files

- [Architecture Overview](architecture.md) - High-level system design decisions
- [Workspace Guidelines](workspace-management.md) - Multi-project workspace management
- [Main Instructions](../INSTRUCTIONS.md) - Primary AI instruction file

### External Dependencies

- GitHub Copilot service compatibility
- VS Code workspace settings and extensions
- Git workflow integration with GitHub CLI

## Success Metrics

### Quality Indicators

- Consistent code formatting across all projects
- Reduced manual intervention in AI-assisted development
- Standardized documentation across project types
- Cost-effective cloud resource utilization

### Maintenance Schedule

- Monthly review of instruction effectiveness
- Quarterly updates for new technology adoptions
- Annual comprehensive review and optimization

---

*See [architecture.md](architecture.md) for technical implementation details*
