select sql_text from dba_hist_sqltext where sql_id='&1';

select id,parent_id P_ID,operation||' '||options Operation,object_owner||'.'||object_name OBJ,cost,cardinality,bytes,cpu_cost,io_cost
from dba_hist_sql_plan where sql_id='&1' and plan_hash_value=&2;