set lines 220 pages 3000
set echo off

define sql_id=&1

WITH
p AS (
SELECT plan_hash_value
  FROM gv$sql_plan
 WHERE sql_id = TRIM('&&sql_id.')
   AND other_xml IS NOT NULL
 UNION
SELECT plan_hash_value
  FROM dba_hist_sql_plan
 WHERE sql_id = TRIM('&&sql_id.')
   AND other_xml IS NOT NULL ),
m AS (
SELECT plan_hash_value,
       SUM(elapsed_time)/SUM(executions) avg_et_secs, sum(executions) executions
  FROM gv$sql
 WHERE sql_id = TRIM('&&sql_id.')
   AND executions > 0
 GROUP BY
       plan_hash_value),
a AS (
SELECT plan_hash_value,
       SUM(elapsed_time_total)/SUM(executions_total) avg_et_secs, sum(executions_total) executions
  FROM dba_hist_sqlstat
 WHERE sql_id = TRIM('&&sql_id.')
   AND executions_total > 0
 GROUP BY
       plan_hash_value)
SELECT p.plan_hash_value,
       ROUND(NVL(m.avg_et_secs, a.avg_et_secs)/1e6, 3) avg_et_secs, NVL(m.executions,a.executions) executions
  FROM p, m, a
 WHERE p.plan_hash_value = m.plan_hash_value(+)
   AND p.plan_hash_value = a.plan_hash_value(+)
 ORDER BY
       avg_et_secs NULLS LAST;
	   
prompt

