set lines 300
col job_action for a50
col owner for a30
col job_name for a50
SELECT owner,
  job_name,
  job_action,
  state
FROM dba_scheduler_jobs
WHERE job_name='GRANT_JOB';