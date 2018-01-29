  SELECT   'kill -9 ' || b.spid
    /* ,
             a.sid,
             a.serial#,
             a.USERNAME,
             a.OSUSER,
             a.MACHINE,
             a.TERMINAL,
             a.PROGRAM,
             a.LOGON_TIME,
             a.CLIENT_IDENTIFIER,
             b.spid AS "OS PID",
             ROUND (last_call_et / 60 / 60, 2) AS "Horas em espera"*/
    FROM   v$session a, V$PROCESS b
   WHERE       (b.addr(+) = a.paddr)
           AND a.status = 'INACTIVE'
           AND a.program LIKE 'oraagent.bin%'