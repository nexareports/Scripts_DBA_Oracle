prompt ########################
prompt #      WORK AREA       #
prompt ########################
SELECT 
	SID,
	SQL_ID,
	SQL_EXEC_ID,
	SQL_EXEC_START,
	count(*) "CNT",
	sum(round(WORK_AREA_SIZE/1024/1024,2)) WORK_AREA_SIZE_MB,
	sum(round(ACTUAL_MEM_USED/1024/1024,2)) ACTUAL_MEM_USED_MB,
	sum(round(TEMPSEG_SIZE/1024/1024,2)) TEMPSEG_SIZE_MB
from V$SQL_WORKAREA_ACTIVE
group by 
	SID,
	SQL_ID,
	SQL_EXEC_ID,
	SQL_EXEC_START
order by SQL_EXEC_START;


prompt #########################
prompt # SQL MONITOR EXECUTING #
prompt #########################
@sql_monitor_runa

prompt @sql_monitor_runa
prompt @sql_monitor_error
prompt
prompt