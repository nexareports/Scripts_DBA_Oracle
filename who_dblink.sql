col sid for 999999
col ORIGIN for a25
col GTXID for a35
col USERNAME for a10
col LSESSION for a20
SELECT /*+ ORDERED */ s.sid
     , substr(s.username,1,15)  USERNAME
     , substr(s.ksusemnm,1,10)||'-'|| substr(s.ksusepid,1,10) "ORIGIN"
     , substr(g.K2GTITID_ORA,1,35) "GTXID"
     , substr(s.indx,1,4)||'.'|| substr(s.ksuseser,1,5) "LSESSION" 
     , substr(decode(bitand(ksuseidl,11),1,'ACTIVE',0,decode(bitand(ksuseflg,4096),0,'INACTIVE','CACHED'),2,'SNIPED',3,'SNIPED', 'KILLED'),1,1) "S",substr(w.event,1,10) "WAITING"
  FROM x$k2gte g, x$ktcxb t, x$ksuse s, v$session_wait w ,v$session s
 WHERE g.K2GTDXCB =t.ktcxbxba
   AND g.K2GTDSES=t.ktcxbses
   AND s.addr=g.K2GTDSES
   AND w.sid=s.indx
   AND w.sid=s.sid
/
