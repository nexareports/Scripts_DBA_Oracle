SELECT 'EXEC SUPGBD.DBMS_KILL('''||USERNAME||''','||b.SID||','||b.SERIAL#||');'
FROM   v$access a,
       v$session b
WHERE  a.sid   = b.sid
--AND    a.owner = ''
AND    a.object = '&objecto'
--AND    b.username=''
ORDER BY a.object
/