set feed off
set lines 250
set pages 1000
col module format a30
col "Exec (m)" format 9,999.9
@cl

Prompt TOP QUERYS POR EXECUTIONS:
select * from (
select 	
				hash_value,
				module,
				fetches,
				executions,
				loads,
				round(buffer_gets/executions) Buffer_gets_per_exec,
				round(((elapsed_time/executions)/1000000)/60,1) "Exec (m)",
				round(((cpu_time/executions)/1000000)) "CPU Time (s)"
from 
		 		v$sqlarea
where
		 		executions>0 and
				elapsed_time>0
order by 
				4 desc
) where rownum <5
/

Prompt 
Prompt TOP QUERYS POR TEMPO:
select * from (
select 	
				hash_value,
				module,
				fetches,
				executions,
				loads,
				round(buffer_gets/executions) Buffer_gets_per_exec,
				round(((elapsed_time/executions)/1000000)/60,1) "Exec (m)",
				round(((cpu_time/executions)/1000000)) "CPU Time (s)"
from 
		 		v$sqlarea
where
		 		executions>0 and
				elapsed_time>0
order by 
				7 desc
) where rownum <5
/

Prompt 
Prompt TOP QUERYS POR BUFFER GETS:
select * from (
select 	
				hash_value,
				module,
				fetches,
				executions,
				loads,
				round(buffer_gets/executions) Buffer_gets_per_exec,
				round(((elapsed_time/executions)/1000000)/60,1) "Exec (m)",
				round(((cpu_time/executions)/1000000)) "CPU Time (s)"
from 
		 		v$sqlarea
where
		 		executions>0 and
				elapsed_time>0
order by 
				6 desc
) where rownum <5
/

Prompt 
Prompt TOP QUERYS POR CPU TIME:
select * from (
select 	
				hash_value,
				module,
				fetches,
				executions,
				loads,
				round(buffer_gets/executions) Buffer_gets_per_exec,
				round(((elapsed_time/executions)/1000000)/60,1) "Exec (m)",
				round(((cpu_time/executions)/1000000)) "CPU Time (s)"
from 
		 		v$sqlarea
where
		 		executions>0 and
				elapsed_time>0
order by 
				8 desc
) where rownum <5
/

prompt _________________________________________________________________________
prompt @count_qtd_run_query_periodo [SQL_HASH  DATA_INICIO  DATA_FINAL] - DATA ENTRE PLICAS/ASPAS
prompt @sqltext

set feed on
