col sample_time format a25
col event format a25
col module format a21
Select 
sample_time,
user_id,
decode(top_level_sql_id,sql_id,'-',top_level_sql_id) top_lvl,
event,session_state,
blocking_session Block
,module,action
from v$active_session_history
where sql_id='&1' 
order by 1;

col sample_time clear
col event clear
col module clear
