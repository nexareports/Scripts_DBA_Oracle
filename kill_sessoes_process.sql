Select SE.USERNAME,SE.OSUSER,SE.LAST_CALL_ET,SE.LAST_CALL_ET/3600 HORA,SE.LOGON_TIME,SE.MACHINE,SE.TERMINAL,PR.SPID,SE.STATUS,SE.PROGRAM,SE.SID,SE.SERIAL#,
'ALTER SYSTEM KILL SESSION '''||SE.SID||','||SE.SERIAL#||''';' DBA, 'kill -9 '||PR.SPID
  from v$session se, v$process pr
   where se.status = 'INACTIVE'
      and se.username is not null
       and se.last_call_et > 600 --*24
--     AND SE.USERNAME = 'BDIAED'
          and pr.addr = se.paddr
  ORDER BY 1,2;
