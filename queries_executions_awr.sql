select
   to_char(begin_interval_time,'mm-dd hh24:mi:ss') beginttm,
   sql_id sqlid,
   executions_delta execsdlt,
   buffer_gets_delta bufgetwaitdlt,
   disk_reads_delta dskrdwaitdlt,
   iowait_delta iowaitdlt,
   apwait_delta appwaitdlt,
   ccwait_delta concurwaitdlt
from
   dba_hist_snapshot sn,
   dba_hist_sqlstat ss
where
   ss.snap_id = sn.snap_id
   and sql_id = '0vt20uc2sy73r'
   and begin_interval_time > (sysdate - 5)
order by
   beginttm,
   ( executions_delta + buffer_gets_delta +
     disk_reads_delta + iowait_delta +
     apwait_delta + ccwait_delta ) desc;