select 'ALTER '||object_type||' '||object_name||' STORAGE (MAXEXTENTS UNLIMITED);'
from user_objects
where object_tpye in ('TABLE','INDEX')
/
