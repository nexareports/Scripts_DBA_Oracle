SELECT start_time, end_time, input_type, status
FROM v$rman_backup_job_details
ORDER BY 1;