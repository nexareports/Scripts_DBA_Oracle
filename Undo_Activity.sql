
--set lines 150
--set pages 999

REM
REM  Current transactions
REM
REM  Will show only last transaction by a user
REM
REM  May need to use 786472.1 for better picture 
REM  of activity


col username heading "User"
col name format a22 wrapped heading "Undo Segment Name"
col xidusn heading "Undo|Seg #"
col xidslot heading "Undo|Slot #"
col xidsqn heading "Undo|Seq #"
col ubafil heading "File #"
col ubablk heading "Block #"
col start_time format a10 word_wrapped heading "Started"
col status format a8 heading "Status"
col blk format 999,999,999 heading "KBytes"
col used_urec heading "Rows"

spool undoactivity.out

select start_time, username, r.name,  
ubafil, ubablk, t.status, (used_ublk*p.value)/1024 blk, used_urec
from v$transaction t, v$rollname r, v$session s, v$parameter p
where xidusn=usn
and s.saddr=t.ses_addr
and p.name='db_block_size'
order by 1;
spool off


