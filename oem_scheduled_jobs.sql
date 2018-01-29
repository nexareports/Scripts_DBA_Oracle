col job_name for a40
col job_type for a20
col target_name for a50
Select JOB_NAME,JOB_TYPE,TARGET_NAME from MGMT$JOB_TARGETS where TARGET_TYPE='oracle_database' order by TARGET_NAME,JOB_NAME;
col job_name clear
col job_type clear
col target_name clear


