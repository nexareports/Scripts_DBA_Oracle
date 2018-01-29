--objectos criados numa data x
prompt Objectos novos:     AA-MM-DD

select OBJECT_NAME, OBJECT_TYPE, CREATED, LAST_DDL_TIME, STATUS
from user_objects
where to_char(created)='&data'
/
