col sid for 9999
col OSUSER for a10
col object for a25
col TYPE for a8

SELECT b.SID,b.SERIAL#,USERNAME,b.osuser,
       a.type,
       a.object,
       b.program,
       b.status,
       TO_CHAR(b.LOGON_TIME, 'DD/MM/YY HH24:MI:SS') HORA
FROM   v$access a,
       v$session b
WHERE  a.sid   = b.sid
--AND    a.owner = '' 
AND    a.object = '&objecto'
--AND    b.username=''
ORDER BY a.object
/


select distinct B.INST_ID , B.USERNAME , B.sid 
FROM SYS.X$KGLPN A , GV$SESSION B , SYS.X$KGLOB C   
where a.KGLPNUSE =  B.SADDR  
and UPPER(C.KGLNAOBJ )  like  UPPER('&objecto')   
and a.KGLPNHDL =  C.KGLHDADR  ;