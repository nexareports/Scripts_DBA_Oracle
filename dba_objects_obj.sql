col owner format a15
col object_type format a15
col object_name format a15
Select owner,object_type,object_name,created,timestamp,last_ddl_time
from dba_objects where object_name='&1';

col owner clear
col object_type clear
col object_name clear
