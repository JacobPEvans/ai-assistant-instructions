# Claude Code Hooks

Automation hooks that run during Claude Code execution to enforce quality standards.

## Available Hooks

### validate-markdown.sh (PostToolUse)

Runs after Write or Edit operations on markdown files. Validates:

- **markdownlint-cli2**: Markdown formatting and structure
- **cspell**: Spelling and terminology

**Trigger**: Automatically after any `.md` file is written or edited.

**Behavior**:

- Exit 0: Validation passed (continues normally)
- Exit 2: Validation failed (blocks and shows errors to Claude)

## Hook Configuration

Hooks are configured in `.claude/settings.json` or `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/validate-markdown.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

## Hook Events

| Event | When It Runs | Use Case |
| ----- | ------------ | -------- |
| PreToolUse | Before tool execution | Block dangerous operations |
| PostToolUse | After tool execution | Validate output |
| Stop | When Claude stops | Final checks |
| SessionStart | When session begins | Environment setup |
| SessionEnd | When session ends | Cleanup |

## Creating New Hooks

1. Create a bash script in this directory
2. Make it executable: `chmod +x your-hook.sh`
3. Read JSON input from stdin using `jq`
4. Exit with appropriate code (0=success, 2=blocking error)
5. Add configuration to settings.json

## Input Format

Hooks receive JSON via stdin:

```json
{
  "session_id": "abc123",
  "cwd": "/path/to/project",
  "hook_event_name": "PostToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.md",
    "content": "..."
  },
  "tool_response": {
    "success": true
  }
}
```

## Testing Hooks

```bash
# View registered hooks
claude /hooks

# Run with debug output
claude --debug

# Test hook script directly
echo '{"tool_input":{"file_path":"test.md"}}' | ./validate-markdown.sh
```

## Dependencies

Hooks require these tools to be available:

- `jq` - JSON parsing
- `markdownlint-cli2` - Markdown linting
- `cspell` - Spell checking
