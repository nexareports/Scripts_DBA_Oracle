with sqlh as (Select unique sql_id,SQL_OPNAME from v$active_session_history where top_level_sql_id='&1' and sql_opname!='PL/SQL EXECUTE')
Select 
	a.sql_id,
	sum(a.executions_delta) Execs,
	round(sum(a.elapsed_time_delta/1000000)) Elapsed_Time_Total,
	round(sum(a.elapsed_time_delta/1000000)/sum(a.executions_delta)) Elapsed_Time_AVG,
	max(b.sql_opname) OP_Name
from dba_hist_sqlstat a
inner join sqlh b on (a.sql_id=b.sql_id )
group by a.sql_id
order by 4 desc;



