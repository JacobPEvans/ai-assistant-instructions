---
model: haiku
description: Sync local repo after external merge (fetch, pull, prune merged branches)
---

# Git Refresh

Sync local repository after a PR was merged externally (GitHub, etc.).

## Steps

1. Fetch from all remotes and remove references to deleted remote branches
2. Switch to the default branch (main, or master if no main exists)
3. Pull the latest changes from origin
4. Find and delete local branches that have been merged into the default branch
   - Never delete: main, master, develop, or the current branch
   - Report which branches were cleaned up

Provide a brief summary of what changed.
