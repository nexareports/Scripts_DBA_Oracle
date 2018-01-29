prompt execute with DAA
execute YSINGLRP.drop_tables_harvest;
exec comp;
spo sintra_qa.sql
set pages 0 lines 200
select distinct 'create public synonym '||a.object_name||' for '|| a.owner ||'.'||a.object_name||';'
from dba_objects a
where to_char(created,'yy-mm-dd') > '08-11-19'
and owner in ('YSINGLRP')--acrecestar outros RPs
and object_type in ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','SEQUENCE','QUEUE')
and not exists (select 1 from dba_synonyms aa where aa.owner='PUBLIC' and aa.synonym_name=a.object_name)
UNION
select distinct 'create synonym YSINGL01.'||a.object_name||' for '|| a.owner ||'.'||a.object_name||';'
from dba_objects a
where to_char(created,'yy-mm-dd') > '08-11-19'
and owner in ('YSINGLRP')--acrecestar outros RPs
and object_type in ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','QUEUE')
and not exists (select 1 from dba_synonyms aa where aa.owner='YSINGL01' and aa.synonym_name=a.object_name)
/
spo off
spo sintra_qa.log
@sintra_qa
spo off
--!rm sintra_qa.sql
--exit

