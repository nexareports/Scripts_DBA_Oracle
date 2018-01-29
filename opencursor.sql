set lines 250
set pages 1000
col sess format a10
select 
to_char(sid) sess,
hash_value,
sql_text
from v$open_cursor
where sid=&1
/
