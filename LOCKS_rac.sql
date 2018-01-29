SELECT   DISTINCT
            s1.username
         || '@'
         || s1.machine
         || ' ( INST='
         || s1.inst_id
         || ' SID='
         || s1.sid
         || ' ) is blocking '
         || s2.username
         || '@'
         || s2.machine
         || ' ( INST='
         || s2.inst_id
         || ' SID='
         || s2.sid
         || ' ) '
            AS blocking_status
  FROM   gv$lock l1,
         gv$session s1,
         gv$lock l2,
         gv$session s2
 WHERE       s1.sid = l1.sid
         AND s2.sid = l2.sid
         AND s1.inst_id = l1.inst_id
         AND s2.inst_id = l2.inst_id
         AND l1.block > 0
         AND l2.request > 0
         AND l1.id1 = l2.id1
         AND l1.id2 = l2.id2;