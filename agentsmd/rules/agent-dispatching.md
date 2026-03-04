# Agent Dispatching

When writing prompts for subagents, include explicit tool constraints so agents
use the correct tools instead of falling back to Bash for file operations.

## Required Boilerplate for File-Editing Agents

Every subagent prompt that involves reading, writing, or editing files MUST
include this block verbatim:

```text
File operations:
- Read files with the Read tool
- Edit existing files with the Edit tool
- Create new files with the Write tool
- Never use Bash for reading or writing files (no sed, awk, python -c, cat >, etc.)
```

## Why This Is Necessary

`general-purpose` agents have access to Read/Edit/Write tools, but without
explicit instruction they default to Bash for file modifications. This bypasses
the permission model, produces opaque diffs, and often results in fragile
one-liner hacks instead of clean edits.

The `dispatching-parallel-agents` skill's example prompt template does not
include tool constraints. Always add the boilerplate above to every agent
prompt you author — the skill template is a starting point, not a complete prompt.

## Example

```text
Fix the pagination bug in .github/scripts/check-eligibility.js.

File operations:
- Read files with the Read tool
- Edit existing files with the Edit tool
- Create new files with the Write tool
- Never use Bash for reading or writing files (no sed, awk, python -c, cat >, etc.)

1. Read .github/scripts/check-eligibility.js
2. Replace the direct pulls.list call with github.paginate(...)
3. Return: summary of what changed and why
```

## Scope

This applies to all Agent tool invocations where the subagent will touch files.
Pure research/exploration agents (subagent_type: Explore) are exempt since they
cannot write files.
