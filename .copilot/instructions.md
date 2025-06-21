# GitHub Copilot Custom Instructions

## Development Context
You are working in a multi-repository development environment focused on infrastructure automation,
Claude Code best practices, and system administration.

## Key Technologies
- **Infrastructure**: Terraform, Terragrunt, Proxmox VE
- **AI Assistance**: Claude Code, GitHub Copilot
- **Systems**: Linux, WSL2, Nix, Git
- **Languages**: HCL (Terraform), Bash, Markdown

## Code Style Preferences
- Follow existing patterns and conventions in each repository
- Use descriptive variable names and comprehensive documentation
- Implement proper error handling and validation
- Prioritize security and least-privilege principles

## Infrastructure Guidelines
- Always include version constraints for providers
- Use modules for reusable components
- Implement comprehensive variable validation
- Follow remote state management best practices
- Never hardcode sensitive values

## Documentation Standards
- Maintain comprehensive CLAUDE.md files for AI context
- Use Keep a Changelog format for change tracking
- Include usage examples in all module documentation
- Document security considerations and best practices

## Security Priorities
- Implement secrets management best practices
- Use secure parameter stores for sensitive data
- Enable state encryption and proper access controls
- Validate all inputs and implement defense in depth

Refer to the centralized documentation in `~/CLAUDE.md` for detailed guidelines and current best practices.
