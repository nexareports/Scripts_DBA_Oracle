col sid format 9999
col TR format 999.9
col LT format 999.9
--set feed off
--set echo off
col USR_INACT format a12
col OS_USER format a12
col USR_ACT format a12
col event format a30
col "Wait(s)" format 9,990
col PRG format a10
col W_OBJ format 9999999
Prompt  *** LT e TR estao em min ***
--prompt 
--Prompt GROUP BY HASH VALUE:
select sql_id,count(*) QTD from gv$session 
where status='INACTIVE' and username is not null and sql_hash_value>1
group by sql_id having count(*) > 1 order by 2 desc
/

--Prompt GROUP BY ROW_WAIT_OBJ#:
select ROW_WAIT_OBJ# W_OBJ,count(*) QTD from gv$session 
where sql_hash_value>0 and status='INACTIVE' and ROW_WAIT_OBJ#!=-1
group by ROW_WAIT_OBJ# having count(*) > 1 order by 2 desc
/

--Prompt LATCH NAME:
select a.inst_id,a.sid,b.latch#,b.name
from gv$session_wait a,gv$latchname b
where b.latch#=a.p2
and a.inst_id=b.inst_id
and a.event='latch free'
order by a.sid desc
/

--@longops 1

--prompt 




--Prompt RUNNING SESSIONS: (status=INACTIVE)
select
	a.inst_id,
	a.sid,
	a.serial#,
	a.username USR_INACT,
	a.osuser OS_USER,
	a.prev_sql_id,
	round(a.last_call_et/60) "LCT/60",
	b.seconds_in_wait "W(s)",
	(select nvl(sum(time_remaining/60),0) from gv$session_longops where sid=a.sid) TR,
	b.event,
	substr(a.program,1,10) PRG,a.ROW_WAIT_OBJ# W_OBJ
from 
	gv$session a, 
	gv$session_wait b
where 
	a.sid=b.sid and 
	a.inst_id=b.inst_id and
	a.status='INACTIVE' and
	a.username is not null
order by
	a.last_call_et desc
/

--set feed on
--set echo off
col sid clear
col TR clear
col LT clear
col USR_INACT clear
col USR_ACT clear
col event clear
col "Wait(s)" clear
col PRG clear
col W_OBJ clear
