col host_name for a25
col CHARACTERSET for a15

select 
  INSTANCE_NAME,
  DBVERSION,
  HOST_NAME,
  STARTUP_TIME,
  LOG_MODE,
  CHARACTERSET,
  creation_date,
  Last_collection_timestamp
from sysman.CM$MGMT_DB_DBNINSTANCEINFO_ECM
order by 1 desc;

col host_name clear
col CHARACTERSET clear