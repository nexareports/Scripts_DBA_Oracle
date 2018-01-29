clear columns;
col sid format 999999
col username format a15
col process format a8
col object format a20
col terminal format a12
col lmode format a5
--set lines 250
--set pages 1000

select s.sid, s.serial#,
       decode(s.process, null,
          decode(substr(p.username,1,1), '?',   upper(s.osuser), p.username),
          decode(       p.username, 'ORACUSR ', upper(s.osuser), s.process)
       ) process,
       nvl(s.username, 'SYS ('||substr(p.username,1,4)||')') username,
       decode(s.terminal, null, rtrim(p.terminal, chr(0)),
              upper(s.terminal)) terminal,
       decode(l.type,
          -- Long locks
                      'TM', 'DML/DATA ENQ',   'TX', 'TRANSAC ENQ',
                      'UL', 'PLS USR LOCK',
          -- Short locks
                      'BL', 'BUF HASH TBL',  'CF', 'CONTROL FILE',
                      'CI', 'CROSS INST F',  'DF', 'DATA FILE   ',
                      'CU', 'CURSOR BIND ',
                      'DL', 'DIRECT LOAD ',  'DM', 'MOUNT/STRTUP',
                      'DR', 'RECO LOCK   ',  'DX', 'DISTRIB TRAN',
                      'FS', 'FILE --set    ',  'IN', 'INSTANCE NUM',
                      'FI', 'SGA OPN FILE',
                      'IR', 'INSTCE RECVR',  'IS', 'GET STATE   ',
                      'IV', 'LIBCACHE INV',  'KK', 'LOG SW KICK ',
                      'LS', 'LOG SWITCH  ',
                      'MM', 'MOUNT DEF   ',  'MR', 'MEDIA RECVRY',
                      'PF', 'PWFILE ENQ  ',  'PR', 'PROCESS STRT',
                      'RT', 'REDO THREAD ',  'SC', 'SCN ENQ     ',
                      'RW', 'ROW WAIT    ',
                      'SM', 'SMON LOCK   ',  'SN', 'SEQNO INSTCE',
                      'SQ', 'SEQNO ENQ   ',  'ST', 'SPACE TRANSC',
                      'SV', 'SEQNO VALUE ',  'TA', 'GENERIC ENQ ',
                      'TD', 'DLL ENQ     ',  'TE', 'EXTEND SEG  ',
                      'TS', 'TEMP SEGMENT',  'TT', 'TEMP TABLE  ',
                      'UN', 'USER NAME   ',  'WL', 'WRITE REDO  ',
                      'TYPE='||l.type) type,
       decode(l.lmode, 0, 'NONE', 1, 'NULL', 2, 'RS', 3, 'RX',
                       4, 'S',    5, 'RSX',  6, 'X',
                       to_char(l.lmode) ) lmode,
       decode(l.request, 0, 'NONE', 1, 'NULL', 2, 'RS', 3, 'RX',
                         4, 'S', 5, 'RSX', 6, 'X',
                         to_char(l.request) ) lrequest,
       decode(l.type, 'MR', decode(u.name, null,
                            'DICTIONARY OBJECT', u.name||'.'||o.name),
                      'TD', u.name||'.'||o.name,
                      'TM', u.name||'.'||o.name,
                      'RW', 'FILE#='||substr(l.id1,1,3)||
                      ' BLOCK#='||substr(l.id1,4,5)||' ROW='||l.id2,
                      'TX', 'RS+SLOT#'||l.id1||' WRP#'||l.id2,
                      'WL', 'REDO LOG FILE#='||l.id1,
                      'RT', 'THREAD='||l.id1,
                      'TS', decode(l.id2, 0, 'ENQUEUE',
                                             'NEW BLOCK ALLOCATION'),
                      'ID1='||l.id1||' ID2='||l.id2) object
from   sys.v_$lock l, sys.v_$session s, sys.obj$ o, sys.user$ u,
       sys.v_$process p
where  s.paddr  = p.addr(+)
  and  l.sid    = s.sid
  and  l.id1    = o.obj#(+)
  and  o.owner# = u.user#(+)
  and  l.type   <> 'MR'
UNION ALL                          /*** LATCH HOLDERS ***/
select s.sid, s.serial#, s.process, s.username, s.terminal,
       'LATCH', 'X', 'NONE', h.name||' ADDR='||rawtohex(laddr)
from   sys.v_$process p, sys.v_$session s, sys.v_$latchholder h
where  h.pid  = p.pid
  and  p.addr = s.paddr
UNION ALL                         /*** LATCH WAITERS ***/
select s.sid, s.serial#, s.process, s.username, s.terminal,
       'LATCH', 'NONE', 'X', name||' LATCH='||p.latchwait
from   sys.v_$session s, sys.v_$process p, sys.v_$latch l
where  latchwait is not null
  and  p.addr      = s.paddr
  and  p.latchwait = l.addr
  /
  