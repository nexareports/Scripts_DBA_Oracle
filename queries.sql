select 
sql_text
from v$open_cursor
where sid=&1
/