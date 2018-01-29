col OUT format a10
col "OUT/s" format a10
col sk format 999999
select
SESSION_KEY SK,INPUT_TYPE STATUS,
to_char(START_TIME,'yyyy-mm-dd hh24:mi') start_time,
to_char(END_TIME,'yyyy-mm-dd hh24:mi')   end_time,
round(elapsed_seconds/3600,2)                   hrs,
Output_bytes_display OUT,output_bytes_per_sec_display "OUT/s"
from V$RMAN_BACKUP_JOB_DETAILS
Where input_type like 'DB%'
order by session_key;

col OUT clear
col "OUT/s" clear
col sk clear

--Select unique input_type from V$RMAN_BACKUP_JOB_DETAILS;
