--col EXECS  
--col ELAP_TIME   
--col CPU_TIME BUFFER_GETS 
--col DISK_READS    
col "Execs %" for 999.99
col "Elap_Time %" for 999.99
col "CPU_Time %" for 999.99
col "Buffer_Gets %" for 999.99
col "Disk_reads %" for 999.99

with tmp as (
    Select 
      to_char(b1.begin_interval_time,'YYYY-MM-DD') DATA,
      sum(executions_delta) Execs,
      sum(round(elapsed_time_delta/1000000,4)) Elap_Time,
      sum(round(cpu_time_delta/1000000,4)) CPU_Time,
      sum(round(buffer_gets_delta)) Buffer_Gets,
      sum(round(disk_reads_delta)) Disk_reads
    from dba_hist_sqlstat a1, dba_hist_snapshot b1
    where a1.snap_id=b1.snap_id 
    group by to_char(b1.begin_interval_time,'YYYY-MM-DD') 
    )
Select 
  module,trunc(b.begin_interval_time,'DD') DATA,
  --Percentuais
  round(sum(executions_delta)*100/max(c.Execs),2) "Execs %",
  round(sum(round(elapsed_time_delta/1000000,4))*100/max(c.Elap_Time),2) "Elap_Time %",
  round(sum(round(cpu_time_delta/1000000,4))*100/max(c.CPU_Time),2) "CPU_Time %",
  round(sum(round(buffer_gets_delta))*100/max(c.Buffer_Gets),2) "Buffer_Gets %",
  round(sum(round(disk_reads_delta))*100/max(c.Disk_reads),2) "Disk_reads %",
  round(sum(executions_delta)*100/max(c.Execs),2) +  round(sum(round(elapsed_time_delta/1000000,4))*100/max(c.Elap_Time),2) +  round(sum(round(cpu_time_delta/1000000,4))*100/max(c.CPU_Time),2) +  round(sum(round(buffer_gets_delta))*100/max(c.Buffer_Gets),2) +  round(sum(round(disk_reads_delta))*100/max(c.Disk_reads),2) "Peso"
from dba_hist_sqlstat a, dba_hist_snapshot b, tmp c
where a.snap_id=b.snap_id and to_char(b.begin_interval_time,'YYYY-MM-DD')=c.data
--and a.parsing_schema_name='SYS'
and b.begin_interval_time>trunc(sysdate)
--and a.sql_id in ('fc0vqgkg0wt13')
group by trunc(b.begin_interval_time,'DD'),module
order by "Peso" desc;

/*
  --Valores Absolutos 
  round(sum(executions_delta),2) Execs, 
  round(sum(round(elapsed_time_delta/1000000,4)),2) Elap_Time,
  round(sum(round(cpu_time_delta/1000000,4)),2) CPU_Time,
  round(sum(round(buffer_gets_delta)),2) Buffer_Gets, 
  round(sum(round(disk_reads_delta)),2) Disk_reads
*/