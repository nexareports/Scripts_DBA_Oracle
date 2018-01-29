set feed of
set head of

spool ./output/drop_schemas_&1..sql

prompt spool ./output/LOG_drop_schemas_&1..txt

prompt @info
prompt set echo on
Prompt SELECT count(*) FROM dba_objects WHERE object_type IN ( 'TABLE', 'VIEW', 'PACKAGE', 'TYPE', 'PROCEDURE', 'FUNCTION', 'TRIGGER', 'SEQUENCE' ) and owner='&1';;

SELECT 'DROP ' || object_type || ' ' ||owner||'.' || object_name || DECODE ( object_type, 'TABLE', ' CASCADE CONSTRAINTS PURGE' )||';' AS v_sql
FROM dba_objects
WHERE object_type IN ( 'TABLE', 'VIEW', 'PACKAGE', 'TYPE', 'PROCEDURE', 'FUNCTION', 'TRIGGER', 'SEQUENCE','MATERIALIZED VIEW' ) and owner='&1'
ORDER BY object_type,object_name;

Prompt SELECT count(*) FROM dba_objects WHERE object_type IN ( 'TABLE', 'VIEW', 'PACKAGE', 'TYPE', 'PROCEDURE', 'FUNCTION', 'TRIGGER', 'SEQUENCE' ) and owner='&1';;

prompt set echo off
prompt spoo off
spoo off

set feed on
set head on
prompt
prompt ===============================================
prompt @./output/drop_schemas_&1..sql