# AI Assistant Instructions

Comprehensive AI assistant instructions combining GitHub Copilot and Claude Code workflows for consistent, high-quality development assistance across multiple project types.

## Overview

This repository provides centralized AI instruction management with modular, reusable configurations optimized for both GitHub Copilot and Claude Code integration. Features dual AI system compatibility with standardized workflows, security scanning, and cost-conscious development practices.

## Quick Start

### Using These Instructions

1. **GitHub Copilot Integration**: Instructions are automatically loaded when working in this repository
2. **Claude Code Workflows**: Execute standardized commands like `/commit` for comprehensive development processes
3. **Cross-Reference Navigation**: Follow links between instruction files for detailed context
4. **Prompt Files**: Use reusable prompt templates in VS Code with Copilot Chat or Claude Code

### Key Files

#### GitHub Copilot Integration

- **[`.github/copilot-instructions.md`](.github/copilot-instructions.md)**: Main repository-wide AI instructions
- **[`.github/prompts/`](.github/prompts/)**: Reusable prompt templates for specific tasks

#### Claude Code Workflows

- **[`.claude/CLAUDE.md`](.claude/CLAUDE.md)**: Claude Code documentation standards and best practices
- **[`.claude/settings.json`](.claude/settings.json)**: Permissions and tool configurations
- **[`.claude/commands/commit.md`](.claude/commands/commit.md)**: 6-step commit workflow with validation

#### Project Context

- **[`.copilot/PROJECT.md`](.copilot/PROJECT.md)**: Project scope and change management
- **[`.copilot/ARCHITECTURE.md`](.copilot/ARCHITECTURE.md)**: System design decisions  
- **[`.copilot/WORKSPACE.md`](.copilot/WORKSPACE.md)**: Multi-project workspace guidelines

## Architecture

### Dual AI System Design

The project integrates two complementary AI assistant systems for comprehensive development workflow coverage:

- **GitHub Copilot**: Real-time coding assistance with repository-wide context
- **Claude Code**: Standardized workflow automation with comprehensive validation
- **Shared Standards**: Unified coding practices and documentation requirements across both systems

See [Architecture Details](.copilot/ARCHITECTURE.md) for the complete file structure and design decisions.

### Design Principles

- **AI-Optimized**: Clear hierarchical structure with explicit cross-references
- **Modular**: Separate concerns for maintainability and selective loading
- **Cross-Platform Compatible**: Works across VS Code, GitHub web interface, Visual Studio, and Claude Code CLI
- **Security First**: Comprehensive validation, security scanning, and cost management
- **Workflow Automation**: 6-step commit process with automated documentation updates

## Target Environment

### Multi-Project Workspace

Supports development across diverse project types:

- **Infrastructure**: Terraform/Terragrunt for AWS deployments
- **Homelab**: Physical infrastructure automation and documentation  
- **Applications**: Splunk templates, development tools, scripts
- **CI/CD**: GitHub Actions workflows and automation

### Technology Stack

Optimized for cost-conscious cloud development with standardized tooling.  
See [Workspace Guidelines](.copilot/WORKSPACE.md) for complete technology requirements and versions.

## Usage Examples

### Real-Time Coding Assistance

AI automatically receives context from `.github/copilot-instructions.md` for all interactions:

```text
User: "Create a Terraform module for an S3 bucket"
Copilot: Uses preferences for AWS us-east-2, cost optimization, security best practices
```

Use prompt files for comprehensive analysis:

```text
User: "@workspace Use infrastructure-review.prompt.md to review my infrastructure"
Copilot: Performs systematic review with cost analysis, security checks, best practices
```

### Standardized Development Workflows

Execute standardized development processes:

```text
User: /commit
Claude: Runs 6-step validation process including security scanning, documentation updates, PR creation
```

```text
User: "Help me plan a new homelab project structure"
Claude: References .copilot/WORKSPACE.md and .claude/CLAUDE.md for standards and patterns
```

### Cross-System Benefits

Both AI systems share the same preferences and standards:

- **Cost Management**: AWS us-east-2 region preference with budget guidelines
- **Security**: Comprehensive scanning for secrets, SSH keys, and sensitive data  
- **Documentation**: Automated CHANGELOG.md updates with calendar versioning
- **Code Quality**: Terraform/Terragrunt validation and formatting standards

## Cost Considerations

### Budget Guidelines

- **Development environments**: $5/month maximum
- **Testing/staging**: $10/month with approval
- **Production/learning**: $20/month with justification
- **Experimental**: $2/month, 7-day maximum lifespan

### Cost Management

- Always estimate monthly costs before deployment
- Prefer free tier and cost-optimized services
- Document cost justifications for premium resources
- Regular cost review and optimization

## Contributing

### File Modification Guidelines

1. **Main Instructions**: Changes require validation against GitHub best practices
2. **Context Files**: Document rationale and update cross-references
3. **Prompt Files**: Include usage examples and test before committing

For complete setup and implementation details, see [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md).

### Review Process

- **Claude Code Workflow**: Use `/commit` command for comprehensive 6-step validation process
- **Conventional Commits**: Automatic generation of proper commit prefixes (`feat:`, `fix:`, `docs:`, `refactor:`)
- **Cross-Reference Updates**: Automated detection and updating of related files
- **Validation**: Comprehensive security scanning, markdown linting, and infrastructure validation
- **Documentation**: Automatic CHANGELOG.md updates with calendar versioning

## Maintenance

### Regular Updates

- **Monthly**: Review instruction effectiveness
- **Quarterly**: Update for new technology adoptions  
- **Annual**: Comprehensive review and optimization

### Quality Metrics

- **Automated Validation**: 6-step commit process with comprehensive security scanning
- **Consistent Formatting**: Automated code formatting and markdown linting across projects
- **Cost Optimization**: Built-in AWS cost awareness and resource optimization
- **Security Compliance**: Pre-commit scanning for sensitive data and infrastructure validation
- **Documentation Standards**: Calendar versioning with automated CHANGELOG.md updates
- **Dual AI Integration**: Seamless operation across GitHub Copilot and Claude Code systems

## Support

For questions or improvements:

1. Review existing documentation in `.copilot/` directory
2. Check prompt files for task-specific guidance
3. Create issues for enhancement requests
4. Submit pull requests with clear descriptions

---

*Last updated: June 22, 2025*  
*See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) for complete setup details and [ARCHITECTURE.md](.copilot/ARCHITECTURE.md) for technical implementation*
