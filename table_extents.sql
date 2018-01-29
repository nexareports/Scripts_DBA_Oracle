SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF
set feedback off
spool c:\temp\table_extents&NomeArq_..txt
SELECT t.table_name,
       Count(e.segment_name) extents,
       t.max_extents,
       t.num_rows "ROWS",
       Trunc(t.initial_extent/1024) "INITIAL K",
       Trunc(t.next_extent/1024) "NEXT K"
FROM   all_tables t,
       dba_extents e
WHERE  e.segment_name = t.table_name
AND    e.owner        = t.owner
AND    t.owner        = Upper('&&Owner_')
GROUP BY t.table_name,
         t.max_extents,
         t.num_rows,
         t.initial_extent,
         t.next_extent
HAVING   Count(e.segment_name) > 50
ORDER BY Count(e.segment_name) DESC;
set feedback on
SET VERIFY ON
spool off