-- connect with ?SIRATRP
spo sirel.sql
set pages 0 lines 200
select distinct 
'create synonym '||b.grantee||'.'||a.table_name||' for '|| a.owner ||'.'||a.table_name||';'
from 
(select owner, table_name, grantee from dba_tab_privs where grantee like 'SIRAC%') a,
(select grantee, granted_role from dba_role_privs where granted_role like 'SIRAC%' and grantee not in('ESIRATRP','YSIRATRP')) b
where a.grantee = b.granted_role
and a.table_name in (select object_name from user_objects where to_char(created,'yy-mm-dd') > '09-04-01')
and not exists (select 1 from dba_synonyms aa where aa.owner=b.grantee and synonym_name=a.table_name)
/
spo off

spo sirel.log
@sirel.sql
spo off
--exit

