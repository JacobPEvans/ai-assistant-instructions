// Submit a REQUEST_CHANGES review on a Copilot PR to trigger the agent to fix CI.
// Uses the GitHub App token so the review is attributed to the app identity.
// Posts a tracking comment first, then submits the review.
module.exports = async ({ github, context, core }) => {
  const { owner, repo } = context.repo;
  const prNumber = parseInt(process.env.PR_NUMBER, 10);
  const failureLogs = process.env.FAILURE_LOGS || '(no logs available)';
  const attempt = process.env.ATTEMPT || '1';
  const marker = '<!-- copilot-ci-fix-attempt -->';

  // Post tracking comment
  await github.rest.issues.createComment({
    owner, repo, issue_number: prNumber,
    body: `${marker}\n> **CI Fix Attempt ${attempt}/2**: Requesting Copilot to fix CI failures.`,
  });

  const reviewBody = [
    `## CI Gate Failed — Please Fix (Attempt ${attempt}/2)`,
    '',
    'The CI Gate check failed on this pull request. Please review the failure logs below and push a fix.',
    '',
    '**Important**: Fix the actual root cause. Do not add lint ignores, skip flags, or workarounds.',
    '',
    '### Failure Logs',
    '',
    '```',
    failureLogs.length > 10000 ? failureLogs.slice(-10000) + '\n[... truncated ...]' : failureLogs,
    '```',
  ].join('\n');

  await github.rest.pulls.createReview({
    owner, repo,
    pull_number: prNumber,
    event: 'REQUEST_CHANGES',
    body: reviewBody,
  });

  core.info(`Submitted REQUEST_CHANGES review on PR #${prNumber} (attempt ${attempt})`);
};
