SELECT o.status, o.object_id, o.object_type, 
       o.owner||'.'||object_name "OWNER.OBJECT" , created
  FROM dba_objects o, dba_datapump_jobs j 
 WHERE o.owner=j.owner_name AND o.object_name=j.job_name 
   AND j.job_name NOT LIKE 'BIN$%' ORDER BY 5 desc--4,2;


SELECT 'DROP TABLE '||
       o.owner||'.'||object_name ||';'
  FROM dba_objects o, dba_datapump_jobs j 
 WHERE o.owner=j.owner_name AND o.object_name=j.job_name 
   AND j.job_name NOT LIKE 'BIN$%' ;

   
Verificar o status dos jobs:

Set pages 1000 lines 1000
SELECT owner_name, job_name, operation, job_mode, 
state, attached_sessions 
FROM dba_datapump_jobs 
WHERE job_name NOT LIKE 'BIN$%' 
ORDER BY 1,2;
   