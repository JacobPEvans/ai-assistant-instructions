# Concept: Vendor-Specific AI Configuration

## The DRY Principle in AgentsMD

This repository is designed to work with multiple AI assistants. To avoid duplicating configurations and to maintain a single source of truth, we follow the
DRY (Don't Repeat Yourself) principle.

- **Canonical Source**: The `agentsmd/` directory is the single source of truth for all workflows, rules, and commands.
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
**[<Link to the relevant file in agentsmd>](<relative-path-to-file>)**
```

### Example: `.copilot/WORKSPACE.md`

```markdown
# Workspace Guidelines

This file provides context on the overall workspace structure and standards.

For detailed information, please refer to the canonical documentation:
**[Workspace Management Concept](./workspace-management.md)**
```

This approach ensures that all AI assistants are working from the same set of instructions, promoting consistency and making the repository easier to maintain.

## Claude Code Directory Structure

The `.claude/` directory uses symlinks to expose `agentsmd/` content to Claude Code:

| Symlink | Target | Effect |
| --- | --- | --- |
| `.claude/agents -> ../agentsmd/agents` | Agent definitions | Agents available as Task subagents |
| `.claude/skills -> ../agentsmd/skills` | Skill definitions | Skills invocable via Skill tool |
| `.claude/rules -> ../agentsmd/rules` | Rule files | All rules auto-load every session |

### Rules Auto-Loading

All `.md` files in `agentsmd/rules/` auto-load as project memory each session. This means:

- New rules added to `agentsmd/rules/` are immediately active — no additional wiring needed
- Keep rules focused and under 1,000 tokens to avoid bloating startup context
- Non-rule files (templates, fill-in content, memory-bank) must NOT live in `agentsmd/rules/`

### File Composition with `@` Imports

In CLAUDE.md and rule files, use `@path/to/file` to compose content inline:

```markdown
@agentsmd/skills-registry.md
```

This imports the file's content at that location. Use it when the referenced content should always
be available in context. Use markdown links only for conditional "see X if relevant"
references where you do NOT want content auto-loaded.
