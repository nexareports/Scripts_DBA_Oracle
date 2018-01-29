prompt execute with DAA
execute ESINGLRP.drop_tables_harvest;
exec comp;
spo sintra_prd.sql
set pages 0 lines 200
select distinct 'create public synonym '||a.object_name||' for '|| a.owner ||'.'||a.object_name||';'
from dba_objects a
where to_char(created,'yy-mm-dd') > '09-01-01'
and owner in ('ESINGLRP')--acrecestar outros RPs
and object_type in ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','SEQUENCE','QUEUE','TYPE')
and not exists (select 1 from dba_synonyms aa where aa.owner='PUBLIC' and aa.synonym_name=a.object_name)
/
spo off
spo sintra_prd.log
@sintra_prd
spo off
