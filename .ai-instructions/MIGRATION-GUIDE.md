# Migration Guide: Command Consolidation

This guide helps users transition from deprecated commands to their replacements.

## Overview

As of v0.9.0 (unreleased), we've consolidated duplicate commands to reduce redundancy and improve clarity.
The rok-* command series from the Shape Up methodology provides more comprehensive, systematic approaches
with better GitHub CLI integration.

## Command Mapping

### Deprecated: `/review-code` → Use: `/rok-review-pr`

**Why the change?**

- `rok-review-pr` includes GitHub CLI integration (`gh pr view`, `gh pr diff`, `gh pr checkout`)
- Systematic 4-phase review workflow (Analysis → Quality Assurance → Code Review → Feedback Delivery)
- Local testing with quality checks (typecheck, tests, build, lint)
- Structured feedback with categorization (Critical/Major/Minor/Enhancement)
- Direct GitHub posting of review comments

**Migration:**

```bash
# Old approach
/review-code

# New approach
/rok-review-pr
```

### Deprecated: `/pull-request` → Use: rok-* workflow

**Why the change?**

The monolithic `/pull-request` command tried to handle the entire PR lifecycle in one step. The rok-* series breaks this into logical phases following Shape Up methodology:

1. **Issue Shaping**: `/rok-shape-issues` - Define appetite, constraints, and scope
2. **Resolution**: `/rok-resolve-issues` - Systematic implementation with GitHub CLI
3. **Review**: `/rok-review-pr` - Comprehensive quality checks
4. **Feedback**: `/rok-respond-to-reviews` - Parallel sub-agent resolution

**Migration:**

```bash
# Old approach
/pull-request

# New approach - Complete lifecycle
/rok-shape-issues      # Define the problem with appetite
/rok-resolve-issues    # Implement and create PR
/rok-review-pr         # Review the PR
/rok-respond-to-reviews # Address feedback
```

### Deprecated: `/pull-request-review-feedback` → Use: `/rok-respond-to-reviews`

**Why the change?**

- `rok-respond-to-reviews` includes parallel sub-agent coordination for independent comments
- Enhanced with kieranklaassen's parallel processing patterns
- Priority-based resolution (Critical → Major → Minor → Enhancement)
- Automatic GitHub thread resolution via GraphQL
- Token-efficient comment retrieval with `jq` filtering

**Migration:**

```bash
# Old approach
/pull-request-review-feedback

# New approach
/rok-respond-to-reviews
```

**Key improvements:**

- Parallel processing: Multiple agents can fix independent comments simultaneously
- GraphQL integration: Automatically marks review threads as resolved
- Smarter API usage: Only retrieves unresolved comments to save tokens

### Deprecated: `/generate-code` → Use: Implementation Workflows

**Why the change?**

The `/generate-code` command was too generic and didn't provide enough structure. Code generation is now handled by:

1. **Workflow Step 4**: [Implement and Verify](./workflows/4-implement-and-verify.md) provides systematic implementation guidance
2. **Code Standards**: [Code Standards](./concepts/code-standards.md) document best practices
3. **Agent OS patterns**: External frameworks like Agent OS provide structured spec-driven development

**Migration:**

```bash
# Old approach
/generate-code

# New approach - Follow the 5-step workflow
# Step 1: Research and Explore
# Step 2: Plan and Document (create PRD)
# Step 3: Define Success and Create PR (write tests)
# Step 4: Implement and Verify (generate code)
# Step 5: Finalize and Commit
```

**For external frameworks:**

- Consider [Agent OS](https://buildermethods.com/agent-os) for spec-driven development
- Use `implement-tasks` agent for structured implementation
- Follow the PRD → Tests → Implementation pattern

## Quick Reference

| Deprecated Command | Replacement | Primary Benefit |
| ------------------ | ----------- | --------------- |
| `/review-code` | `/rok-review-pr` | GitHub CLI integration, systematic workflow |
| `/pull-request` | rok-* series | Shape Up methodology, phased approach |
| `/pull-request-review-feedback` | `/rok-respond-to-reviews` | Parallel sub-agents, GraphQL thread resolution |
| `/generate-code` | Workflow Step 4 + Code Standards | Structured implementation, not generic |

## Complete Development Lifecycle

The rok-* commands form a complete development lifecycle:

```text
Problem → Shape → Resolve → Review → Respond → Merge

1. /rok-shape-issues      - Define problem with appetite and constraints
2. /rok-resolve-issues    - Systematic implementation and PR creation
3. /rok-review-pr         - Comprehensive quality review
4. /rok-respond-to-reviews - Efficient feedback resolution
```

## Remaining Core Commands

These commands remain unchanged:

- `/commit` - Standardized git commit process with validation
- `/review-docs` - Markdown validation with markdownlint
- `/infrastructure-review` - Terraform/Terragrunt review checklist

## Timeline

- **v0.8.0** (2025-12-03): All commands available
- **v0.9.0** (TBD): Commands consolidated, deprecated commands removed
- **Migration period**: None required - old commands have been removed

## Questions?

If you have questions about the migration or need help adapting your workflows, please:

1. Review the [rok-* command documentation](./commands/)
2. Check the [5-step workflow](./workflows/) for implementation guidance
3. Open an issue on GitHub for specific questions

---

*This migration guide is part of the command consolidation effort to reduce duplication and improve clarity in AI assistant instructions.*
