REM Parametros: OWNER TABLE
select 
segment_name,tablespace_name,count(*) Qtd,round(sum(bytes)/1024/1024) Mb
from dba_extents where owner='&1' and segment_name='&2'
group by segment_name,tablespace_name;