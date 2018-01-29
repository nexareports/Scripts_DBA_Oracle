col username for a25
col event for a40
col ROW_WAIT_OBJ# for 999999999999999999
Select sid,username,ROW_WAIT_OBJ#,ROW_WAIT_FILE#,ROW_WAIT_BLOCK#,ROW_WAIT_ROW#,event,PREV_SQL_ID,sql_id
from v$session where status='ACTIVE' and username is not null
order by 3,4,5,6;
col ROW_WAIT_OBJ# clear