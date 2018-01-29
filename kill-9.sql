select 'kill -9 '||b.spid,
a.inst_id,a.sid,a.serial#,a.USERNAME,a.OSUSER,a.MACHINE,a.TERMINAL,a.PROGRAM,a.LOGON_TIME,a.CLIENT_IDENTIFIER,
b.spid AS "OS PID",round(last_call_et/60/60,2) AS "Horas em espera"
from gv$session a, gV$PROCESS b
where (b.addr(+)=a.paddr)
and a.last_call_et>200 
and a.inst_id=b.inst_id
and a.status='ACTIVE' 
and a.username ='AGILEAS'
and a.username is not null
and b.spid is not null
order by 2 DESC;