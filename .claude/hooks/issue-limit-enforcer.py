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
from typing import Optional, Tuple

# Hard limits for issue creation
TOTAL_ISSUE_LIMIT = 50
AI_ISSUE_LIMIT = 25


def get_issue_counts() -> Tuple[int, int]:
    """Count total and AI-created open issues in one pass."""
    cmd = ["gh", "issue", "list", "--state", "open", "--json", "number,labels"]
    try:
        result = subprocess.run(
            cmd, capture_output=True, text=True, check=True, timeout=30
        )
        issues = json.loads(result.stdout)
        total_issues = len(issues)
        ai_created_issues = sum(
            1
            for issue in issues
            if any(label["name"] == "ai-created" for label in issue["labels"])
        )
        return total_issues, ai_created_issues
    except (
        subprocess.TimeoutExpired,
        subprocess.SubprocessError,
        subprocess.CalledProcessError,
        json.JSONDecodeError,
        ValueError,
    ) as e:
        # Fail open and allow command, but log warning
        print(
            f"Warning: Could not determine issue counts: {e}. "
            "Allowing command to proceed.",
            file=sys.stderr,
        )
        return 0, 0


def main() -> None:
    # Read hook input from stdin
    try:
        hook_input = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)  # Invalid input, allow

    # Get tool info and command
    tool_input = hook_input.get("tool_input", {})
    command = tool_input.get("command", "")

    # Only act on gh issue create commands
    # Check both the exact command and common variations
    if not (command.strip().startswith("gh issue create") or " gh issue create " in f" {command} "):
        sys.exit(0)

    # Count issues
    total, ai_created = get_issue_counts()

    # Check limits
    blocked = False
    reasons = []

    if total >= TOTAL_ISSUE_LIMIT:
        blocked = True
        reasons.append(f"Total issues: {total}/{TOTAL_ISSUE_LIMIT} (limit reached)")

    if ai_created >= AI_ISSUE_LIMIT:
        blocked = True
        reasons.append(
            f"AI-created issues: {ai_created}/{AI_ISSUE_LIMIT} (limit reached)"
        )

    if blocked:
        print("\n" + "=" * 64, file=sys.stderr)
        print("BLOCKED: Issue creation limit exceeded", file=sys.stderr)
        print("=" * 64, file=sys.stderr)
        print("", file=sys.stderr)
        for reason in reasons:
            print(f"  {reason}", file=sys.stderr)
        print("", file=sys.stderr)
        print("Required actions:", file=sys.stderr)
        print("  1. Use the consolidate-issues skill to reduce issue count", file=sys.stderr)
        print("  2. Close duplicates and resolved issues", file=sys.stderr)
        print("  3. Focus on creating PRs to close existing issues", file=sys.stderr)
        print("", file=sys.stderr)
        print("See: agentsmd/skills/consolidate-issues/SKILL.md", file=sys.stderr)
        print("=" * 64 + "\n", file=sys.stderr, flush=True)
        sys.exit(2)


if __name__ == "__main__":
    main()
