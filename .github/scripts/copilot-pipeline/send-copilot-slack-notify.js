// Send a Slack Block Kit notification when a Copilot-authored PR opens.
// Extracts the linked issue number from the PR body (Closes/Fixes #N pattern).
module.exports = async ({ github, context, core }) => {
  const webhookUrl = process.env.SLACK_WEBHOOK_URL;
  const prTitle = process.env.PR_TITLE;
  const prUrl = process.env.PR_URL;
  const prNumber = process.env.PR_NUMBER;
  const prBody = process.env.PR_BODY || '';
  const repoName = process.env.REPO_NAME;
  const eventType = process.env.EVENT_TYPE || 'opened';

  const issueMatch = prBody.match(/\b(?:close|closes|closed|fix|fixes|fixed|resolve|resolves|resolved)\s+#(\d+)\b/i);
  const linkedIssue = issueMatch ? `#${issueMatch[1]}` : 'unknown';

  const blocks = [
    {
      type: 'header',
      text: { type: 'plain_text', text: eventType === 'ready_for_review' ? 'Copilot PR Ready for Review' : 'Copilot PR Opened' },
    },
    {
      type: 'section',
      text: { type: 'mrkdwn', text: `*<${prUrl}|${repoName} #${prNumber}: ${prTitle}>*` },
    },
    {
      type: 'section',
      fields: [
        { type: 'mrkdwn', text: `*Linked Issue:*\n${linkedIssue}` },
        { type: 'mrkdwn', text: `*Author:*\ncopilot[bot]` },
      ],
    },
  ];

  const response = await fetch(webhookUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ blocks }),
  });

  if (!response.ok) {
    core.setFailed(`Slack webhook failed: ${response.status} ${response.statusText}`);
    return;
  }
  core.info(`Slack notification sent for Copilot PR #${prNumber}`);
};
