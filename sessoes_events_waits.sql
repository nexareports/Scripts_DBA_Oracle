set linesize  1000
set pagesize  32000
set trimspool on

column username format a15    wrapped
column spid     format a8
column event    format a40    wrapped
column blocks   format 999999

select  s.sid
,	s.username
,       p.spid     spid
,	s.sql_hash_value
,       sw.event   event
,	sw.seconds_in_wait
,       decode(sw.event,'db file sequential read', sw.p3,
                        'db file scattered read',  sw.p3,
                                             null) blocks
,	s.status                                             
from    v$session_wait sw
,       v$session      s
,       v$process      p
where   s.paddr = p.addr
and     sw.event     not in ('pipe get','client message')
and     sw.sid  = s.sid
--and	s.username is not null
and 	sw.event not like 'SQL%'
and	sw.seconds_in_wait >0
order by sw.seconds_in_wait desc
/
prompt __________________________
prompt @infouser
