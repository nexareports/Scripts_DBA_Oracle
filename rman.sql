COL INPUT_TYPE                   FOR a20
COL OUTPUT_DEVICE_TYPE           FOR a10
COL STATUS                       FOR a23
COL INPUT_BYTES_DISPLAY          FOR a11
COL OUTPUT_BYTES_DISPLAY         FOR a12
COL TIME_TAKEN                   FOR a10

COL INPUT_PER_SEC                FOR a14
COL OUTPUT_PER_SEC               FOR a14
COL COM_RATIO                    FOR 999.99

SET PAGESIZE 3000 LINES 200 HEADING on

prompt 
prompt 

clear breaks
prompt Number of days back from today to report :

SELECT start_time
     , end_time
     , output_device_type
     , input_type
     , status
     , TIME_TAKEN_DISPLAY as time_taken
     , INPUT_BYTES_DISPLAY
     , INPUT_BYTES_PER_SEC_DISPLAY as input_per_sec
     , OUTPUT_BYTES_DISPLAY
     , OUTPUT_BYTES_PER_SEC_DISPLAY as output_per_sec
     , compression_ratio as com_ratio
  FROM v$rman_backup_job_details 
  where start_time >= trunc(sysdate) - &1
  ORDER BY start_time, output_device_type;
 
