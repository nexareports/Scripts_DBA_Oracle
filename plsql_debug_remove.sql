select 'alter session set plsql_debug=false;' cmd from dual
union all
select * from (
with tmp as (
SELECT owner, name, type
FROM dba_plsql_object_settings
WHERE plsql_debug='TRUE'
ORDER BY 1,3,2)
--
Select 
decode(a.object_type,
'PACKAGE BODY', 'alter package '||a.owner||'.'||object_name||' compile body;',
'JAVA CLASS', 'alter java class "'||a.object_name||'" compile;',
'alter '||a.object_type||' '||a.owner||'.'||a.object_name||' compile;') CMD
from dba_objects a
inner join tmp b on (a.owner=b.owner and a.owner='&1' and a.object_name=b.name));