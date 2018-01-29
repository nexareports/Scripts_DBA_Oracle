col "SID" format 99999
col "SERIAL" format 99999
col user_id format 9999
col event format a25
col sample_time format a25
col sql_id format a18


Select
sample_time,
session_id "SID",
session_serial# "SERIAL",
user_id,
event,
sql_id,
session_state,
current_obj#,
time_waited/1000 "W (ms)",p1,p2,p3
from v$active_session_history
where sample_time>(sysdate-1/24/4) and event like '%&1%'
order by sample_time;


col "SID" clear
col "SERIAL" clear
col user_id clear
col event clear
col sample_time clear
col sql_id clear
