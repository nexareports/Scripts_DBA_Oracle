Select
	unique Sql_id,plan_hash_value
from dba_hist_sqlplan
where object_owner='&1' and object_name='&2';
