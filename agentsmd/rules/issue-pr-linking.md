# Issue/PR Bidirectional Linking

Every PR must reference related issues (Renovate and Dependabot bot PRs are exempt).
Every issue must link back to its PR. This has failed 3 times — it's now a rule (auto-loads).

## Before Creating a PR

Search for related issues:

```bash
gh issue list --repo JacobPEvans/<repo> --state open --search "<keywords from your branch/work>"
```

## PR Body Requirements

Every PR body must include a "Related Issues" section (bot PRs from Renovate and Dependabot are exempt):

```markdown
## Related Issues
Closes #X
```

Or if no issue exists: `Related to #Y` or `None`.

Use `Closes #X` when the PR fully resolves the issue (auto-closes on merge).
Use `Related to #X` when it partially addresses or is adjacent.

## After Creating a PR

Add a bidirectional link comment on the issue:

```bash
gh issue comment <issue-num> --repo JacobPEvans/<repo> --body "Implementation: #<pr-num>"
```

## Branch Naming (Use feat/fix — NOT feature/issue-123)

| Type | Branch Pattern | Example |
| ---- | -------------- | ------- |
| Feature | `feat/<description>` | `feat/add-dark-mode` |
| Fix | `fix/<description>` | `fix/login-timeout` |

Do NOT use `feature/issue-123-*` — the worktrees rule uses `feat/` and `fix/`.

## Commit Messages

When a commit implements a specific issue, append `(#issue)`:

```text
feat: add user authentication (#42)
```

## Finding Issue Numbers

```bash
# List open issues
gh issue list --repo JacobPEvans/<repo> --state open

# Search by keyword
gh issue list --repo JacobPEvans/<repo> --state open --search "auth login"
```

## Enforcement

The `pr-creation-guards` rule enforces this at PR creation time via the auto-maintain and finalize-pr workflows.
