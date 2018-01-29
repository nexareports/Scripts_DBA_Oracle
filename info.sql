

set feed off
set timing off
set time off
col info for a100
exec dbms_output.put_line('===================================================================');
select 'BD: '||instance_name||' - '||'Machine: '||host_name||' - '||sysdate||' STARTUP: '||STARTUP_TIME INFO, (select unique sid from v$mystat) "Meu SID" from v$instance;
exec dbms_output.put_line('===================================================================');
select * from v$version;
exec dbms_output.put_line('===================================================================');
col comp_name format a30
select COMP_NAME,version,STATUS,MODIFIED from dba_registry;
col comp_name clear
col info clear
exec dbms_output.put_line('===================================================================');
select instance_number, instance_name, host_name, status from gv$instance;
exec dbms_output.put_line('===================================================================');
set feedback on
set timing on
@__conf