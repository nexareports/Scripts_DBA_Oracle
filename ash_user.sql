col event for a25
col sql_opname for a15
col module for a20

Select substr(a.sample_time,1,17) Data,a.user_id,a.sql_id,a.event,a.time_waited/1000 twait_ms,a.current_obj# Obj,a.sql_opname,a.module	
from v$active_session_history a , dba_users b where a.user_id=b.user_id and b.username=upper('&1')
order by sample_time;

col event clear
col sql_opname clear
col module clear