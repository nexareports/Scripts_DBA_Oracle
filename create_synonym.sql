SET echo off
SET feedback off
SET term off
SET pagesize 0
SET newpage 0
SET space 0
set trimspool on
spool tmp/create_synonym.sql
Select
'create synonym &1..'||object_name||' for '||' &2..'||object_name||';'
from dba_objects where owner='&2' and object_type in ('TABLE','VIEW','FUNCTION','PROCEDURE','SEQUENCE','PACKAGE BODY','MATERIALIZED VIEW','TYPE');

spoo off
SET feedback on for 6 or more rows
SET term on
SET pagesize 3000
set trimspool off
set newpage 1	
set space 1
set trimspool off
prompt tmp/create_synonym.sql

/*
Select
unique object_type--,'create synonym RW_SIFAPFCT.'||object_name||' for '||' SIFAP_FCT.'||object_name||';'
from dba_objects where owner='SIFAP_FCT' and object_type not in ('LOB','JOB','INDEX');
*/