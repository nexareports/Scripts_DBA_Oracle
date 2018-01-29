set verify off
set feed off
COL USERNAME FORMAT A17 WRAP;
COL CLIENT_INFO FORMAT A20 ;
COL SERVER   FORMAT A9 WRAP;
COL STATUS   FORMAT A8  WRAP;
COL PROGRAM  FORMAT A25 WRAP;
COL MACHINE  FORMAT A10 ;
col SSE FORMAT a11;
col LAST_CALL_ET for 99999;
col spid for a6;
col osuser for a8;
col USERNAME for a9;


 

SELECT  ''''||TO_CHAR(S.SID)||','||TO_CHAR(S.SERIAL#)||'''' SSE, 
                        S.SQL_ADDRESS, s.osuser,
                S.LAST_CALL_ET,--p.spid,
                        S.USERNAME USERNAME, 
                        S.STATUS STATUS,
                      --lpad(S.MACHINE,24) MACHINE, 
                      TO_CHAR(S.LOGON_TIME, 'DD/MM/YY HH24:MI:SS') HORA,
                      --lpad(S.CLIENT_INFO, 19) CLIENT_INFO,
                       -- s.server,  
s.program
                      --p.spid,
                      --s.lockwait                     
                      --p.pid
            FROM V$SESSION S, V$PROCESS P
            WHERE   P.ADDR (+) = S.PADDR AND
                        S.SID = &1
;

