# Step 5: Finalize and Commit

**Goal:** Finalize all work, update documentation, and clean up.

## Tasks

1. **Handle Success or Failure.**
    1.1. **If Step 4 was successful:** Proceed with the tasks below to finalize the project.
    1.2. **If Step 4 failed:**
        1.2.1. Do not merge broken code.
        1.2.2. Document the failure in detail.
        1.2.3. Update `PLANNING.md` with a summary of what went wrong, what was tried, and why it failed.
        1.2.4. Update the `CHANGELOG.md` to note the failed attempt.
        1.2.5. After documenting, the process is complete. A new cycle to resolve the issue will begin from Step 1.

2. **Update Documentation (on Success).**
    2.1. Update the `README.md` if your changes affect it.
    2.2. Add a new entry to the `CHANGELOG.md` describing your successful changes.
    2.3. Remove the completed task from `PLANNING.md`.

3. **MANDATORY: Documentation Review.**
    3.1. **CRITICAL**: Must be completed before any pull request can be merged.
    3.2. Run documentation review using [Review Documentation](../commands/review-docs.md).
    3.3. **REQUIRED FIRST STEP**: Run `markdownlint-cli2 --fix .` to auto-fix issues.
    3.4. Run `markdownlint-cli2 .` to check for remaining issues.
    3.5. Fix all markdownlint violations, especially MD013 (max 160 characters).
    3.6. Fix any broken or incomplete sentences around 80-character boundaries.
    3.7. All markdownlint issues MUST be resolved before proceeding.

4. **Final Code Commit (on Success).**
    4.1. Ensure all new code is committed.
    4.2. Push all commits to the pull request branch created in Step 3.

5. **Clean Up.**
    5.1. Delete the temporary plan file from `/.tmp/`.

6. **Final Review.**
    6.1. The pull request is now ready for final review and merging.
