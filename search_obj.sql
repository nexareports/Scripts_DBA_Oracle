COL OWNER FOR A30
COL OBJECT_NAME FOR A60
COL OBJECT_TYPE FOR A40
Select owner,object_name,object_type,created,status from dba_objects where object_name like upper('%&1%');