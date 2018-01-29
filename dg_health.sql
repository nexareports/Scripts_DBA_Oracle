

col db_unique_name format a15
col flashb_on format a10

select DB_UNIQUE_NAME,DATABASE_ROLE DB_ROLE,FORCE_LOGGING F_LOG,FLASHBACK_ON FLASHB_ON,LOG_MODE,OPEN_MODE,
       GUARD_STATUS GUARD,PROTECTION_MODE PROT_MODE
from v$database;

select PROCESS,STATUS,CLIENT_PROCESS,CLIENT_PID,THREAD#,SEQUENCE#,BLOCK#,ACTIVE_AGENTS,KNOWN_AGENTS
from v$managed_standby  order by CLIENT_PROCESS,THREAD#,SEQUENCE#;

select TIMESTAMP,SEVERITY,ERROR_CODE,MESSAGE from v$dataguard_status where timestamp > systimestamp-1/24;

col db_unique_name clear
col flashb_on clear

col dest_name for a20
col status for a15
col ERROR for a20
col DESTINATION for a30
col DB_UNIQUE_NAME for a15
select DEST_NAME,STATUS,ERROR,DB_UNIQUE_NAME,DESTINATION from v$archive_dest_Status where status!='INACTIVE';

col dest_name clear
col status clear
col ERROR clear
col DESTINATION clear
col DB_UNIQUE_NAME clear

Select status,max(sequence#) from v$log group by status;