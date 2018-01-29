col sid format 9999
col TR format 999.9
col LT format 999.9
col USR_INACT format a12
col USR_ACT format a12
col event format a30
col "User" format a15
col "OS User" format a15
col "Wait(s)" format 9,990
col PRG format a10
col W_OBJ format 999999999999999
col obj format 999999999999999
Prompt  *** LCT e TR estao em min ***
--prompt 
Prompt GROUP BY SQLID:
select sql_id,count(*) QTD from gv$session 
where status='ACTIVE' and username is not null and sql_hash_value>1
group by sql_id having count(*) > 1 order by 2 desc
/

Prompt GROUP BY ROW_WAIT_OBJ#:
select ROW_WAIT_OBJ# W_OBJ,count(*) QTD from gv$session 
where sql_hash_value>0 and status='ACTIVE' and ROW_WAIT_OBJ#!=-1
group by ROW_WAIT_OBJ# having count(*) > 1 order by 2 desc
/

Prompt RUNNING SESSIONS: (status=ACTIVE)
select 
	a.inst_id,
	a.sid,
	a.serial#,
	a.username "User",
	a.osuser "OS User",
	a.sql_id,
	a.last_call_et "LC",
	b.seconds_in_wait "W(s)",
	(select nvl(sum(time_remaining/60),0) from v$session_longops where sid=a.sid) "Full?",
	b.event,
	substr(a.program,1,10) "Prg",
	a.ROW_WAIT_OBJ# "Obj"
from 
	gv$session a, 
	gv$session_wait b
where 
	a.sid=b.sid and 
	a.inst_id=b.inst_id and
	a.status='ACTIVE' and
	a.username is not null
order by
	a.last_call_et desc
/


col sid clear
col TR clear
col LT clear
col USR_INACT clear
col USR_ACT clear
col event clear
col "Wait(s)" clear
col PRG clear
col W_OBJ clear
col obj clear

PROMPT @sid [sid]
PROMPT @ash_session [sid] [serial#]
PROMPT @ash_sqlid [sql_id]
