set lines 250
set pages 1000
col name format a20
col username format a20
select username, 
       t.start_time, 
       to_char(s.sid) Sid,
       r.name, 
       sa.hash_value,
	 decode(t.space, 'YES', 'SPACE TX',
          decode(t.recursive, 'YES', 'RECURSIVE TX',
             decode(t.noundo, 'YES', 'NO UNDO TX', t.status)
       )) status			 
from gv$transaction t, gv$rollname r, gv$session s, gv$sqlarea sa
where t.xidusn = r.usn
  and t.ses_addr = s.saddr
	and sa.HASH_VALUE=s.SQL_HASH_VALUE
	/
	