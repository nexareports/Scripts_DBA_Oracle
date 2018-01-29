select SQL_TEXT, executions
from v$sqlarea
where hash_value='&1'
/