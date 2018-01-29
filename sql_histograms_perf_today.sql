
with SQLS as (select SQL_ID from DBA_HIST_SQLTEXT where COMMAND_TYPE in (2,3,6,7))
SELECT
trunc(b.begin_interval_time,'MI') DATA,
sum(CASE WHEN (round(elapsed_time_delta/1000000/(decode(executions_delta,0,1,executions_delta)),4)) < 0.5 THEN executions_delta ELSE 0 END) "<0.5s",
sum(CASE WHEN (round(elapsed_time_delta/1000000/(decode(executions_delta,0,1,executions_delta)),4)) BETWEEN 0.6 AND 1 THEN executions_delta ELSE 0 END) "<1s",
sum(CASE WHEN (round(elapsed_time_delta/1000000/(decode(executions_delta,0,1,executions_delta)),4)) BETWEEN 1.01 AND 2 THEN executions_delta ELSE 0 END) "<2s",
sum(CASE WHEN (round(elapsed_time_delta/1000000/(decode(executions_delta,0,1,executions_delta)),4)) BETWEEN 2.01 AND 5 THEN executions_delta ELSE 0 END) "<5s",
sum(CASE WHEN (round(elapsed_time_delta/1000000/(decode(executions_delta,0,1,executions_delta)),4)) BETWEEN 5.01 AND 10 THEN executions_delta ELSE 0 END) "<10s",
sum(Case WHEN (round(elapsed_time_delta/1000000/(decode(executions_delta,0,1,executions_delta)),4)) > 10.01 then executions_delta else 0 end) ">10s"
from DBA_HIST_SQLSTAT a
inner join DBA_HIST_SNAPSHOT B on (a.SNAP_ID=B.SNAP_ID and b.begin_interval_time>trunc(sysdate))
inner join SQLS C on (a.SQL_ID=C.SQL_ID)
WHERE a.parsing_schema_name not in ('SYS','SYSTEM','SYSMAN','ITM','DBSNMP','ORACLE_OCM')
group by trunc(b.begin_interval_time,'MI')
ORDER BY 1;
