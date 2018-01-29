
select
sql_id,count(*) Opened,
sql_text
from v$open_cursor c
where sid=&1
group by
sql_id,
sql_text
order by
2 DESC ;
