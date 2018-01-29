spo sin_public.txt
set pages 0 lines 200
--select 'EXECUTE SUPGBD.DBMS_PUBLIC_SYNONYM_CREATE('''||o.owner||''','''||o.object_name||''');'
select 'CREATE PUBLIC SYNONYM '||o.object_name||' FOR '||o.owner||'.'||o.object_name||';'
from dba_objects o
where o.object_type in ('TABLE','VIEW','SEQUENCE','PROCEDURE','FUNCTION','PACKAGE','QUEUE','TYPE')
and o.owner like '%RP'
and not exists (select 1 from dba_synonyms s where s.synonym_name=o.object_name and s.owner='PUBLIC')
and object_name not like 'TMP_OBJ_INV_HV%'
/
spo off
spo sin_public.log
@sin_public.txt
spo off

/*
select 'EXECUTE SUPGBD.DBMS_PUBLIC_SYNONYM_DROP('''||table_owner||''','''||synonym_name||''');'
from dba_synonyms
where table_owner='EPTPRP'
and owner='PUBLIC'
*/