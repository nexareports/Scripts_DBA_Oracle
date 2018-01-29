col Operation format a35
col OBJ format a35
select 
id,parent_id P_ID,
operation||' '||options Operation,
object_owner||'.'||object_name OBJ,
cost,cardinality,
bytes,
cpu_cost,
io_cost
from dba_hist_sql_plan where sql_id like '%&1%' and plan_hash_value=&2
order by id;
