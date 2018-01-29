col machine format a30
col program format a15
Select
a.Inst_id,
a.username,
a.sqlhash,
(a.blocks*8192)/1024/1024 Mb,
b.sid,
b.machine,
b.program
from 
gv$sort_usage a, gv$session b
where a.session_addr=b.saddr
order by 4 desc;

col machine clear
col program clear