select 
	a.sid,a.serial#,
	a.username USR_ACT,
	a.sql_id,
	a.last_call_et/60 LCT,
	b.seconds_in_wait "W(s)",c.name,
	a.ROW_WAIT_OBJ# W_OBJ
from 
	v$session a, 
	v$session_wait b,
	v$latchname c
where 
	a.sid=b.sid and b.p2=c.latch# and b.event like '%latch free%' and
	a.username is not null
order by
	a.last_call_et desc
/