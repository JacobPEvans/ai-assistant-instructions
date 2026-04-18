// Assign issue to Copilot coding agent. Triggered by ai:ready label.
// Gates: author check, no existing PR, daily limit, attempt limit.
// Label transitions: ai:ready → removed, ai:assigned → added.
module.exports = async ({ github, context, core }) => {
  const issueNumber = context.payload.issue?.number
    || parseInt(process.env.ISSUE_NUMBER || '0', 10);
  if (!issueNumber) {
    core.setOutput('should_run', 'false');
    core.info('No issue number found');
    return;
  }
  const { owner, repo } = context.repo;
  const isManual = !context.payload.issue?.number;

  const { data: issue } = await github.rest.issues.get({ owner, repo, issue_number: issueNumber });
  const labels = issue.labels.map(l => l.name.toLowerCase());

  // Gate 1: author association (skip for manual)
  if (!isManual) {
    const allowed = ['OWNER', 'MEMBER', 'COLLABORATOR', 'CONTRIBUTOR'];
    if (!allowed.includes(issue.author_association)) {
      core.setOutput('should_run', 'false');
      core.info(`Author association ${issue.author_association} not allowed`);
      return;
    }
  }

  // Gate 2: no existing open PR for this issue
  const openPRs = await github.paginate(github.rest.pulls.list, {
    owner, repo, state: 'open', per_page: 100
  });
  const closePattern = new RegExp(
    `\\b(close|closes|closed|fix|fixes|fixed|resolve|resolves|resolved)\\s+#${issueNumber}\\b`, 'i'
  );
  if (openPRs.some(pr => closePattern.test(pr.body || ''))) {
    core.setOutput('should_run', 'false');
    core.info(`Existing open PR already references issue #${issueNumber}`);
    return;
  }

  // Gate 3: daily limit (5/day via comment markers)
  const since = new Date(Date.now() - 24 * 60 * 60 * 1000);
  const marker = '<!-- copilot-resolve-attempt -->';
  const repoComments = await github.paginate(github.rest.issues.listCommentsForRepo, {
    owner, repo, since: since.toISOString(), per_page: 100
  });
  const dailyCount = repoComments.filter(c => c.user?.type === 'Bot' && c.body?.includes(marker)).length;
  if (dailyCount >= 5) {
    core.setOutput('should_run', 'false');
    core.info(`Daily limit reached: ${dailyCount}/5`);
    return;
  }

  // Gate 4: max 1 attempt per issue
  const issueComments = await github.paginate(github.rest.issues.listComments, {
    owner, repo, issue_number: issueNumber, per_page: 100
  });
  if (issueComments.some(c => c.user?.type === 'Bot' && c.body?.includes(marker))) {
    core.setOutput('should_run', 'false');
    core.info(`Issue #${issueNumber} already has a Copilot assignment attempt`);
    return;
  }

  // Label transitions
  await github.rest.issues.removeLabel({ owner, repo, issue_number: issueNumber, name: 'ai:ready' }).catch(() => {});
  await github.rest.issues.addLabels({ owner, repo, issue_number: issueNumber, labels: ['ai:assigned'] });

  // Assign to Copilot
  try {
    await github.rest.issues.addAssignees({ owner, repo, issue_number: issueNumber, assignees: ['copilot[bot]'] });
    core.info(`Assigned issue #${issueNumber} to copilot[bot]`);
  } catch (e) {
    core.info(`Could not assign to copilot[bot]: ${e.message}`);
  }

  // Post tracking comment
  await github.rest.issues.createComment({
    owner, repo, issue_number: issueNumber,
    body: `${marker}\n> **Copilot assigned.** The Copilot coding agent has been assigned to work on this issue and will create a pull request shortly.`,
  });

  core.setOutput('should_run', 'true');
};
