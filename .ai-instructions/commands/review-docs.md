# Prompt: Review Documentation

Review the project's documentation files (`.md`) for consistency, completeness, and clarity.

## Workflow

1.  **Automated Checks**:
    - Run `markdownlint-cli2 .` to check for formatting issues.
    - Run `cspell "**/*.md"` to check for spelling errors.
2.  **Content Quality**:
    - Is the documentation accurate and up-to-date with the current codebase?
    - Is the purpose of the project and its components clearly explained?
    - Are there clear, step-by-step instructions for setup and usage?
    - Are code examples correct and easy to follow?
3.  **AI-Friendly Formatting**:
    - Use clear, hierarchical headings.
    - Use proper markdown syntax for code blocks, lists, and links.
    - Use descriptive link text (e.g., "Conventional Commits standard" instead of "click here").
4.  **Link Validation**:
    - Check that all internal and external links are valid and point to the correct location.
