select owner, object_name, object_type 
from dba_objects 
where object_name like 'QUEST_SPC_TMP_%';


exec quest_spc_util.drop_object ('SIEBEL', 'QUEST_SPC_TMP_455144_LRTAB', 'TABLE') ;


exec quest_spc_util.drop_object ('SIEBEL', 'S_EVT_ACT', 'LW') ;