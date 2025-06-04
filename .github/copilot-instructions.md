# GitHub Copilot Instructions

Workspace-wide instructions for GitHub Copilot to provide consistent, high quality assistance.

## Core Principles
- **Keep it simple**: Never add unnecessary complexity or configurations that work with defaults
- **DRY (Don't Repeat Yourself)**: Prioritize modularization and reusability. Avoid files with many hundreds of lines.
- **Cost-conscious**: Always prefer cheapest options that meet requirements
- **Security-first**: Input validation, principle of least privilege, and no hardcoded secrets
- **Documentation-driven**: Maintain comprehensive documentation and examples

## Project Documentation Structure

### For Complex Projects (Infrastructure, Multi-module, etc.)
Create `.copilot/` directory with:
- **PROJECT.md**: Project scope, boundaries, change approval workflow
- **ARCHITECTURE.md**: High level architecture decisions
- **README.md**: Usage guidelines

### For All Projects
- **Root README.md**: Purpose, setup instructions, usage examples, cost estimates
- **Directory READMEs**: Explanation for major subdirectories
- **Inline Documentation**: Function/class comments, configuration explanations

### Documentation Requirements
- Include purpose and scope clearly at the top
- Provide step-by-step setup instructions
- Add usage examples and common commands
- Document cost implications for cloud resources
- Maintain current state information for infrastructure
- Include troubleshooting and FAQ sections
- Use emojis sparingly for clarity, not as decoration

## General Guidelines

### Code Quality
- Follow language/framework best practices with descriptive, short names
- Include comprehensive error handling and self-documenting code
- Add inline comments for complex logic; prefer readable over clever code
- Run linting/formatting before committing changes

### Software & Command Management
- Update software and requirements to latest stable versions
- Use chocolatey for Windows package management (uninstall/reinstall if needed)
- Use full file paths when running commands in terminal
- Include auto-approve flags to reduce manual intervention

### Documentation Standards
- The master set of instructions is located in `.github/copilot-instructions.md`
- **AI Context Files**: Create `.copilot/` directory with PROJECT.md and ARCHITECTURE.md
- **README Requirements**: Include purpose, setup instructions, usage examples, and cost estimates
- **Function Documentation**: Add docstrings/comments for all functions and classes
- **Change Documentation**: Document configuration changes and their purpose
- **Project Structure**: Use descriptive folder/file names with README files in major directories
- Avoid double documenting. If a concept is already documented at a higher level, don't document it again

## Technology-Specific Guidelines

### Infrastructure as Code (Terraform/Terragrunt)
- **File patterns**: `*.tf`, `*.tfvars`, `terragrunt.hcl`
- Use Terragrunt for all configurations with S3/DynamoDB state management
- Follow consistent naming, use relative paths, include resource tags
- Use data sources over hardcoded values, principle of least privilege for IAM
- **CRITICAL**: Always commit after successful `terragrunt plan` - NEVER auto-apply
- **NEVER** run `terragrunt apply` automatically (deploys real AWS resources/costs)
- Treat successful plans as version control milestones

### Cloud Platforms (AWS Primary)
- **Preferred Region**: us-east-2
- **Cost Limit**: $20/month maximum per project
- Always estimate monthly costs and choose cheapest viable options
- Follow well-architected principles unless cost prohibitive
- Do not use expensive cloud services (RDS, ELB, etc.) unless specifically requested by user

### Configuration & Scripting
- **Splunk** (`*.conf`, `*.xml`): Follow naming conventions, optimize searches (tstats), document queries
- **PowerShell** (`*.ps1`): Use approved verbs, parameter validation, try/catch blocks, PascalCase
- **Shell Scripts** (`*.sh`): Include shebangs, use `set -euo pipefail`, quote variables
- **Config Files** (`*.json`, `*.yaml`, `*.xml`): 2-space indentation, comments, environment-specific, no secrets

### Security & Compliance
- Use environment variables or secret management (never hardcode secrets)
- Include input validation, security scanning, audit logging
- Consider GDPR/CCPA requirements and data retention policies

### Development & Production
- **Development**: Include testing, debugging tools, VS Code extensions
- **Production**: Focus on availability, monitoring, backup/recovery, security hardening
- **Containerization**: Multi-stage builds, health checks, security scanning

## Git and Version Control
- Use `git mv` for moving or renaming files to maintain proper version control history
- Write clear, descriptive commit messages focusing on actual file changes first
- Use conventional commit prefixes (feat:, fix:, docs:, etc.)
- Update files directly instead of using temp, old, new, or backup files
- Suggest `git commit` after modifying more than 5 files or 100 lines of code
- Include appropriate .gitignore entries

## Workspace-Specific Guidelines

### Homelab Projects
- Focus on learning and experimentation with detailed documentation
- Include automation, infrastructure as code, backup procedures
- Document lessons learned and configuration decisions

### Templates and Reusability
- Create parameterized templates for common configurations
- Document usage, customization options, and maintain version control

---

*Last updated: June 3, 2025*  
*Update as workspace evolves and new technologies are adopted*