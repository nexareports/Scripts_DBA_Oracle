col DATA forma a28
with tmp as (select /*+ RULE */ unique plan_hash_value PLAN2,decode(options,'FULL','F','-') T
from dba_hist_sql_plan where sql_id='&1' and operation='TABLE ACCESS') --and options='FULL')
Select /*+ RULE */
decode(trunc(max(b.begin_interval_time)),trunc(systimestamp),'H=>',trunc(systimestamp)-1,'1d=>',trunc(systimestamp)-2,'2d=>','-') I,
max(c.T) T,plan_hash_value PLAN,max(b.begin_interval_time) DATA,
sum(executions_delta) EXECS,
max(round(cpu_time_delta/1000000/executions_delta,4))         Max_Cpu_Time,
min(round(cpu_time_delta/1000000/executions_delta,4))         Min_Cpu_Time,
avg(round(cpu_time_delta/1000000/executions_delta,4))         Avg_Cpu_Time,
max(round(elapsed_time_delta/1000000/executions_delta,4))     Max_Elap_Time,
min(round(elapsed_time_delta/1000000/executions_delta,4))     Min_Elap_Time,
max(round(cpu_time_delta/1000000/executions_delta,4))-min(round(cpu_time_delta/1000000/executions_delta,4)) CPU_esta,
max(round(buffer_gets_delta/executions_delta))                Max_Buffer_Gets,
min(round(buffer_gets_delta/executions_delta))                Min_Buffer_Gets
from dba_hist_sqlstat a, dba_hist_snapshot b,tmp c
where a.snap_id=b.snap_id and a.plan_hash_value=c.plan2 and executions_delta>0
and sql_id in ('&1') group by plan_hash_value order by 8;


