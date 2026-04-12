---
engine: copilot
imports:
  - githubnext/agentics/workflows/daily-malicious-code-scan.md@main
on:
  schedule: daily
  workflow_dispatch:
permissions:
  actions: read
  contents: read
  security-events: read
---

# Daily Malicious Code Scan Agent

<!-- Thin wrapper. Upstream is source of truth; see imports above. `gh aw update` re-syncs. -->
