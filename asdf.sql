set pagesize 1000
set pagesize 1000
set linesize 160

SELECT 'ALTER '||                                                         
       DECODE(OBJECT_TYPE,'PACKAGE BODY',' PACKAGE ',OBJECT_TYPE)||       
       ' '||owner||'.'||                                                              
       OBJECT_NAME||                                                      
       ' '||                                                              
       DECODE(OBJECT_TYPE,'PACKAGE BODY',' COMPILE BODY ;','COMPILE ;')   
FROM DBA_OBJECTS                                                         
WHERE  STATUS = 'INVALID'   
and object_type <> 'SYNONYM'                                              
--ORDER  BY OBJECT_TYPE,OBJECT_TYPE 
union all
select 'CREATE OR REPLACE PUBLIC SYNONYM '||s.synonym_name||' FOR '||s.table_owner||'.'||s.synonym_name||';'
from dba_synonyms s, dba_objects o
where s.owner=o.owner
and o.object_name=s.synonym_name
and o.status<>'VALID'
;