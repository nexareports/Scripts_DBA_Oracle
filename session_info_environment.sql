Select a.name,decode(upper(a.value),upper(b.value),'==','!=') "Igual?",a.value,sql_feature 
from v$ses_optimizer_env a, v$parameter b 
where a.name=b.name and a.sid=&1;
