---
title: "Git Refresh"
description: "Sync local repo after external merge (fetch, pull, prune merged branches)"
type: "command"
version: "1.0.0"
model: haiku
---

# Git Refresh

Sync local repository after a PR was merged externally (GitHub, etc.).

## Steps

1. Fetch from all remotes and remove references to deleted remote branches
   - If fetch fails due to network or authentication issues, report the error clearly
   - Continue with local operations if possible

2. Switch to the default branch:
   - Check if `main` exists locally or remotely, and switch to it
   - Otherwise, check if `master` exists and switch to it
   - If neither exists, report an error and stop

3. Pull the latest changes from origin

4. Find and delete local branches that have been merged into the default branch
   1. Never delete: main, master, develop, or the current branch
   2. Before deleting, check if branch has unpushed commits
      - If unpushed commits exist, skip that branch and warn the user
   3. Report which branches were cleaned up and which were skipped (with reasons)

Provide a brief summary of what changed.
