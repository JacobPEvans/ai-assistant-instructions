#!/usr/bin/env python3
"""
Claude Code PreToolUse hook for GitHub issue creation limits.
Blocks `gh issue create` when issue limits are exceeded.

Limits:
  - 50 total open issues: Hard block
  - 25 AI-created issues: Hard block

Exit codes:
  0 = allow the command
  2 = block the command (shows stderr to Claude)

Input: JSON from stdin with tool_input.command containing the Bash command
"""

import json
import subprocess
import sys


def count_issues(label: str | None = None) -> int:
    """Count open issues, optionally filtered by label."""
    cmd = ["gh", "issue", "list", "--state", "open", "--json", "number"]
    if label:
        cmd.extend(["--label", label])

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            return 0
        issues = json.loads(result.stdout)
        return len(issues)
    except (subprocess.TimeoutExpired, subprocess.SubprocessError, json.JSONDecodeError):
        return 0


def main() -> int:
    # Read hook input from stdin
    try:
        hook_input = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0  # Invalid input, allow

    # Get the command being executed
    command = hook_input.get("tool_input", {}).get("command", "")

    # Only act on gh issue create commands
    if "gh issue create" not in command:
        return 0

    # Count issues
    total = count_issues()
    ai_created = count_issues("ai-created")

    # Check limits
    blocked = False
    reasons = []

    if total >= 50:
        blocked = True
        reasons.append(f"Total issues: {total}/50 (limit reached)")

    if ai_created >= 25:
        blocked = True
        reasons.append(f"AI-created issues: {ai_created}/25 (limit reached)")

    if blocked:
        print("\n" + "=" * 64, file=sys.stderr)
        print("BLOCKED: Issue creation limit exceeded", file=sys.stderr)
        print("=" * 64, file=sys.stderr)
        print("", file=sys.stderr)
        for reason in reasons:
            print(f"  {reason}", file=sys.stderr)
        print("", file=sys.stderr)
        print("Required actions:", file=sys.stderr)
        print("  1. Run /consolidate-issues to reduce issue count", file=sys.stderr)
        print("  2. Close duplicates and resolved issues", file=sys.stderr)
        print("  3. Focus on creating PRs to close existing issues", file=sys.stderr)
        print("", file=sys.stderr)
        print("See: agentsmd/skills/consolidate-issues/SKILL.md", file=sys.stderr)
        print("=" * 64 + "\n", file=sys.stderr, flush=True)
        return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
