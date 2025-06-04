# AI Assistant Instructions

Comprehensive GitHub Copilot instructions and workspace configurations for consistent, high-quality development
assistance across multiple project types.

## Overview

This repository provides centralized AI instruction management with modular, reusable configurations optimized for
GitHub Copilot integration across VS Code, GitHub web interface, and Visual Studio environments.

## Quick Start

### Using These Instructions

1. **GitHub Copilot Integration**: Instructions are automatically loaded when working in this repository
2. **Cross-Reference Navigation**: Follow links between instruction files for detailed context
3. **Prompt Files**: Use reusable prompt templates in VS Code with Copilot Chat

### Key Files

- **[`.github/copilot-instructions.md`](.github/copilot-instructions.md)**: Main repository-wide AI instructions
- **[`.copilot/PROJECT.md`](.copilot/PROJECT.md)**: Project scope and change management
- **[`.copilot/ARCHITECTURE.md`](.copilot/ARCHITECTURE.md)**: System design decisions  
- **[`.copilot/WORKSPACE.md`](.copilot/WORKSPACE.md)**: Multi-project workspace guidelines

## Architecture

### Modular Design

The project follows a clear hierarchical structure designed for AI optimization and maintainability.  
See [Architecture Details](.copilot/ARCHITECTURE.md) for the complete file structure and design decisions.

### Design Principles

- **AI-Optimized**: Clear hierarchical structure with explicit cross-references
- **Modular**: Separate concerns for maintainability and selective loading
- **GitHub-Compatible**: Follows official Copilot custom instructions best practices
- **Cross-Platform**: Works in VS Code, GitHub web, and Visual Studio

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

### Basic AI Assistance

AI automatically receives context from `.github/copilot-instructions.md` for all interactions:

```text
User: "Create a Terraform module for an S3 bucket"
AI: Uses preferences for AWS us-east-2, cost optimization, security best practices
```

### Detailed Reviews

Use prompt files for comprehensive analysis:

```text
User: "@workspace Use terraform-review.prompt.md to review my infrastructure"
AI: Performs systematic review with cost analysis, security checks, best practices
```

### Project Planning

Reference architecture files for complex decisions:

```text
User: "Help me plan a new homelab project structure"
AI: References .copilot/WORKSPACE.md for standards and patterns
```

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

- Use conventional commit prefixes (`feat:`, `fix:`, `docs:`, `refactor:`)
- Update related files when making cross-cutting changes
- Test instructions with actual AI interactions before finalizing

## Maintenance

### Regular Updates

- **Monthly**: Review instruction effectiveness
- **Quarterly**: Update for new technology adoptions  
- **Annual**: Comprehensive review and optimization

### Quality Metrics

- Consistent code formatting across projects
- Reduced manual intervention in AI workflows
- Cost-effective resource utilization
- Standardized documentation practices

## Support

For questions or improvements:

1. Review existing documentation in `.copilot/` directory
2. Check prompt files for task-specific guidance
3. Create issues for enhancement requests
4. Submit pull requests with clear descriptions

---

*Last updated: June 4, 2025*  
*See [ARCHITECTURE.md](.copilot/ARCHITECTURE.md) for technical implementation details*
