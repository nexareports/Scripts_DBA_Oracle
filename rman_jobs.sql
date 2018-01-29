SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
       ROUND(TIME_REMAINING/60/60,2) "TIME REMAINING (Hours)",
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   GV$SESSION_LONGOPS
WHERE  OPNAME LIKE 'RMAN%'
AND    OPNAME NOT LIKE '%aggregate%'
AND    TOTALWORK != 0
AND    SOFAR <> TOTALWORK;