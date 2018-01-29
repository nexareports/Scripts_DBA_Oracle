select *
from dba_role_privs 
where GRANTEE in (
'&&1'
);