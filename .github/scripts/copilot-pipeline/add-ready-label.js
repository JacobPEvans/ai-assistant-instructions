// Post-triage: evaluate issue labels and add ai:ready if eligible for Copilot resolution.
// Called after issue-triage.yml runs. Reads fresh issue data to get labels triage applied.
// Excluded types: type:feature, type:security, type:breaking
// Allowed sizes: size:xs, size:s only
module.exports = async ({ github, context, core }) => {
  const issueNumber = parseInt(process.env.ISSUE_NUMBER, 10);
  const { owner, repo } = context.repo;

  const { data: issue } = await github.rest.issues.get({ owner, repo, issue_number: issueNumber });
  const labels = issue.labels.map(l => l.name.toLowerCase());

  const excludedLabels = ['type:feature', 'type:security', 'type:breaking', 'size:l', 'size:xl'];
  const allowedTypes = ['type:bug', 'type:chore', 'type:docs', 'type:ci', 'type:test', 'type:refactor', 'type:perf'];
  const allowedSizes = ['size:xs', 'size:s'];

  const hasTypeLabel = labels.some(l => l.startsWith('type:'));
  const hasSizeLabel = labels.some(l => l.startsWith('size:'));
  const hasExcluded = labels.some(l => excludedLabels.includes(l));
  const hasSkip = ['duplicate', 'invalid', 'wontfix', 'question'].some(l => labels.includes(l));
  const hasAllowedType = labels.some(l => allowedTypes.includes(l));
  const hasAllowedSize = labels.some(l => allowedSizes.includes(l));

  if (!hasTypeLabel || !hasSizeLabel) {
    core.info(`Issue #${issueNumber}: missing type/size labels — triage may not have applied labels yet`);
    core.setOutput('eligible', 'false');
    return;
  }
  if (hasExcluded || hasSkip) {
    core.info(`Issue #${issueNumber}: excluded/skip label present — not eligible`);
    core.setOutput('eligible', 'false');
    await github.rest.issues.createComment({
      owner, repo, issue_number: issueNumber,
      body: '> **Auto-resolution skipped.** This issue type is not eligible for automatic Copilot resolution (excluded label detected). Please resolve manually.',
    });
    return;
  }
  if (!hasAllowedType || !hasAllowedSize) {
    core.info(`Issue #${issueNumber}: type or size not in allowed list — not eligible`);
    core.setOutput('eligible', 'false');
    return;
  }

  await github.rest.issues.addLabels({ owner, repo, issue_number: issueNumber, labels: ['ai:ready'] });
  core.info(`Issue #${issueNumber}: eligible — added ai:ready label`);
  core.setOutput('eligible', 'true');
};
