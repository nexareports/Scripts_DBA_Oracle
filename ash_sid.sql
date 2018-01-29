col event for a25
Select substr(sample_time,1,17) Data,user_id,sql_id,PLSQL_OBJECT_ID,event,time_waited/1000 twait_ms,current_obj# Obj,module
from dba_hist_active_sess_history where session_id=&1 and session_serial#=&2
order by sample_time;

Prompt SID=&1
Prompt SERIAL=&2

col event clear