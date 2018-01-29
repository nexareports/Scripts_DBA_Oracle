set lines 250
set pages 1000

Select * from (
select
   b.owner,
   b.object_name,
   a.statistic_name,
   a.value
from
   v$segstat a, dba_objects b
where
     a.dataobj#=b.object_id and
     a.statistic_name='buffer busy waits'
order by 4 desc) where rownum<&1+1
/
