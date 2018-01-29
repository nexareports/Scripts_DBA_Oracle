SELECT   ses.username, SUBSTR (ses.program, 1, 19) command, tra.used_ublk
  FROM   v$session ses, v$transaction tra
 WHERE   ses.saddr = tra.ses_addr;