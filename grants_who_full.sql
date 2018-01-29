Col grantee for a120
col owner for a12
col read for a1
col write for a1

select 
OWNER,
table_name,
GRANTEE,
privilege
from DBA_TAB_PRIVS
where OWNER='&1' and grantee='&2';

col grantee clear
col owner clear
col read clear
col write clear