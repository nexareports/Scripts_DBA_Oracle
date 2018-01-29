SET ECHO OFF
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 1000
SET TIME OFF
spool tmp/drop_objects.sql
select 'DROP '||object_type||' '||owner||'.'||object_name||';'
from dba_objects 
where owner = upper('&1') 
and object_type in ('PACKAGE','FUNCTION','VIEW','MATERIALIZED VIEW','PROCEDURE','TYPE','TRIGGER','SEQUENCE','SYNONYM','INDEX');

SPOOL OFF
SET VERIFY ON
SET FEEDBACK ON
SET HEADING ON
SET ECHO OFF
SET TIME ON
prompt tmp/drop_objects.sql
