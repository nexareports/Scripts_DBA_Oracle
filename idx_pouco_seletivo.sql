PROMPT
PROMPT Pouco seletivos
PROMPT
with idx as (
	Select 
		index_name,
		table_name,
		partition_name,
		blevel,
		DISTINCT_KEYS,
		NUM_ROWS,
		round(DISTINCT_KEYS/decode(NUM_ROWS,0,1,num_rows),4) "Selectivity",
		STALE_STATS
	from dba_ind_statistics
	where 
		owner='&1'
		and DISTINCT_KEYS>0
	order by 7)
Select * from idx where "Selectivity" <0.1;

PROMPT
PROMPT Pouco seletivos e que sao utilizados
PROMPT
with idx as (
	Select 
		index_name,
		table_name,
		partition_name,
		round(DISTINCT_KEYS/decode(NUM_ROWS,0,1,num_rows),4) "Selectivity"
	from dba_ind_statistics
	where 
		owner='&1'
		and DISTINCT_KEYS>0
	)
Select a.index_name,a.table_name,a.partition_name,a."Selectivity",count(*) 
from idx a 
inner join dba_hist_sql_plan b on (a.index_name=b.object_name and b.object_owner='&1')
where a."Selectivity" <0.1
group by a.index_name,a.table_name,a.partition_name,a."Selectivity";

Prompt
prompt @search_obj &1 [Object Name]