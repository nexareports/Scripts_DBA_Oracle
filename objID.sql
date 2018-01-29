select 
'ID: '||object_id||chr(10)||
'Owner: '||owner||chr(10)||
'Obj Type: '||object_type||chr(10)||
'Obj Name: '||object_name||chr(10)||
'Status: '||status||chr(10)||
'Last DDL: '||last_ddl_time||chr(10)||
'Timestamp: '||timestamp||chr(10)||
'Created: '||created||chr(10)||
'Subobject: '||subobject_name OBJ
from dba_objects
where object_id in (&1);
