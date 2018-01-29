SELECT 'kill -9 ' ||pr.spid||'' as comando, se.sid,se.serial#,se.username,se.osuser,se.machine,se.action, se.module,SE.LAST_CALL_ET,SE.STATUS,SE.SID,
'EXEC DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION('||SE.SID||','||se.SERIAL#||',TRUE);'
from V$SESSION SE,
       V$PROCESS PR
 WHERE SE.PADDR=PR.ADDR
   and se.sid=&1
/
