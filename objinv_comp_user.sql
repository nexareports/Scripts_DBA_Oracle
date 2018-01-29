--set lines 250
--set pages 1000
--set serveroutput on SIZE 1000000;
--set feed off


--set head off
Select 
decode(object_type,
'PACKAGE BODY', 'alter package '||owner||'.'||object_name||' compile body;',
'JAVA CLASS', 'alter java class "'||object_name||'" compile;',
'alter '||object_type||' '||owner||'.'||object_name||' compile;') CMD
from dba_objects where status='INVALID';
--set head on
--set feed on


spool c:\tmp_comp.sql
/
spool off
@c:\tmp_comp.sql

