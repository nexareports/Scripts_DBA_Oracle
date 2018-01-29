--set lines 250
--set pages 1000
col sess format a10
col row_wait_obj# format a15
select lpad('-',decode(a.request,0,0,2))||a.sid||'-'||b.serial# sess, a.id1, a.id2, a.lmode, a.request, a.type,
b.sql_id,round(b.last_call_et/60) Min_SFPN,b.status,c.value NCommits,to_char(b.row_wait_obj#) OBJ,b.client_info
from gv$lock a, gv$session b, gv$sesstat c
where b.sid=c.sid and id1 in (select id1 from gv$lock where lmode = 0)
and a.sid=b.sid and c.statistic#=4
order by id1,request
/
