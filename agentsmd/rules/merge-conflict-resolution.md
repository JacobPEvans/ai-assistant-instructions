# Merge Conflict Resolution

Best practices for resolving git merge conflicts intelligently.

## Core Principle

**NEVER assume newer is correct.** Timestamp is not a measure of correctness.

When resolving conflicts, analyze BOTH versions to understand their intent and combine them intelligently.

## Understanding Conflict Markers

```text
<<<<<<< HEAD
Your branch's version (the branch you're ON)
=======
The incoming version (the branch you're merging IN)
>>>>>>> branch-name
```

## Resolution Process

### Step 1: Understand the File

Before touching any conflict:

1. Read the entire file to understand its purpose
2. Check git history: `git log --oneline -10 -- <file>`
3. Understand what both branches were trying to accomplish

### Step 2: Analyze Both Versions

For each conflict block:

1. **Identify what HEAD changed**: What did your branch modify and why?
2. **Identify what incoming changed**: What did the other branch modify and why?
3. **Check compatibility**: Can both changes coexist?
4. **Look for patterns**: Check related files for coding patterns

### Step 3: Resolve Intelligently

| Scenario | Resolution |
| -------- | ---------- |
| Changes are additive | Keep both changes |
| Changes modify same logic | Combine the intent of both |
| One is a bug fix | Always include the fix |
| One is a refactor | Apply refactor, then add the other change |
| Truly incompatible | Prefer branch's changes, add a code comment explaining the decision |

### Step 4: Verify Resolution

After resolving:

1. Run linters/formatters: `pre-commit run --files <file>`
2. Run related tests if possible
3. Read through the resolved file for consistency

## Syncing Main Into a Branch

This is the most common conflict scenario. Here's the proper workflow:

### Before Starting

```bash
# ALWAYS sync main worktree first
cd ~/git/<repo>/main
git fetch origin main
git pull origin main
```

### Perform the Merge

```bash
# Switch to your feature branch worktree
cd ~/git/<repo>/feat/<branch>

# Merge main into your branch
git merge origin/main --no-edit
```

### If Conflicts Occur

```bash
# List conflicted files
git diff --name-only --diff-filter=U

# For each conflicted file:
# 1. Open and analyze (see resolution process above)
# 2. Edit to resolve
# 3. Stage the resolved file
git add <resolved-file>

# After all conflicts resolved
git commit --no-edit

# Push the updated branch
git push origin <branch>
```

## Common Conflict Types

### Import/Dependency Conflicts

```text
<<<<<<< HEAD
import { helper } from './utils';
import { newFeature } from './features';
=======
import { helper, otherHelper } from './utils';
>>>>>>> main
```

**Resolution**: Combine all imports:

```javascript
import { helper, otherHelper } from './utils';
import { newFeature } from './features';
```

### Function Signature Changes

```text
<<<<<<< HEAD
function process(data) {
  validate(data);
  return transform(data);
}
=======
function process(data, options = {}) {
  return transform(data);
}
>>>>>>> main
```

**Resolution**: Combine both improvements:

```javascript
function process(data, options = {}) {
  validate(data);
  return transform(data);
}
```

### Configuration Conflicts

```text
<<<<<<< HEAD
{
  "feature_a": true,
  "feature_b": true
}
=======
{
  "feature_a": true,
  "feature_c": true
}
>>>>>>> main
```

**Resolution**: Include all features (if compatible):

```json
{
  "feature_a": true,
  "feature_b": true,
  "feature_c": true
}
```

### Deleted vs Modified

When one branch deleted code another modified:

1. Understand WHY it was deleted
2. If deletion was intentional cleanup, don't restore
3. If deletion was accidental, restore the modified version
4. If unsure, check with the author or mark for review

## Anti-Patterns

### Wrong: Accept Theirs/Ours Blindly

```bash
# NEVER do this without analysis
git checkout --theirs <file>
git checkout --ours <file>
```

### Wrong: Assume Newer is Better

Just because main is "newer" doesn't mean its version is correct. Your branch may have a fix that main doesn't.

### Wrong: Delete One Side Completely

Unless you're certain one side should be removed, always try to combine.

### Wrong: Skip Testing After Resolution

Always verify the resolved code works.

## When to Escalate

Mark for human review when:

- The conflict involves complex business logic you don't understand
- Both changes fundamentally contradict each other
- Security-sensitive code is involved
- The resolution would change behavior significantly

## Tools and Commands

| Command | Purpose |
| ------- | ------- |
| `git diff --name-only --diff-filter=U` | List conflicted files |
| `git log --merge -p <file>` | Show commits that caused conflict |
| `git show :1:<file>` | Show common ancestor version |
| `git show :2:<file>` | Show HEAD (your branch) version |
| `git show :3:<file>` | Show incoming (their branch) version |
| `git checkout --conflict=merge <file>` | Re-create conflict markers |
| `git merge --abort` | Abort merge and return to pre-merge state |

## Integration with Workflows

Several workflows reference this guide:

- `/sync-main` - Merges main into current branch
- `/sync-main all` - Merges main into all open PRs
- `ci-fixer` agent - May need to resolve conflicts when fixing CI
- `/init-worktree` - Starts from synced main to avoid conflicts
