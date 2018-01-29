col "TARGET_NAME" for a40
col "METRIC_NAME" for a40
col Collected for a40
col "CPU%Load" for 999.99

--CPU Utilization Current
select  "MGMT$METRIC_CURRENT"."TARGET_NAME" as "TARGET_NAME",
  --"MGMT$METRIC_CURRENT"."METRIC_NAME" as "METRIC_NAME",
  --"MGMT$METRIC_CURRENT".column_label,
   to_char("MGMT$METRIC_CURRENT".collection_timestamp,'dd-mm-yyyy HH:MI:ss') Collected,
   --"MGMT$METRIC_CURRENT".key_value key_value,
   --"MGMT$METRIC_CURRENT".key_value2 key_value2,
   ROUND("MGMT$METRIC_CURRENT".value,2) as "CPU%Load"
 from "MGMT_VIEW"."MGMT$METRIC_CURRENT" "MGMT$METRIC_CURRENT"
where metric_name = 'Load'
 and column_label like '%CPU Utilization%'
 and COLLECTION_TIMESTAMP > sysdate - 1/24 
 order by "CPU%Load";
 
 
col "TARGET_NAME" clear
col "METRIC_NAME" clear
col Collected clear
col "CPU%Load" clear
