col type_qualifier1 for a15
col host_name for a30
col display_name for a30
select TYPE_QUALIFIER1,DISPLAY_NAME,HOST_NAME
from SYSMAN.MGMT$TARGET where target_type='oracle_database'
order by 1;
col type_qualifier1 clear
col host_name clear
col display_name clear