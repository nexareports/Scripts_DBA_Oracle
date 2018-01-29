prompt execute with DAA
execute SAPA.drop_tables_harvest;
exec comp;
spo sapa.sql
set pages 0 lines 200
select distinct 'create public synonym '||a.object_name||' for '|| a.owner ||'.'||a.object_name||';'
from dba_objects a
where to_char(created,'yy-mm-dd') > '09-11-01' and 
owner in ('SAPA','TTIBCORP','SAPA_PINOS','ETIBCORP','REP_PIS')--acrecestar outros RPs
and object_type in ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','SEQUENCE')
and not exists (select 1 from dba_synonyms aa where aa.owner='PUBLIC' and aa.synonym_name=a.object_name)
and object_name not like 'TMP_OBJ_INV_HV%'
/
spo off
spo sapa.log
@sapa
spo off
