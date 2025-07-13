# Step 2: Plan and Document (as a PRD)

**Goal:** Create a detailed Product Requirements Document (PRD) that is final for this cycle.

## Rules

- **Do Not Change Project Files.** You must not change project code or documentation yet.
- **Create a PRD File.** Your only output is a new PRD file.
- **Checklist-Driven Plan**: The `Implementation Plan` must be a Markdown checklist where each item is a complete, executable prompt for the AI's next
  step.

## Tasks

1. **Create a Temporary PRD File.**
    1.1. Create a new file named `.tmp/prd-<task-name>.md`.
    1.2. Replace `<task-name>` with a short name for the current task.

2. **Write the PRD.** The PRD must contain the following sections:
    2.1. **Objective:** What is the high-level goal? What user problem are we solving?
    2.2. **Success Metrics:** How will we measure success? What is the expected, measurable outcome?
    2.3. **Requirements:** Use a numbered list to define the specific functional requirements. What must the solution do?
    2.4. **Out of Scope:** What are we explicitly *not* doing?
    2.5. **Implementation Plan:** A detailed, step-by-step technical plan to meet the requirements. This must be a checklist of executable prompts.
    2.6. **Risks:** What could go wrong?

3. **Cross-Examine the Plan.**
    3.1. Before finalizing the PRD, get a "second opinion" on the implementation plan.
    3.2. Follow the process outlined in the [Adversarial Testing](./../concepts/adversarial-testing.md) concept.

4. **Advanced: Parallel Tasks (Optional).**
    4.1. If the plan contains independent tasks, note this in the `Implementation Plan`.
    4.2. Suggest the use of `git worktree` to separate these tasks.

5. **Finalize the PRD.**
    5.1. Review the PRD for clarity and completeness.
    5.2. This PRD is now **locked**. It cannot be changed. If the PRD is wrong, the entire 5-step process must fail and restart from Step 1.
