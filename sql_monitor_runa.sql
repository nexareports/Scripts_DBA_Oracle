
select 
  USERNAME,
  SQL_ID,
  SID,
  SQL_EXEC_START,
  ELAPSED_TIME,
  round(Physical_read_bytes/1024/1024) "I/O read mb",
  Fetches
from v$sql_monitor where status='EXECUTING'
order by SQL_EXEC_START;
