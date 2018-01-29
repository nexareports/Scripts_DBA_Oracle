--set lines 250
--set pages 1000
COLUMN username FORMAT A10
COLUMN message FORMAT A80
COLUMN target format a10
Prompt  *** TE e TR estao em sec ***
SELECT s.inst_id,
	   s.sid sid,
       s.username,
       s.sql_id,
       sl.time_remaining "Remain Time(s)",
       sl.ELAPSED_SECONDS "Elap Time(s)",
       ROUND(sl.SOFAR/sl.TOTALWORK*100,2) "%_COMPLETE",
	   sl.target,
       sl.message
FROM   gv$session s,
       gv$session_longops sl
WHERE  s.sid     = sl.sid
AND	   s.inst_id = sl.inst_id	
AND    sl.time_remaining >= 1	
AND    s.serial# = sl.serial#
ORDER BY 5 desc;

COLUMN username clear
COLUMN message clear
COLUMN target clear