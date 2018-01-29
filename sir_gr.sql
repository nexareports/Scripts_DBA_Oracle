--EXECUTE WITH *SIRGRRP
spo sirgr.sql
set pages 0 lines 200

execute drop_tables_harvest;

select distinct 
'create synonym '||b.grantee||'.'||a.table_name||' for '|| a.owner ||'.'||a.table_name||';'
from 
(select owner, table_name, grantee from dba_tab_privs where grantee like 'RSIR%') a,
(select grantee, granted_role from dba_role_privs where granted_role like 'RSIR%' and grantee not like '%SIRGRRP') b
where a.grantee = b.granted_role
and a.table_name in (select object_name from user_objects where to_char(created,'yy-mm-dd') > '09-01-01')
and not exists (select 1 from dba_synonyms aa where aa.owner=b.grantee and synonym_name=a.table_name)
union
select distinct 
'create synonym '||a.grantee||'.'||a.table_name||' for '|| a.owner ||'.'||a.table_name||';'
from 
(select owner, table_name, grantee from dba_tab_privs where grantee like '%SIR%' and grantor like '%SIRGRRP') a
where a.table_name in (select object_name from user_objects where to_char(created,'yy-mm-dd') > '09-01-01')
and not exists (select 1 from dba_synonyms aa where aa.owner=a.grantee and synonym_name=a.table_name)
/

spo off
spo sirgr.log
@sirgr.sql
spo off
