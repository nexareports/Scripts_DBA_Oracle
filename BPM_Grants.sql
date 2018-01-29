

Select 'grant select on '||owner||'.'||object_name||' to RL_BPMAPP;'  --, object_type
from dba_objects where owner like 'TW%' and created>trunc(sysdate) and object_type not in ('INDEX','FUNCTION','LOB');