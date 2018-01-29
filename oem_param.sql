col cm_target_name for a15
col name for a35
col value for a30

select cm_target_name,name,value,last_collection_timestamp 
from SYSMAN.CM$MGMT_DB_INIT_PARAMS_ECM
where name like lower('%&1%') order by 1,2;

col cm_target_name clear
col name clear
col value clear
