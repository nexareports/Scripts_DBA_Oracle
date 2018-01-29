with tmp as 
(select 
to_char(replace(a.command||' '||'<OWNER>.<INDEX_NAME>'||' on '||trim(a.attr3)||trim(a.attr5)||' tablespace BIN_INDEX;','"','')) DDL2
from DBA_ADVISOR_ACTIONS a, DBA_ADVISOR_TASKS b
where a.task_id=b.task_id and a.command like '%CREATE INDEX%'
)
Select   unique ddl2 from tmp 
;