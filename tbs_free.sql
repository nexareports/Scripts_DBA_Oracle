set pages 1000
select c.tablespace_name, d.total "TOTAL MB", round(c.free,2) "FREE MB", round(c.free/d.total*100,2) "FREE %" from (
select a.tablespace_name, sum(a.bytes)/1024/1024 free from dba_free_space a
group by a.tablespace_name) c
, (select b.tablespace_name, sum(b.bytes)/1024/1024 total from dba_data_files b
group by b.tablespace_name
) d
where c.tablespace_name=d.tablespace_name
order by "FREE %" desc
/
 

/*
select name, total_mb, free_mb
from v$asm_diskgroup;
*/