select 'CREATE SYNONYM EPTP01.'||object_name||' FOR '||o.owner||'.'||o.object_name||';'
from dba_objects o
where o.object_type in ('TABLE','VIEW','SEQUENCE','PROCEDURE','FUNCTION','PACKAGE','QUEUE')
and o.owner like '%EPTPRP'
and not exists (select 1 from dba_synonyms s where s.synonym_name=o.object_name and s.owner='EPTP01')
and object_name not like 'TMP_OBJ_INV_HV%'