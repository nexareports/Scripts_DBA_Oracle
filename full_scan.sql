set linesize 150
set pagesize 66
col c1 for a15
col c1 heading "OS User"
col c2 for a13
col c2 heading "Oracle User"
col b1 for a9
col b1 heading "Unix PID"
col b2 for 9999 justify left
col b2 heading "ORA SID"
col b3 for 999999 justify left
col b3 heading "SERIAL#"
col b4 heading "LOGON_TIME"
col sql_text for a65
set space 1
break on b1 nodup on c1 nodup on c2 nodup on b2 nodup on b3 nodup on b4skip 4
select c.spid b1, b.osuser c1, b.username c2, b.sid b2, b.serial# b3, a.sql_text
from v$sqltext a, v$session b, v$process c, v$session_wait w
where a.address    = b.sql_address
and w.sid  = b.sid
and b.status     = 'ACTIVE'
and b.paddr      = c.addr
and a.hash_value = b.sql_hash_value
and w.event = 'db file scattered read'
order by c.spid,a.hash_value,a.piece
/
