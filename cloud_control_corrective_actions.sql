--select * from SYSMAN.MGMT_CORRECTIVE_ACTION;
select JOB_NAME from SYSMAN.MGMT_JOB where job_id in (select distinct job_id from SYSMAN.MGMT_CORRECTIVE_ACTION) order by JOB_NAME;

select * from SYSMAN.MGMT$GROUP_MEMBERS where group_name = 'ESI' and target_type = 'oracle_database' order by 1;