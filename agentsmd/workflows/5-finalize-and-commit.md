# Step 5: Finalize and Commit

**Goal:** Finalize all work, update documentation, and clean up.

## On Failure

If Step 4 failed:

1. Do not merge broken code.
2. Document the failure in detail in the PRD file and `PLANNING.md`.
3. A new cycle will begin from Step 1.

## On Success

1. **Update Documentation**
   - Update the `README.md` if your changes affect it.
   - Remove the completed task from `PLANNING.md`.

2. **MANDATORY: Documentation Review**
   - **CRITICAL**: Must be completed before any pull request can be merged.
   - **REQUIRED FIRST STEP**: Run `markdownlint-cli2 --fix .` to auto-fix issues.
   - Run `markdownlint-cli2 .` to check for remaining issues.
   - Fix all markdownlint violations, especially MD013 (max 160 characters).

3. **Final Steps**
   - Ensure all code is committed and pushed to the PR branch.
   - Delete the temporary plan file from `/.tmp/`.
   - The pull request is now ready for final review and merging.
