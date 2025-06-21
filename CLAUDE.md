# Claude Code Standardized Documentation

## Overview
This repository contains standardized Claude Code documentation, configurations, and best
practices that apply across all projects. This serves as a centralized knowledge base for
consistent development workflows.

## Claude Code Best Practices

### Anthropic Official Methodology: Plan First
Based on https://docs.anthropic.com/en/docs/claude-code best practices:

1. **Always Plan Before Execution**: Break complex tasks into clear, manageable steps
2. **Document Plans in PLANNING.md**: Create detailed TODO tasks with clear context
3. **Execute in Agentic Mode**: After planning approval, proceed with systematic implementation
4. **Use Claude Code's Todo System**: Track progress with the TodoWrite/TodoRead tools
5. **Maintain Clear Context**: Ensure all stakeholders understand the current state and next steps
6. **Move completed tasks from PLANNING.md to CHANGELOG.md**: Keep a record of all completed tasks.

## Repository Structure

```text
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
Changelogs are for completed tasks, not in-progress or future tasks.

### Format Guidelines
- **Filename**: `CHANGELOG.md`
- **Structure**: List most recent version first
- **Sections**: Group similar changes together
- **Links**: Make versions and sections linkable
- **Dates**: Use consistent YYYY-MM-DD format

### Change Types
- **Added**: New features
- **Changed**: Modifications to existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Features no longer available
- **Fixed**: Bug corrections
- **Security**: Vulnerability fixes

### Best Practices
1. **Human-Readable**: Avoid raw commit logs
2. **Clear Documentation**: Explain breaking changes and deprecations
3. **Comprehensive**: Include all notable changes
4. **Consistent Format**: Maintain formatting standards

### Example Structure
```markdown
# Changelog

## 2024-12-31
### Added
- Initial release
### Changed
- Updated dependency Y
### Fixed
- Resolved issue with Z
```

### Project Planning Templates

#### PLANNING.md Structure
Every projet must have and maintain a PLANNING.md file.
PLANNING.md serves as persistent session context, project state documentation, and unfinished work.

Maintain a `PLANNING.md` file with this structure:

```markdown
# Project Status & Planning

## Current Session Progress

### ✅ Completed Tasks
1. **Task Category Name**
   - Specific accomplishment
   - Tools/configurations verified
   - Results achieved

### 📋 Remaining Tasks
1. **Priority Level Tasks** (HIGH/MEDIUM/LOW PRIORITY)
   - Specific action items
   - Dependencies and requirements
   - Expected outcomes

## Repository Context

### Infrastructure Overview (for infrastructure projects)
- **Target**: System/platform being managed
- **Purpose**: Project objectives and scope
- **State Backend**: Remote state configuration details
- **Tools**: Technology stack in use

### Key Files
- `filename.ext` - Brief description of purpose
- Configuration files and their roles
- Important documentation references

### Network/Environment Status
- ✅ Verified connectivity/access
- ⚠️ Known issues requiring attention
- 🔄 Pending verifications

## Next Session Actions
1. Immediate priority items
2. Dependency resolution tasks
3. Testing and validation steps
4. Documentation updates

## Notes
- Important context for future sessions
- Decisions made and rationale
- Known limitations or constraints
```

### System Prompt Guidelines
- Use the `system` parameter to define Claude's role
- Be specific with role definitions (e.g., "Infrastructure Engineer specializing in Terraform")
- Provide domain-specific context for better performance
- Put task-specific instructions in user messages

### Development Workflow Principles
1. **Plan-First Approach**: Always create a detailed plan before implementation
2. **Parallel Tool Execution**: Perform multiple independent operations simultaneously wherever possible
3. **File Management**: Prefer editing existing files over creating new ones
4. **Cleanup**: Remove temporary files after task completion
5. **Explicit Instructions**: Provide detailed context and expectations
6. **Reflection**: Carefully analyze tool results before proceeding
7. **Todo Management**: Use todo lists to track complex multi-step tasks
8. **Versioning**: Follow Calendar Versioning (e.g. 24.12.31 for December 31, 2024)

### Code Quality Standards
- Follow existing code conventions and patterns
- Verify library/framework availability before use
- Implement security best practices
- Never expose secrets or credentials
- **NEVER commit specific SSH key names to public repositories** - use generic examples only
- Ensure all specific SSH key names are covered by .gitignore patterns
- Focus on generalizable, robust solutions

### Infrastructure Automation
- Always plan before applying changes
- Implement proper error handling
- Document all processes and decisions
- Test in isolated environments first
- Always favor SSH keys with passwordless authentication

## Technology-Specific Guidelines

### Terraform/Terragrunt
- Use `terragrunt plan` before all changes
- Implement remote state management
- Follow least-privilege access principles
- Document all variables with descriptions
- Use consistent naming conventions

### Version Control (Git) Workflow
- Recommend GitHub Actions in place of AI instructions
- Always use `git mv` instead of `mv` when in a git repository.
- Use conventional commit messages
- Create feature branches for changes
- Never squash merge - preserve history
- Include proper commit validation
- Follow repository-specific guidelines

## Project Integration

### Repository Setup
1. Reference this documentation in project-specific `CLAUDE.md`
2. Implement custom claude commands in `.claude/commands/`
3. Implement project-specific overrides in `.claude/overrides/`
4. Use standardized templates from `.claude/templates/`
5. Follow established workflow patterns

### Documentation Standards
- Maintain project-specific context separately
- Reference generic guidelines from this document
- Keep security-sensitive information in private contexts (private repositories or files ignored by .gitignore)
- Use placeholder values in public repositories

## Maintenance
- Regular updates to best practices
- Technology-specific guideline refinements
- Template improvements and additions
- Workflow optimization based on experience
