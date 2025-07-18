# Concept: Documentation Standards

This document outlines the universal standards for writing clear and effective documentation.

## General Principles

- **Clarity**: Write for a US middle/high school reading level.
- **Accuracy**: Ensure documentation is always up-to-date with the code.
- **Completeness**: Include setup instructions, configuration options, and working examples.

## Formatting

- **Markdown**: Use standard Markdown syntax.
- **Code Blocks**: Use proper syntax highlighting for all code examples.
- **Linking**: Link to other relevant documents instead of repeating information, following the [DRY Principle](./dry-principle.md).
- **Hierarchical Numbering**: Use nested numbers (e.g., 1., 1.1., 1.1.1.) for lists. This gives AI agents a clear, trackable structure to follow.
  When possible, implement workflows as steps with tasks and subtasks.
- **Conciseness**: Keep documentation as short as possible while still conveying all critical information. These files are for AI first, humans second.

## Linting and Validation

To maintain a consistent and readable format, all Markdown files are validated using `markdownlint-cli2`.
This is enforced automatically before each commit using `pre-commit`.

### Pre-commit Hook

The project includes a `.pre-commit-config.yaml` file that configures `markdownlint-cli2` to run on all `.md` files.
This ensures that any file that violates the rules defined in `.markdownlint.json` cannot be committed.

### Local Setup

To enable this pre-commit hook on your local machine, follow these steps:

1. **Install pre-commit**:

   ```bash
   pip install pre-commit
   ```

2. **Set up the Git hooks**:

   ```bash
   pre-commit install
   ```

Once installed, the hook will run automatically when you attempt to commit changes.
If any markdown files fail validation, the commit will be aborted, and you will see a list of the errors that need to be fixed.
