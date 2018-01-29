Select
file_id,
AUTOEXTENSIBLE,
round(bytes/1024/1024) MB,
'alter database tempfile '||file_id||' resize '||to_char(round(round(bytes/1024/1024)+(round(bytes/1024/1024)*0.20)))||'M;' "cmd+20%"
from dba_temp_files 
where tablespace_name='&1'
order by 1;