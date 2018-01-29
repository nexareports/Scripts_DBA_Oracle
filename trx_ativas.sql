--set lines 250
--set pages 1000
col name format a20
col username format a20
select username, 
       t.start_time, 
       to_char(s.sid) Sid,
       r.name, 
       sa.sql_id,
	 decode(t.space, 'YES', 'SPACE TX',
          decode(t.recursive, 'YES', 'RECURSIVE TX',
             decode(t.noundo, 'YES', 'NO UNDO TX', t.status)
       )) status			 
from sys.v_$transaction t, sys.v_$rollname r, sys.v_$session s, sys.v_$sqlarea sa
where t.xidusn = r.usn
  and t.ses_addr = s.saddr
	and sa.sql_id=s.sql_id
	/
	