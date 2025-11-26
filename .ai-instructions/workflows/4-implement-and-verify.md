# Step 4: Implement and Verify

**Goal:** Write code to make the tests from Step 3 pass.

## Interaction Model

**ALL MODES: Zero User Interaction**

Once implementation begins, the AI operates fully autonomously:

- No questions to the user
- No requests for clarification
- No waiting for approval
- Trust the PRD from Step 2

Apply [Self-Healing](../concepts/self-healing.md) for all decisions during implementation.

See [User Presence Modes](../concepts/user-presence-modes.md) for watchdog behavior.

## Rules

- **Do Not Change Tests.** You must not change any test files. Your only job is to make the existing tests pass.
- **Focus on the Plan.** Follow the plan from Step 2 exactly.
- **[Idempotency](../concepts/idempotency.md)**: All operations must be repeatable with consistent results.
- **Compact Your Context.** Forget the research from Step 1. Focus only on the plan from Step 2 and the code you need to write.
- **One Thing at a Time**: Strictly follow your plan.
  - Execute one checklist item at a time except where subtasks can run in parallel.
- **Review, Don't Chat**: If AI-generated code has flaws, don't fix it via conversation. Reject the change, improve the plan in Step 2, and retry the step.
- **Never Ask User**: Resolve all ambiguity autonomously per [Self-Healing](../concepts/self-healing.md).

## Tasks

1. **Implement the Code.**
    1.1. Following the plan from Step 2, write or modify the application code.
    1.2. Write the code in small, logical steps, committing frequently after each piece of functionality works.

2. **Verify with Tests.**
    2.1. After each small change, run the tests.
    2.2. Your goal is to make all tests pass.

3. **The Failure Cycle.**
    3.1. If you cannot make the tests pass and have tried all ideas, the process has failed.
    3.2. **You must not cheat.** Do not change the tests to make them pass.
    3.3. If you fail, you must proceed to Step 5 to document the failure completely. After that, the entire 5-step process will restart.

4. **Commit Changes.**
    4.1. Once all tests pass, commit your code changes.
    4.2. Use clear, logical commits that follow project standards.

## Watchdog Behavior

The [Watchdog](../concepts/user-presence-modes.md#watchdog-mechanism) monitors progress during implementation:

| Timeout | Action |
|---------|--------|
| No progress for 15 min | Check `AI_USER_PRESENT` env var |
| If user present | Prompt for guidance |
| If user not present | Commit checkpoint, make best guess, continue |

### Environment Variable

```bash
# Set by AI at session start based on mode
export AI_USER_PRESENT=true   # attended mode
export AI_USER_PRESENT=false  # unattended mode
```

When watchdog triggers and `AI_USER_PRESENT=false`:

1. Commit all current valid work with checkpoint message
2. Document uncertainty in commit body
3. Proceed with best guess per [Self-Healing](../concepts/self-healing.md)
4. Continue until task completion or hard stop
