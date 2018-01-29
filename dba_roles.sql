select * 
from dba_role_privs 
where grantee in (
&conj_users
) order by GRANTEE, GRANTED_ROLE;
