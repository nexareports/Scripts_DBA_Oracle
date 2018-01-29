set lines 250
set pages 1000

Select * from (
select
   owner,object_name,
   statistic_name,
   value
from
   V$SEGMENT_STATISTICS
where
     statistic_name='buffer busy waits'
order by 4 desc) where rownum<&1+1
/
