 
set lines 320 
 
col reason format a30
col suggested_action format a30
col advisor_name format a15
select to_char(creation_time,'DD-MM-YYYY HH24:MI') Data,
instance_name,
advisor_name,
reason,
suggested_action 
from dba_outstanding_alerts;

col advisor_name clear
col reason clear 
col suggested_action clear
 
