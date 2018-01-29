Select event,sql_id,row_wait_file#,row_wait_obj#,row_wait_block#,row_wait_row#,count(*) 
from gv$session
where event not like 'SQL%'
group by  event,sql_id,row_wait_file#,row_wait_obj#,row_wait_block#,row_wait_row#
having count(*)>1
order by 7 desc;