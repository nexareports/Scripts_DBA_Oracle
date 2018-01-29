select distinct 'create synonym EPTP01.'||a.object_name||' for '|| a.owner ||'.'||a.object_name||';'
from dba_objects a
where to_char(created,'yy-mm-dd') > '09-01-01'
and owner in ('EPTPRP')--acrecestar outros RPs
and object_type in ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')
and not exists (select 1 from dba_synonyms aa where aa.owner='EPTP01' and aa.synonym_name=a.object_name)
/