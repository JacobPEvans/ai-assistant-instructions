---
description: Sync local repo after external merge (fetch, pull, prune merged branches)
model: haiku
allowed-tools: Bash(git fetch:*), Bash(git branch:*), Bash(git checkout:*), Bash(git switch:*), Bash(git pull:*), Bash(git log:*)
---

# Git Refresh

Sync local repository after a PR was merged externally (GitHub, etc.).

## Steps

1. Note the current branch name
2. Fetch from all remotes and prune deleted remote branches
3. Switch to the default branch (main or master)
4. Pull the latest changes from origin
5. Delete local branches that have been merged into the default branch
   - Never delete: main, master, develop
   - Report which branches were cleaned up
6. If the original branch still exists (wasn't merged/deleted), switch back to it

Provide a brief summary of what changed.
