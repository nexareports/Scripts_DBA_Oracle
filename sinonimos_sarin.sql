set pages 0 lines 2000
select distinct 'create synonym '||b.grantee||'.'||a.table_name||' for '||upper(user)||'.'||a.table_name||';'
from user_tab_privs a,dba_role_privs b
where
a.grantor=upper(user)
and a.grantee=b.granted_role
and b.grantee<>upper(user) and  
exists (select 1 from all_users where username=b.grantee) 
and not exists
(select 1 from dba_synonyms aa where aa.owner=b.grantee and synonym_name=a.table_name)

spool syns.sql
/
spool off
@syns.sql
select distinct 'create synonym '||a.grantee||'.'||a.table_name||' for '||upper(user)||'.'||a.table_name||';'
from user_tab_privs a
where
a.grantor=upper(user) and a.grantee<>upper(user) and  
exists (select 1 from all_users where username=a.grantee) 
and not exists
(select 1 from dba_synonyms aa where aa.owner=a.grantee and aa.synonym_name=a.table_name)


spool syns.sql
/
spool off
@syns.sql
!rm syns.sql
set pages 20 
