col ERRO for a80
select 
  USERNAME,
  SQL_ID,
  SQL_EXEC_START,
  ERROR_MESSAGE ERRO
from v$sql_monitor where status='DONE (ERROR)'
order by 3;
col ERRO clear