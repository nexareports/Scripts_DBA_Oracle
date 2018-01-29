SELECT 'EXEC SUPGBD.DBMS_KILL('''||USERNAME||''','||b.SID||','||b.SERIAL#||');' comando,--'alter system kill session '||chr(39)||b.sid||','||b.serial#||chr(39)||';' Comando,
       a.object,
       a.type,
       a.sid,
       b.username,
       b.osuser,
       b.program,logon_time,b.status
FROM   v$access a,
       v$session b
WHERE  a.sid   = b.sid
--AND    a.owner = '' 
AND    a.object = '&objecto'
--AND    b.username=''
ORDER BY a.object
/