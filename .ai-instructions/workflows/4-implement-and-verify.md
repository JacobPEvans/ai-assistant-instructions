# Step 4: Implement and Verify

**Goal:** Write code to make the tests from Step 3 pass.

## Rules

- **Do Not Change Tests.** Make the existing tests pass.
- **Follow the Plan** from Step 2 exactly.
- **[Idempotency](../concepts/idempotency.md)**: All operations must be repeatable with consistent results.
- **One Thing at a Time**: Execute one checklist item at a time.
- **Improve the Plan, Don't Patch**: If implementation reveals flaws, improve the plan from Step 2 and retry - do not patch via conversation.

## Tasks

1. **Implement the Code** following the plan from Step 2. Commit frequently after each piece of functionality works.
2. **Verify with Tests.** Run tests after each change. Make all tests pass.
3. **The Failure Cycle.** If you cannot make the tests pass:
   - **Do not change the tests** to make them pass.
   - Proceed to Step 5 to document the failure. The entire 5-step process will restart.
