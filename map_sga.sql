
--set echo off
--set feedback off
--set linesize 512

prompt
prompt SGA Memory Map (overall)
prompt

column dummy      noprint
column area       format a20 heading 'Main SGA Areas'
column name       format a20
column pool       format a20
column bytes      format 999,999,999,999
column sum(bytes) format 999,999,999,999

break on report
compute sum of sum(bytes) on report

SELECT 1 dummy, 'DB Buffer Cache' area, name, sum(bytes)
FROM v$sgastat
WHERE pool is null and
      name = 'db_block_buffers'
group by name
union all
SELECT 2, 'Shared Pool', pool, sum(bytes)
FROM v$sgastat
WHERE pool = 'shared pool'
group by pool
union all
SELECT 3, 'Large Pool', pool, sum(bytes)
FROM v$sgastat
WHERE pool = 'large pool'
group by pool
union all
SELECT 4, 'Java Pool', pool, sum(bytes)
FROM v$sgastat
WHERE pool = 'java pool'
group by pool
union all
SELECT 5, 'Redo Log Buffer', name, sum(bytes)
FROM v$sgastat
WHERE pool is null and
      name = 'log_buffer'
group by name
union all
SELECT 6, 'Fixed SGA', name, sum(bytes)
FROM v$sgastat
WHERE pool is null and
      name = 'fixed_sga'
group by name
ORDER BY 4 desc;

column area       format a20 heading 'Shared Pool Areas'

prompt
prompt SGA Memory Map (shared pool)
prompt

SELECT 'Shared Pool' area, name, sum(bytes)
FROM v$sgastat
WHERE pool = 'shared pool' and
      name in ('library cache','dictionary cache','free memory','sql area')
group by name
union all
SELECT 'Shared Pool' area, 'miscellaneous', sum(bytes)
FROM v$sgastat
WHERE pool = 'shared pool' and
      name not in ('library cache','dictionary cache','free memory','sql area')
group by pool
order by 3 desc;



SELECT
    f.pool
  , f.name
  , s.sgasize
  , f.bytes
  , ROUND(f.bytes/s.sgasize*100, 2) "% Free"
FROM
    (SELECT SUM(bytes) sgasize, pool FROM v$sgastat GROUP BY pool) s
  , v$sgastat f
WHERE
    f.name = 'free memory'
  AND f.pool = s.pool
/


select pool,
       name,
       sgasize/1024/1024 "Allocated (M)",
       bytes/1024 "Free (K)",
       round(bytes/sgasize*100, 2) "% Free"
from   (select sum(bytes) sgasize from sys.v_$sgastat) s, sys.v_$sgastat f
where  f.name = 'free memory'
/
