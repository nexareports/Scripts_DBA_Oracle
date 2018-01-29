set pages 1000
set lines 250
select
	to_char(a.sid) sid,
	a.serial#,
	a.username,
	a.sql_hash_value,
	a.last_call_et
from	v$session a, v$process b
where 	a.paddr=b.addr and spid=&1
/
