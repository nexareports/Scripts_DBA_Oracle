--set feedback off
Select segment_type,tablespace_name,round(sum(bytes)/1024/1024/1024,2) Gb
from dba_segments
where		owner='&1'
group by	segment_type,tablespace_name
order by	1,3 desc;
--set feedback on