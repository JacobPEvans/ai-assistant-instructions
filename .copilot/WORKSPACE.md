# Workspace Guidelines

> **Navigation**: [Project Overview](../README.md) → [Architecture Details](ARCHITECTURE.md) → **Workspace Guidelines**

## Multi-Project Workspace Management

This document provides guidelines for managing the multi-repository workspace that contains various project types including:

* Homelab infrastructure
* Cloud deployments
* Development tools

## Cross-Project Standards

### Documentation Requirements

Each project must maintain:

1. **README.md** at root level with:
   * Purpose and scope statement
   * Quick start instructions
   * Usage examples
   * Cost implications (for cloud resources)

2. **Directory structure documentation** for complex projects

3. **Change logs** for significant modifications

### Git Workflow Standards

#### Branch Management

* **main**: Production-ready code only
* **feature/**: Feature development branches
* **experiment/**: Learning and testing (delete after completion)

#### Commit Standards

```bash
# Conventional commit format
feat: add new Terraform module for VPC configuration
fix: resolve UniFi backup decryption issue
docs: update homelab network documentation
refactor: simplify Splunk search configuration
```

#### Cross-Project Dependencies

When changes in one project affect others:

1. Document the dependency in both projects' README files
2. Use git submodules for shared configurations
3. Maintain compatibility matrices for version dependencies

### Security Standards

#### Secrets Management

* **Local Development**: Use `.env` files (never committed)
* **Cloud Resources**: AWS Systems Manager Parameter Store
* **Shared Secrets**: Centralized secret management with role-based access

#### Access Control

* **Infrastructure**: Principle of least privilege for all resources
* **Development**: Personal access tokens with limited scope
* **Production**: Role-based access with MFA requirements

### Cost Management

#### Cloud Resource Guidelines

| Service Type | Monthly Budget | Approval Required |
|--------------|----------------|-------------------|
| Development | $5 | No |
| Testing | $10 | Project lead |
| Production | $20 | Documented justification |
| Learning/Experimental | $2 | No |

#### Resource Lifecycle

* **Development**: Automatic shutdown after business hours
* **Testing**: Manual cleanup after feature completion
* **Production**: Scheduled backups and monitoring
* **Experimental**: Maximum 7-day lifespan

## Technology Integration

### Shared Tools and Configurations

#### Common Dependencies

* **Terraform**: Version 1.5+ for all infrastructure projects
* **PowerShell**: Version 7+ for Windows automation
* **Python**: Version 3.9+ for scripting and automation
* **Node.js**: Version 18+ for web development projects

### Development Environment Setup

#### Required Tools

1. **Version Control**: Git with GitHub CLI
2. **Code Editor**: VS Code with recommended extensions
3. **Infrastructure**: Terraform, Terragrunt
4. **Cloud CLI**: AWS CLI with appropriate profiles
5. **Package Managers**: Chocolatey (Windows), Homebrew (macOS)

#### Recommended VS Code Extensions

```text
# Infrastructure
HashiCorp.terraform

# Git and GitHub
GitHub.vscode-github-actions
GitHub.copilot
GitHub.copilot-chat

# PowerShell
ms-vscode.powershell

# General
ms-vscode.vscode-json
redhat.vscode-yaml
```

## Project Lifecycle Management

### New Project Creation

1. **Repository Setup**
   * Initialize with appropriate .gitignore when relevant
   * Create README.md with project template
   * Add LICENSE file (consistent across workspace)

2. **Documentation Structure**
   * Main README.md with project overview
   * docs/ directory for detailed documentation
   * .copilot/ directory for AI context (if complex project)

3. **Development Environment**
   * Add to workspace configuration
   * Configure project-specific VS Code settings
   * Set up automated testing and validation

### Project Maintenance

#### Regular Tasks

* **Weekly**: Review and merge dependabot updates
* **Monthly**: Update documentation and remove unused resources
* **Quarterly**: Review and optimize costs, update dependencies

#### Health Checks

* All tests passing in CI/CD pipelines
* Documentation current and accurate
* No security vulnerabilities in dependencies
* Cost usage within defined budgets

### Project Retirement

1. **Documentation**: Update README with retirement notice and replacement information
2. **Resources**: Clean up all cloud resources and cancel subscriptions
3. **Archives**: Move to archive directory with final state documentation
4. **Dependencies**: Update any projects that reference retired project

## Integration with AI Assistant Instructions

### Context Sharing

Projects reference the main AI instruction repository for:

* Coding standards and best practices
* Documentation formatting requirements
* Security and compliance guidelines
* Cost management principles

### Project-Specific Instructions

Complex projects may maintain their own `.copilot/` directories with:

* Project-specific architectural decisions
* Technology stack rationale
* Custom workflow requirements
* Integration points with other workspace projects

---

*For overall project context, see [PROJECT.md](PROJECT.md)*
*For technical architecture, see [ARCHITECTURE.md](ARCHITECTURE.md)*
