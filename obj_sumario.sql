column Tab format 9999 heading "Tab"
column Ind format 9999 heading "Ind"
column Syn format 9999 heading "Syn"
column Vew format 9999 heading "Vew"
column Seq format 9999 heading "Seq"
column Prc format 9999 heading "Prc"
column Fun format 9999 heading "Fun"
column Pck format 9999 heading "Pck"
column Trg format 9999 heading "Trg"
column Dep format 9999 heading "Dep"

SELECT  SUBSTR(username,1,10) "User",
        COUNT(DECODE(o.type#, 2, o.obj#, '')) Tab,
        COUNT(DECODE(o.type#, 1, o.obj#, '')) Ind,
        COUNT(DECODE(o.type#, 5, o.obj#, '')) Syn,
        COUNT(DECODE(o.type#, 4, o.obj#, '')) Vew,
        COUNT(DECODE(o.type#, 6, o.obj#, '')) Seq,
        COUNT(DECODE(o.type#, 7, o.obj#, '')) Prc,
        COUNT(DECODE(o.type#, 8, o.obj#, '')) Fun,
        COUNT(DECODE(o.type#, 9, o.obj#, '')) Pck,
        COUNT(DECODE(o.type#,12, o.obj#, '')) Trg,
        COUNT(DECODE(o.type#,10, o.obj#, '')) Dep
  FROM  sys.obj$ o,  sys.dba_users U
 WHERE  u.user_id = o.owner# (+)
   AND  o.type# > 0
 GROUP  BY username;
 
 