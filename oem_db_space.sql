col "Tbs (GB)" format 999999999999999.99
col "Tbs Used (Gb)" format 999999999999999.99
col "Tbs Free (Gb)" format 999999999999999.99
col target_name for a30
col host_name for a30

select 
  Host_name,
  TARGET_NAME,
  ROUND(SUM(TABLESPACE_SIZE)/1024/1024/1024,2)  "Tbs (GB)",
  ROUND(SUM(TABLESPACE_USED_SIZE)/1024/1024/1024,2) "Tbs Used (Gb)",
  ROUND(SUM(TABLESPACE_SIZE)/1024/1024/1024,2)-ROUND(SUM(TABLESPACE_USED_SIZE)/1024/1024/1024,2) "Tbs Free (Gb)"
from SYSMAN.MGMT$DB_TABLESPACES
group by Host_name,TARGET_NAME
order by 2,1 ;

col target_name clear
col "Tbs (GB)" clear
col "Tbs Used (Gb)" clear
col "Tbs Free (Gb)" clear
col host_name clear