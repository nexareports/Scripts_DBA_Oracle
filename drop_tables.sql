SET ECHO OFF
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 1000
SET TIME OFF
spool tmp/drop_tables.sql
select 'DROP TABLE '||owner||'.'||table_name||' purge;'
from dba_tables 
where owner = upper('&1');

SPOOL OFF
SET VERIFY ON
SET FEEDBACK ON
SET HEADING ON
SET ECHO OFF
SET TIME ON
prompt tmp/drop_tables.sql