select DISTINCT to_char(sql_exec_start,'yyyy-mm-dd hh24:mi') "SQL_EXEC_START", sql_id, machine 
from DBA_HIST_ACTIVE_SESS_HISTORY
where sql_id = 'btytutm2k6tpj'
order by 1 desc;