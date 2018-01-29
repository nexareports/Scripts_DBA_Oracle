--set lines 250
--set pages 1000
col sess format a10
select lpad('-',decode(a.request,0,0,2))||a.sid sess,b.serial#,b.inst_id, a.id1, a.id2, a.lmode, a.request, a.type,
b.sql_hash_value,round(b.last_call_et/60) Min_SFPN,b.status
from gv$lock a, gv$session b
where id1 in (select id1 from gv$lock where lmode = 0)
and a.sid=b.sid
order by id1,request
/
