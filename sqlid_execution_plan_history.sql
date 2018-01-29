select id,parent_id P_ID,operation||' '||options Operation,object_owner||'.'||object_name OBJ,cost,cardinality,bytes,cpu_cost,io_cost,access_predicates,filter_predicates
from dba_hist_sql_plan 
where sql_id='6uu53csx7t7p6' 
and plan_hash_value=1898169270;



--Hints:
select extractvalue(value(d), '/hint') as outline_hints 
from xmltable('/*/outline_data/hint' passing (select xmltype(other_xml) as xmlval
from dba_hist_sql_plan
where
sql_id = '&1'
and id = 1
and other_xml is not null) ) D;
