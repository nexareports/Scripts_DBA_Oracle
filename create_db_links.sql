SET HEADING OFF 
SET FEEDBACK OFF
SET ECHO OFF
SET TIME OFF
SET SERVEROUTPUT OFF
SET PAGESIZE 0
spool tmp/create_db_links_script.sql
select 
  'CREATE DATABASE LINK DBL_'||instance_name||' CONNECT TO SYSTEM IDENTIFIED BY "system!'||instance_name||'#02" USING '||chr(39)||''||instance_name||''||chr(39)||';'
from sysman.CM$MGMT_DB_DBNINSTANCEINFO_ECM
order by 1 desc;
spool off
PROMPT tmp/create_db_links_script.sql
SET HEADING ON 
SET FEEDBACK ON
SET TIME ON
SET SERVEROUTPUT ON
SET ECHO ON
