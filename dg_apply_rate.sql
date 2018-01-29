set linesize 400
col Values for a65
col Recover_start for a21
select to_char(START_TIME,'dd.mm.yyyy hh24:mi:ss') "Recover_start",to_char(item)||' = '||to_char(sofar)||' '||to_char(units)||' '|| to_char(TIMESTAMP,'dd.mm.yyyy hh24:mi') "Values" from v$recovery_progress where start_time=(select max(start_time) from v$recovery_progress);