col outline_hints format a100
select extractvalue(value(d), '/hint') as outline_hints 
from xmltable('/*/outline_data/hint' passing (select xmltype(other_xml) as xmlval
from dba_hist_sql_plan
where
sql_id = '&1'
and id = 1
and plan_hash_value=&2
and other_xml is not null) ) D;

col outline_hints clear