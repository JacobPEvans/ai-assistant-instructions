# AI Assistant Instructions

## Core Principles

- **Accuracy and Truth**: Prioritize correctness and factual accuracy above all else.
- **Idempotency**: All operations should be repeatable with consistent results.
- **Best Practices**: Follow established industry and project-specific best practices.
- **Clarity**: Ask for clarification when a request is ambiguous or incomplete.
- **No Sycophancy**: Do not cater to bad ideas or prioritize pleasing the user over providing correct and sound advice.

## Multiple AI System Usage

This repository works with multiple AI assistants: GitHub Copilot, Claude, and Gemini.
Each uses its respective configuration directory (`.github/`, `.claude/`, `.gemini/`).

## Core Workflow

This project follows a strict, 5-step development cycle designed to be automated and repeatable:

- **[Step 1: Research and Explore](./workflows/1-research-and-explore.md)**: Read-only phase to understand requirements and codebase
- **[Step 2: Plan and Document](./workflows/2-plan-and-document.md)**: Create locked PRD with implementation checklist
- **[Step 3: Define Success and Create PR](./workflows/3-define-success-and-pr.md)**: Write tests and create pull request
- **[Step 4: Implement and Verify](./workflows/4-implement-and-verify.md)**: Code implementation to pass tests
- **[Step 5: Finalize and Commit](./workflows/5-finalize-and-commit.md)**: Documentation review and cleanup

If any step fails, the cycle must restart from Step 1 after documenting the failure in Step 5.

**CRITICAL**: Documentation review via [Review Documentation](./commands/review-docs.md) - markdown validation workflow - is mandatory before any pull request.

## Core Concepts

- **[Idempotency](./concepts/idempotency.md)**: Operations that can be repeated with consistent results.
- **[The DRY Principle](./concepts/dry-principle.md)**: The "Don't Repeat Yourself" principle for code and documentation.
- **[The Memory Bank](./concepts/memory-bank/README.md)**: Documents that act as the AI's external memory for project context.
- **[AI Tooling](./concepts/ai-tooling.md)**: Best practices for giving AI assistants access to your development environment.
- **[Vendor-Specific Configuration](./concepts/vendor-config-standards.md)**: Standards for creating vendor-specific AI configuration files.
- **[Code Standards](./concepts/code-standards.md)**: Guidelines for writing high-quality, secure, and maintainable code.
- **[Infrastructure Standards](./concepts/infrastructure-standards.md)**: Best practices for managing Infrastructure as Code (IaC).
- **[Documentation Standards](./concepts/documentation-standards.md)**: Rules and formats for creating clear and effective documentation.
- **[Diagramming Standards](./concepts/diagramming-standards.md)**: Best practices for creating diagrams using Mermaid and Graphviz.
- **[Workspace Management](./concepts/workspace-management.md)**: Guidelines for managing a multi-repository workspace.
- **[GitHub Issue Standards](./concepts/github-issue-standards.md)**: Best practices for creating, managing, and linking GitHub issues to PRs.

## Styleguide

Refer to the **[Styleguide](./concepts/styleguide.md)** for:

- Language-specific coding conventions (JavaScript/TypeScript, Python, Markdown)
- AI tools integration patterns
- Code review expectations and focus areas
- **Pull request review guidelines**, including pragmatic approaches to permission and configuration reviews

## Commands

### Core Commands

- **[Pull Request](./commands/pull-request.md)**: Complete PR lifecycle management from creation to merge
- **[Generate Code](./commands/generate-code.md)**: Code generation standards and technology-specific guidelines
- **[Review Code](./commands/review-code.md)**: Structured code review process with priority levels
- **[Review Documentation](./commands/review-docs.md)**: Markdown validation and documentation quality workflow
- **[Review Infrastructure](./commands/infrastructure-review.md)**: Terraform/Terragrunt configuration review checklist

### Issue & PR Lifecycle (rok-* series)

- **[Shape Issues](./commands/rok-shape-issues.md)**: Transform ideas into well-formed GitHub issues
- **[Resolve Issues](./commands/rok-resolve-issues.md)**: Implement shaped issues with prioritization
- **[Review PR](./commands/rok-review-pr.md)**: Comprehensive pull request review
- **[Respond to Reviews](./commands/rok-respond-to-reviews.md)**: Address PR feedback systematically

## When to Use Which Command

Use this table to identify the correct command for your task:

| User Intent | Command | Notes |
| ----------- | ------- | ----- |
| Create a GitHub issue | `/rok-shape-issues` | Always shape before creating |
| Implement an existing issue | `/rok-resolve-issues` | For shaped, ready-for-dev issues |
| Review a pull request | `/rok-review-pr` | Systematic review with priorities |
| Respond to PR feedback | `/rok-respond-to-reviews` | After receiving review comments |
| Create/manage a PR | `/pull-request` | Full lifecycle management |
| Review documentation | `/review-docs` | Markdown linting and validation |
| Review infrastructure code | `/infrastructure-review` | Terraform/Terragrunt focus |

**Important**: When asked to "create an issue" or "open an issue", always use `/rok-shape-issues`
to ensure proper formatting, acceptance criteria, and Shape Up methodology.

## Maintenance

- **Weekly**: Review AI instruction effectiveness and prompt template usage.
- **Monthly**: Validate cross-references, update broken links, and review cost optimization strategies.
- **Quarterly**: Update technology preferences and review security best practices.
