Select 
to_char(b.snap_time,'YYYY-MM-DD'),max(executions) Execs,max(buffer_gets) BFG,max(cpu_time/1000000) CPU,max(elapsed_time/1000000) ELAP
from   perfstat.stats$sql_summary a, perfstat.stats$snapshot b
where a.snap_id=b.snap_id --and b.snap_time>trunc(sysdate)-10
and a.hash_value=3093032678
group by to_char(b.snap_time,'YYYY-MM-DD')
order by 1;    


select executions, elapsed_time/1000000, (elapsed_time /1000000)/executions 
from v$sqlarea where hash_value=1811663548
