col OS_USERNAME for a20
col USERNAME for a20
col USERHOST for a35
 
select OS_USERNAME,USERNAME,USERHOST,timestamp, returncode,action_name,SES_ACTIONS
from dba_audit_trail
where timestamp > sysdate-2/24 and action_name in ('LOGON','LOGOFF','LOGOFF BY CLEANUP')
order by timestamp; 

-- and returncode > 0;