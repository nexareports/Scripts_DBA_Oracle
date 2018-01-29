select	/*+ rule */ se.USERNAME, 
	l.sid, 
	l.type, 
	l.id1, 
	l.id2,
	lmode, 
	request, 
	block, 
	do.OBJECT_NAME, 
	do.owner 
from	v$lock l, dba_objects do, v$session se 
where	l.sid>5 
and	l.sid=se.sid 
and	l.id1=do.object_id(+) 
and	l.sid in (select sid from v$lock where block = 1) 
order	by block desc, l.sid;