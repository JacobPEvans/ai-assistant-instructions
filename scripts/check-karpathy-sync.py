#!/usr/bin/env python3
"""Drift guard: verify AGENTS.md external:karpathy block matches vendored file."""
import sys
import re


def check_sync():
    try:
        with open("agentsmd/external/karpathy-claude-skills.md", encoding="utf-8") as f:
            vendored = "".join(f.readlines()[4:])
        with open("AGENTS.md", encoding="utf-8") as f:
            content = f.read()
    except FileNotFoundError as e:
        sys.exit(f"ERROR: {e}")
    m = re.search(
        r"<!-- BEGIN external:karpathy -->(.+?)<!-- END external:karpathy -->",
        content,
        re.DOTALL,
    )
    if not m:
        sys.exit("ERROR: AGENTS.md missing <!-- BEGIN/END external:karpathy --> markers")
    if vendored.strip() != m.group(1).strip():
        sys.exit(
            "ERROR: AGENTS.md external:karpathy block is out of sync with"
            " agentsmd/external/karpathy-claude-skills.md"
        )
    print("OK: external:karpathy block in sync")


if __name__ == "__main__":
    check_sync()
