#!/usr/bin/env python3
"""Drift guard: verify AGENTS.md external:karpathy block matches vendored file."""
import sys, re

vendored = "".join(open("agentsmd/external/karpathy-claude-skills.md").readlines()[4:])
content = open("AGENTS.md").read()
m = re.search(r"<!-- BEGIN external:karpathy -->(.+?)<!-- END external:karpathy -->", content, re.DOTALL)
if not m:
    sys.exit("ERROR: AGENTS.md missing <!-- BEGIN/END external:karpathy --> markers")
if vendored.strip() != m.group(1).strip():
    sys.exit("ERROR: AGENTS.md external:karpathy block is out of sync with agentsmd/external/karpathy-claude-skills.md")
print("OK: external:karpathy block in sync")
