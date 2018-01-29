col TARGET_NAME for a40
col CA_NAME for a60
Select TARGET_NAME,CA_NAME,START_TIME,END_TIME,status from MGMT$CA_EXECUTIONS where target_name like upper('%&1%') order by START_TIME;
col TARGET_NAME clear
col CA_NAME clear