# Fix All PR CI Failures

**Purpose**: Systematically resolve all CI failures across all open pull requests by launching parallel subagents that work autonomously until all PRs are 100% mergeable.

## How It Works

You are the **orchestrator**. You will:

1. List all repositories using `gh repo list`
2. For each repo, get open PRs with `gh pr list`
3. Launch parallel subagents (Task tool) for each PR with failing checks
4. Monitor completion with TaskOutput
5. Verify PRs are 100% mergeable
6. Relaunch subagents if needed
7. Report final status

## Execution Steps

### Step 1: Discovery

```bash
# Get owner
OWNER=$(gh api user --jq .login)

# Get all repos
gh repo list $OWNER --limit 1000 --json name --jq '.[].name'

# For each repo, get PRs with failures
gh pr list --repo $OWNER/{REPO} --json number,title,statusCheckRollup,mergeable
```

Filter for PRs where:

- Any check has `conclusion: "FAILURE"`
- OR `mergeable != "MERGEABLE"`

### Step 2: Launch Parallel Subagents

Launch ONE subagent per failing PR in a SINGLE message with multiple Task tool calls.

**Subagent Prompt**:

```text
Fix all CI failures for {OWNER}/{REPO} PR #{NUMBER}

Title: {TITLE}
Failing checks: {LIST}

Your mission:
1. Clone repo: gh repo clone {OWNER}/{REPO} /tmp/fix-{REPO}-{NUMBER}
2. Enter directory: cd /tmp/fix-{REPO}-{NUMBER}
3. Checkout PR: gh pr checkout {NUMBER}
4. Identify failures: gh run list --limit 3
5. For EACH failing check:
   a. Get logs: gh run view {RUN_ID} --log-failed
   b. Replicate failure locally
   c. Fix root cause (NEVER disable checks)
   d. Test fix locally (pre-commit, tests, etc.)
6. Commit: git add -A && git commit -m "fix: resolve {CHECK_NAME} failures"
7. Push: git push
8. Wait for CI: sleep 90
9. Verify mergeable: gh pr view {NUMBER} --json mergeable,statusCheckRollup

CRITICAL RULES:
- Only use approved tools from ~/.claude/settings.json
- NEVER add config to bypass linters/tests/checks
- ALWAYS fix the actual issue
- Use simple commands (no complex bash)
- Verify PR shows mergeable: "MERGEABLE" before reporting done

Report when complete:
✅ PR: https://github.com/{OWNER}/{REPO}/pull/{NUMBER}
✅ Mergeable: {YES/NO}
✅ All checks: {PASS/FAIL for each}
⚠️  Issues: {list remaining issues or "none"}
```

### Step 3: Monitor Subagents

After launching all subagents, check their status:

```bash
# Wait for agents to complete
Use TaskOutput with block=true for each agent ID

# Verify each PR
gh pr view {NUMBER} --repo {OWNER}/{REPO} \
  --json mergeable,statusCheckRollup \
  --jq '{mergeable, checks: [.statusCheckRollup[] | select(.conclusion != null) | {name, conclusion}]}'
```

A PR is **100% complete** when:

- `mergeable: "MERGEABLE"`
- All required checks show `conclusion: "SUCCESS"`
- No conflicts

### Step 4: Relaunch for Incomplete Work

If subagent reported complete BUT PR still has failures:

1. Launch NEW subagent for that PR
2. Include what the previous agent did
3. Specify what still needs fixing
4. Max 3 attempts per PR

### Step 5: Final Report

```text
## CI Fix Results

Total repos scanned: {N}
Total PRs processed: {N}

✅ FIXED ({N} PRs):
- {OWNER}/{REPO}#{NUMBER}: {TITLE} - https://github.com/...
...

⚠️  PARTIAL ({N} PRs):
- {OWNER}/{REPO}#{NUMBER}: {remaining issues}
...

❌ FAILED ({N} PRs):
- {OWNER}/{REPO}#{NUMBER}: {reason}
...
```

## Keep It Simple

### For Orchestrator (YOU)

- Use `gh` CLI (list, view, etc.)
- Launch Task tools in parallel
- Use TodoWrite to track
- Use TaskOutput to monitor
- That's it!

### For Subagents

- Use only approved tools
- Simple bash commands
- No complex scripts
- Fix root causes
- Verify before reporting

## Approved Tools Reference

From `~/.claude/settings.json`:

**GitHub**: `gh pr *`, `gh run *`, `gh repo *`, `gh api *`
**Git**: `git clone`, `git checkout`, `git add`, `git commit`, `git push`, `git status`
**Validation**: `pre-commit run`
**Files**: Read, Write, Edit, Glob, Grep tools
**Shell**: Simple bash commands only

## Priority Order

Process PRs in this order:

1. Simple config fixes (broken links, formatting)
2. Linting issues
3. Test failures
4. Build failures
5. Flaky tests (lowest priority - may need multiple attempts)

## Batching

If > 20 PRs need fixing:

- Process first 20
- Wait for completion
- Process next batch
- Avoids overwhelming the system

## Error Handling

If subagent fails 3 times on same PR:

- Mark PR as "needs human review"
- Log the issue
- Continue with other PRs
- Don't let one failure block everything

## Example Usage

```bash
/fix-all-pr-ci
```

You will autonomously:

1. Scan all repos
2. Find all failing PRs
3. Fix them in parallel
4. Verify everything
5. Report results

No user interaction needed - you handle everything!

---

**Remember**: Simple commands, approved tools only, fix root causes, verify completion, be autonomous.
