--set lines 250
--set pages 1000
col sess format a10
col program format a30
select 
	to_char(a.sid) sess,
	a.serial#,
	b.spid PID_SO,
	a.program,
	a.sql_hash_value,
	b.pga_alloc_mem,
	round(a.last_call_et/60) min_sfpn
from 	v$session a,
	v$process b
where 	rownum<&1+1 and 
	a.username is not null and
	a.paddr=b.addr
order by 7 desc
/
