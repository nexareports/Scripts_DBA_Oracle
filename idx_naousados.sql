Select * from (
Select owner||'.'||index_name IDX from dba_indexes where owner not like 'SYS%' and index_name not like 'SYS_IL%'
minus
Select * from (
with idx_plan as 
	(
	Select object_owner,object_name,object_type,count(*)
	from dba_hist_sql_plan x
	where object_type like 'INDEX%' and object_owner not like 'SYS%'
	group by object_owner,object_name,object_type
	order by 4
	)
Select object_owner||'.'||object_name IDX from idx_plan)
) order by 1;



/*
Select object_owner,object_name,object_type
	from dba_hist_sql_plan x
	where object_type like 'INDEX%' and object_owner like 'TWPROCDB%' and object_name like 'LSWC_HIST_SCEN_PK3%';
*/