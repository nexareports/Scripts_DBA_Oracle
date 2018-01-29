select user_name,o.sid, osuser, machine, count(*) num_curs
from v$open_cursor o, v$session s
where o.sid=s.sid
group by user_name,o.sid, osuser, machine
order by num_curs desc;

select
c.sid as "OraSID",
c.address||':'||c.hash_value as "SQL Address",
COUNT(c.saddr) as "Cursor Copies"
from v$open_cursor c
group by
c.sid,
c.address||':'||c.hash_value
having
COUNT(c.saddr) > 20
order by
3 DESC ;

prompt select SQL_FULLTEXT from v$sql where ADDRESS ||':'||HASH_VALUE = 'valor' ;

