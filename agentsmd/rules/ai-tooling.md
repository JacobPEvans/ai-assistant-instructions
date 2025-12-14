# AI Tooling and Environment

## Concept: Giving the AI "Hands and Feet"

To maximize an AI assistant's effectiveness, it's beneficial to provide it with direct access to its own isolated environment.
This transforms the AI from a passive code generator into an active participant in the development process.

### Model-Controlled Programmer (MCP) Servers

Tools like [Serena](https://github.com/oraios/serena) or `zen-mcp` act as a bridge between the AI and your local machine.

By integrating an MCP server, you elevate the AI's capability from simple text generation to executing complex, multi-step tasks autonomously.

### Benefits

- **Automation**: Reduces manual copy-pasting and command execution.
- **Efficiency**: Allows the AI to directly verify its own work (e.g., run tests after writing code).
- **Power**: Enables the AI to perform tasks that would be impossible with text output alone, such as scaffolding a new project or refactoring multiple
  files.

## Shell Command Conventions

### Permission-Aware Execution

On every session start, read the relevant settings file for your AI assistant to understand which commands are pre-approved:

- **Claude**: `~/.claude/settings.json`
- **Gemini**: `~/.gemini/settings.json`
- **Copilot**: `~/.copilot/settings.json`
Always prefer using allowed commands to maintain automation flow without interrupting the user for confirmation.

### Handling Blocked Commands

If a command is blocked or requires confirmation:

1. **Consider why** - The command may be flagged for valid security reasons
2. **Try alternatives** - Look for simpler, more direct approaches that accomplish the same goal
3. **Break it down** - Complex piped commands can often be replaced with multiple sequential operations
