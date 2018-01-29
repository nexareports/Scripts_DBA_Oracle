set lines 250
set pages 1000
set feed off
select 
	sid session_id,
	decode(type, 
		'MR', 'Media Recovery', 
		'RT', 'Redo Thread',
		'UN', 'User Name',
		'TX', 'Transaction',
		'TM', 'DML',
		'UL', 'PL/SQL User Lock',
		'DX', 'Distributed Xaction',
		'CF', 'Control File',
		'IS', 'Instance State',
		'FS', 'File Set',
		'IR', 'Instance Recovery',
		'ST', 'Disk Space Transaction',
		'TS', 'Temp Segment',
		'IV', 'Library Cache Invalidation',
		'LS', 'Log Start or Switch',
		'RW', 'Row Wait',
		'SQ', 'Sequence Number',
		'TE', 'Extend Table',
		'TT', 'Temp Table',
		type) lock_type,
         decode(request,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(request)) mode_requested,
         	 ctime last_convert,
	 decode(block,
	        0, 'Not Blocking',  /* Not blocking any other processes */
		1, 'Blocking',      /* This lock blocks other processes */
		2, 'Global',        /* This lock is global, so we can't tell */
		to_char(block)) blocking_others
      from v$lock
      where block = 1
      /

select /*+ rule */ se.USERNAME, l.sid, l.type, 
l.id1, l.id2, lmode, request, block, do.OBJECT_NAME, do.owner 
from v$lock l, dba_objects do, v$session se 
where l.sid>5
and l.sid=se.sid and l.id1=do.object_id(+)
and l.sid in (select sid
from v$lock
where block = 1)
order by block desc, l.sid
/
col machine format a35
Select sid,machine,sql_hash_value,round(last_call_et/60) last_call_M
from v$session where sid in
(select sid
from v$lock
where block = 1)
/

col machine clear
set feed on

prompt @infouser
prompt @sqltext
