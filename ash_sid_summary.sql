col event for a25
Select sql_id,event,sum(time_waited/1000) twait_ms,count(*)
from dba_hist_active_sess_history where session_id=&1 and session_serial#=&2
group by sql_id,event
order by 3,4;

Prompt SID=&1
Prompt SERIAL=&2

col event clear