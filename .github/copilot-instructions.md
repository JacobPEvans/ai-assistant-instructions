# GitHub Copilot Instructions

Repository-wide instructions for consistent, high-quality AI assistance across all workspace projects.

## Technology Preferences

Use Terraform with Terragrunt for all infrastructure deployments, not CloudFormation or other alternatives.

For cloud deployments, prefer AWS us-east-2 region and maintain cost budgets under $20/month per project.

Use conventional commit prefixes: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.

## Code Quality Standards

Follow language-specific best practices with descriptive, concise naming conventions.

Avoid backup, temp, old, and new type file names. Delete these kinds of files if observed.

Include comprehensive error handling and prefer readable code over clever implementations.

Keep line length under 120 characters when linters indicate line length requirements.

Run formatting and linting before committing: `terraform fmt`, `terragrunt hclfmt`, `markdownlint`.

## Documentation and Diagrams

Use Mermaid for all diagrams (flowcharts, workflows, sequence diagrams) with proper language tags.

Use GraphViz (DOT) only for complex network topologies when Mermaid becomes inadequate.

Write documentation at US middle/high school reading level with clear setup instructions.

Include working code examples with proper syntax highlighting and language tags.

Provide cost estimates for cloud resources and usage examples.

Reference detailed guidelines in [.copilot/ directory](../.copilot/PROJECT.md) for complex topics.

## Security Requirements

Never hardcode secrets - use environment variables or cloud secret management services.

Apply principle of least privilege for all IAM policies and resource access.

Include input validation for all user-facing interfaces and APIs.

Enable encryption at rest and in transit for all data storage and transmission.

## Git Workflow

Use conventional commit prefixes and follow established branching standards.

For detailed git commit, pull request, and workflow guidelines, see: `.github/prompts/git-workflow.prompt.md`

## Cost Management

Estimate monthly costs before deploying cloud resources and choose cheapest viable options.

Prefer free tier and cost-optimized services unless specific requirements justify premium options.

Document cost justifications for resources exceeding $5/month.

## Context References

For detailed guidelines, see:
- [Project Overview](../.copilot/PROJECT.md) - Scope, boundaries, and change management
- [Architecture Details](../.copilot/ARCHITECTURE.md) - Technical decisions and system design  
- [Workspace Management](../.copilot/WORKSPACE.md) - Multi-project coordination

For task-specific guidance, use prompt files:

- Git workflows: `.github/prompts/git-workflow.prompt.md`
- Infrastructure reviews: `.github/prompts/infrastructure-review.prompt.md`
- Security assessments: `.github/prompts/security-review.prompt.md`  
- Documentation validation: `.github/prompts/documentation-check.prompt.md`