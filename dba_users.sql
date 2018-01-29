col username for a30
col account_status for a30
col profile for a15

Select user_id,username,created,account_status,profile,default_tablespace,temporary_tablespace 
from dba_users where username like upper('%&1%') order by 1;

col username clear
col account_status clear
col profile clear