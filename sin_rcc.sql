prompt execute with DAA
execute drop_tables_harvest;
spo sin_rcc.txt
set pages 0 lines 200
select 'EXECUTE SUPGBD.DBMS_PUBLIC_SYNONYM_CREATE('''||o.owner||''','''||o.object_name||''');'
from dba_objects o
where o.object_type in ('TABLE','VIEW','SEQUENCE','PROCEDURE','FUNCTION','PACKAGE')
and o.owner like '%RCCRP'
and not exists (select 1 from dba_synonyms s where s.synonym_name=o.object_name and s.owner='PUBLIC')
/
spo off
spo sin_rcc.log
@sin_rcc.txt
spo off