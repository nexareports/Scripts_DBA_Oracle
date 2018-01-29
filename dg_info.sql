set feed off
set timing off
col info for a100
col destination for a20
col recovery_mode for a40
col database_mode for a30
col type for a15
col status for a15
col gap_status for a15
exec dbms_output.put_line('');
select 'BD: '||instance_name||' - '||'Machine: '||host_name||' STARTUP: '||STARTUP_TIME INFO from v$instance;
exec dbms_output.put_line('');
select DG.DESTINATION, dg.RECOVERY_MODE, dg.DATABASE_MODE, dg.TYPE, dg.STATUS, dg.GAP_STATUS, dg.APPLIED_SEQ#, arc.COMPLETION_TIME 
from v$archive_dest_status dg, v$archived_log arc
where ARC.NAME=DG.DESTINATION
and ARC.SEQUENCE#=DG.APPLIED_SEQ#;
exec dbms_output.put_line('');
set feed on
set timing on