Select trunc(b.begin_interval_time,'HH') DATA,plan_hash_value,
sum(executions_delta) Execs,
avg(round(elapsed_time_delta/1000000/decode(executions_delta,0,1,executions_delta),4)) AVG_Elap_Time,
sum(round(elapsed_time_delta/1000000,4)) Total_Elap_Time,
sum(round(cpu_time_delta/1000000,4)) CPU_Time,
sum(round(buffer_gets_delta)) Buffer_Gets,
sum(round(disk_reads_delta)) Disk_reads,
sum(round(FETCHES_DELTA)) FETCHES_DELTA
from dba_hist_sqlstat a, dba_hist_snapshot b
where a.snap_id=b.snap_id 
--and b.begin_interval_time>trunc(sysdate)-15
AND A.sql_id='&1'
group by trunc(b.begin_interval_time,'HH'),plan_hash_value
order by 1;