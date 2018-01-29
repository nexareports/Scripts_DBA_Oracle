--set lines 250
--set pages 1000
COLUMN sid FORMAT 999999
COLUMN username FORMAT A10
COLUMN message FORMAT A90
COLUMN target format a10
COLUMN "Estimate End Time" format a20
Prompt  *** TE e TR estao em sec ***
SELECT s.sid sid,
       s.username,
       s.sql_id,
       sl.time_remaining "Remain Time(s)",
       sl.ELAPSED_SECONDS "Elap Time(s)",
       ROUND(sl.SOFAR/sl.TOTALWORK*100,2) "%_COMPLETE",
	   sl.target,
       sl.message,
       to_char(sysdate+sl.time_remaining/60/60/24,'YYYY-MM-DD hh24:mi') "Estimate End Time"
FROM   gv$session s,
       gv$session_longops sl
WHERE  s.sid     = sl.sid
AND    sl.time_remaining >= 1	
AND    s.serial# = sl.serial#
ORDER BY 4 desc;

COLUMN username clear
COLUMN message clear
COLUMN target clear