// Extract failure logs from a workflow_run event.
// Downloads logs for all failed jobs, last 200 lines each, 60k char limit total.
module.exports = async ({ github, context, core }) => {
  const { owner, repo } = context.repo;
  const runId = context.payload.workflow_run?.id;
  if (!runId) { core.setOutput('logs', '(no workflow_run id available)'); return; }

  const allJobs = await github.paginate(github.rest.actions.listJobsForWorkflowRun, {
    owner, repo, run_id: runId
  });
  let logs = '';
  for (const job of allJobs.filter(j => j.conclusion === 'failure')) {
    logs += `\n=== FAILED JOB: ${job.name} ===\n`;
    try {
      const logData = await github.rest.actions.downloadJobLogsForWorkflowRun({ owner, repo, job_id: job.id });
      logs += logData.data.split('\n').slice(-200).join('\n');
    } catch (e) {
      logs += `(Could not download logs: ${e.message})\n`;
    }
  }
  core.setOutput('logs', logs.length > 60000 ? logs.slice(-60000) : logs);
};
