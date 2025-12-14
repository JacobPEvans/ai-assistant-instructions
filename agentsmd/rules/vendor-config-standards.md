# Concept: Vendor-Specific AI Configuration

## The DRY Principle in AI Instructions

This repository is designed to work with multiple AI assistants. To avoid duplicating instructions and to maintain a single source of truth, we follow the
DRY (Don't Repeat Yourself) principle.

- **Canonical Source**: The `.ai-instructions/` directory is the single source of truth for all workflows, concepts, and commands.
- **Vendor Directories**: Directories like `.copilot/`, `.claude/`, or `.github/` are for vendor-specific configuration. They should **not** contain duplicated
  content.

## Standard Format for Vendor Files

Files within a vendor-specific directory (e.g., `.copilot/WORKSPACE.md`) must adhere to a strict, standardized format. Their only purpose is to point to the
canonical documentation.

### Format

```markdown
# <Title of the Concept>

This file provides context on <concept>.

For detailed information, please refer to the canonical documentation:
**[<Link to the relevant file in .ai-instructions>](<relative-path-to-file>)**
```

### Example: `.copilot/WORKSPACE.md`

```markdown
# Workspace Guidelines

This file provides context on the overall workspace structure and standards.

For detailed information, please refer to the canonical documentation:
**[Workspace Management Concept](../../.ai-instructions/concepts/workspace-management.md)**
```

This approach ensures that all AI assistants are working from the same set of instructions, promoting consistency and making the repository easier to maintain.
