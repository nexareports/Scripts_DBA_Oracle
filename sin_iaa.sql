spo sinonimos_iaa.txt
set pages 0 lines 200
SELECT 'create synonym '||SUBSTR(o.owner,1,4)||'01.'||object_name||' for '||o.owner||'.'||object_name||';'
FROM dba_objects o
WHERE o.object_type IN ('PROCEDURE','PACKAGE','VIEW','FUNCTION','TABLE','SEQUENCE')
AND o.owner IN ('YIAARP','EIAARP')
AND NOT EXISTS (SELECT 1 FROM dba_synonyms WHERE owner =SUBSTR(o.owner,1,4)||'01' AND table_owner=o.owner AND synonym_name=o.object_name)
UNION
SELECT 'create synonym '||SUBSTR(o.owner,1,4)||'02.'||object_name||' for '||o.owner||'.'||object_name||';'
FROM dba_objects o
WHERE o.object_type IN ('PROCEDURE','PACKAGE','VIEW','FUNCTION','TABLE','SEQUENCE')
AND o.owner IN ('YIAARP','EIAARP')
AND NOT EXISTS (SELECT 1 FROM dba_synonyms WHERE owner =SUBSTR(o.owner,1,4)||'02' AND table_owner=o.owner AND synonym_name=o.object_name)
/
spo off
spo sinonimos_iaa.log
set echo on
@sinonimos_iaa.txt
spo off
