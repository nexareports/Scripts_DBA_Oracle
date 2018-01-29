select 
'set echo on timing on'||chr(10)||
'spool D:\M04M\Scripts\output\'||instance_name||'_'||to_char(sysdate,'yyyymmddhh24mi')||'.txt'||chr(10)||
'Select sysdate Inicio from dual;' LOG_FILE 
from v$instance;

