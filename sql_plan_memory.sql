col Operation format a35
col OBJ format a35
select
CHILD_NUMBER, 
id,parent_id P_ID,
operation||' '||options Operation,
object_owner||'.'||object_name OBJ,
cost,cardinality,
bytes,
cpu_cost,
io_cost
from gv$sql_plan where sql_id='&1' order by 1,2,3;
