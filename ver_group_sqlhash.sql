set lines 250
set pages 1000
set feed off

Prompt Sessoes Ativas:
Prompt =================

Select * from (
select 
	sql_hash_value,
	count(*)
from	v$session
where	status='ACTIVE' and sql_hash_value!=0
group by sql_hash_value
order by 2 desc) where rownum<&1+1
/

Prompt Sessoes Inativas:
Prompt =================

Select * from (
select 
	sql_hash_value,
	count(*)
from	v$session
where	status='INACTIVE' and sql_hash_value!=0
group by sql_hash_value
order by 2 desc) where rownum<&1+1
/

prompt _________________________________________________________________________
prompt @count_qtd_run_query_periodo [SQL_HASH  DATA_INICIO  DATA_FINAL] - DATA ENTRE PLICAS/ASPAS

prompt @sqltext



set feed on
