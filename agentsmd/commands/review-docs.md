---
description: Review documentation files for consistency, completeness, and markdownlint compliance
model: sonnet
author: JacobPEvans
allowed-tools: Task, TaskOutput, Bash(markdownlint-cli2:*), Read, Grep, Glob, TodoWrite
---

# Prompt: Review Documentation

**CRITICAL**: Documentation review is mandatory before any pull request. All markdownlint issues must be resolved to pass CI/CD.

Review the project's documentation files (`.md`) for consistency, completeness, and clarity.

## External References

* [Official markdownlint-cli2 documentation](https://github.com/DavidAnson/markdownlint-cli2)

## Workflow

1. **Discovery Phase**:
    * Use `@**/*.md` to reference all markdown files in Claude Code
    * Run `find . -name "*.md" -type f` to get complete file list
    * Identify documentation gaps by comparing against code structure
    * Reference specific files: "Review @README.md for accuracy"
    * Check documentation hierarchy: "Analyze @agentsmd/ structure"

2. **Automated Fixes (REQUIRED FIRST STEP)**:
    * **ALWAYS run auto-fix first**: `markdownlint-cli2 --fix .`
    * This resolves many issues automatically before manual review
    * Run `markdownlint-cli2 .` to check remaining formatting issues
    * Run `cspell "**/*.md"` to check for spelling errors
    * Use `rg "TODO|FIXME|XXX" **/*.md` to find incomplete sections
    * Check for broken links: `markdown-link-check **/*.md` (if available)

3. **Markdownlint Standards (CRITICAL)**:
    * **MD013**: Maximum line length is 160 characters
      * Preserve sentence integrity when fixing violations
      * Never break words mid-character or split natural phrases
    * All other markdownlint rules must pass
    * Fix existing violations before creating pull requests
    * Configuration in `.markdownlint.json` sets MD013 to 160 characters

4. **Content Quality Verification**:
    * Is the documentation accurate and up-to-date with the current codebase?
    * Is the purpose of the project and its components clearly explained?
    * Are there clear, step-by-step instructions for setup and usage?
    * Are code examples correct and easy to follow?
    * Cross-reference code: "Verify @src/components/ matches documentation"
    * Test documented commands and workflows (e.g., `make test`, `npm test`, `terraform apply`, etc.)

5. **Project Standards Compliance**:
    * Follow [Documentation Standards](./../rules/documentation-standards.md)
    * Use hierarchical numbering (1., 1.1., 1.1.1.) for AI-trackable structure
    * Ensure AI-first writing (concise, structured)
    * Verify adherence to [DRY Principle](./../rules/dry-principle.md)
    * Link to other documents instead of repeating information

6. **AI-Friendly Formatting**:
    * Use clear, hierarchical headings
    * Use proper markdown syntax for code blocks, lists, and links
    * Use descriptive link text (e.g., "Conventional Commits standard" instead of "click here")
    * Structure content for AI consumption with numbered steps and subtasks

7. **Memory Bank Integration**:
    * Update [Technical Context](./../rules/memory-bank/technical-context.md) if needed
    * Sync [Project Brief](./../rules/memory-bank/project-brief.md) with changes
    * Maintain [Progress Tracking](./../rules/memory-bank/progress-tracking.md)

8. **Link Validation**:
    * Check that all internal and external links are valid and point to the correct location
    * Verify relative paths work correctly from their source location

## Critical Requirements

**BEFORE ANY PULL REQUEST**:

1. All markdownlint issues MUST be resolved
2. Auto-fix MUST be attempted first: `markdownlint-cli2 --fix .`
3. MD013 line length MUST NOT exceed 160 characters
4. All broken or incomplete sentences around 80-character boundaries MUST be fixed
