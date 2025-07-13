# Step 4: Implement and Verify

**Goal:** Write code to make the tests from Step 3 pass.

## Rules

- **Do Not Change Tests.** You must not change any test files. Your only job is to make the existing tests pass.
- **Focus on the Plan.** Follow the plan from Step 2 exactly.
- **[Idempotency](../concepts/idempotency.md)**: All operations must be repeatable with consistent results.
- **Compact Your Context.** Forget the research from Step 1. Focus only on the plan from Step 2 and the code you need to write.
- **One Thing at a Time**: Strictly follow your plan.
  - Execute one checklist item at a time except where subtasks can run in parallel.
- **Review, Don't Chat**: If AI-generated code has flaws, don't fix it via conversation. Reject the change, improve the plan in Step 2, and retry the step.

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
