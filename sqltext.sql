--set lines 250
--set pages 1000
--set feedback off
--set verify off
prompt

col sql_text format a500
select SQL_TEXT from gv$sqltext where sql_id='&1' order by piece
/
col sql_text clear

col module format a8
select module,plan_hash_value,executions,fetches,loads,trunc(buffer_gets/executions) Bufer_Gets,trunc(disk_reads/executions) Disk_Reads,
round((((elapsed_time/executions)/1000000)),4) "Exec(s)",round((((cpu_time/executions)/1000000)),4) "CPU Time(s)",first_load_time
from gv$sqlarea where sql_id='&1'
/
col module clear

prompt 
--prompt select sql_id from v$sqlarea where hash_value=&1;
--prompt @statspack_count_qtd_run_query_periodo [SQL_HASH  DATA_INICIO  DATA_FINAL] - DATA ENTRE PLICAS/ASPAS
prompt Utilities:
prompt
prompt @sql_plan_memory &1 [Plan Hash Value]
prompt @sql_plan_hist &1 [Plan Hash Value]
prompt @ash_sqlid_dia &1
prompt @ash_sqlid_snap &1
prompt @ash_sqlid_events &1
prompt @sqlid_hints &1 [Plan Hash Value]
prompt @sql_bind &1 
prompt @sql_planos &1
prompt @topsql 
--set feedback on
prompt
@__conf
