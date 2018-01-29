--Select /* PARA PROCURAR O INTERVALO */snap_id,begin_interval_time from dba_hist_snapshot where begin_interval_time>trunc(sysdate) order by 1 desc;  --40861 40896
Select * from (
With tmp as
(
Select 
  Sum(elapsed_time_delta) ELAP,sum(cpu_time_delta) CPU,sum(buffer_gets_delta) BFG,sum(disk_reads_delta) DISKS
from dba_hist_sqlstat a
join dba_hist_snapshot b on (a.snap_id=b.snap_id and b.snap_id between &1 and &2)
)
Select 
     sql_id,
     Round(sum(elapsed_time_delta)*100/max(ELAP),2) "% ELAP",
     Round(sum(cpu_time_delta)*100/max(ELAP),2) "% CPU",
     Round(sum(buffer_gets_delta)*100/max(BFG),2) "% BFG",
     Round(sum(disk_reads_delta)*100/max(DISKS),2) "% DISK"     
from tmp,dba_hist_sqlstat a
join dba_hist_snapshot b on (a.snap_id=b.snap_id and b.snap_id between &1 and &2)
group by sql_id
order by 2 desc) where rownum<21;   