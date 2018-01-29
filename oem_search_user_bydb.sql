col username for a15
col default_tablespace for a20
col temporary_tablespace for a20
col cm_snapshot_type for a20
col cm_target_name for a15

select cm_target_name,username,cm_snapshot_type,default_tablespace,temporary_tablespace,created,expiry_date,last_collection_timestamp
from SYSMAN.CM$MGMT_DB_USERS_ECM where cm_target_name like upper('%&1%');

col username clear
col default_tablespace clear
col temporary_tablespace clear
col cm_snapshot_type clear
col cm_target_name clear