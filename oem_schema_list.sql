col Grupo for a12
col DB for a10
col Host for a30
col dbversion for a10
col schema for a25
select 
	--c.group_name 		Grupo,
	A.cm_target_name	DB,
	B.HOST_NAME			Host,
	B.DBVERSION, count(*)
	--A.username			Schema
from SYSMAN.CM$MGMT_DB_USERS_ECM A
inner join sysman.CM$MGMT_DB_DBNINSTANCEINFO_ECM B on (a.cm_target_name=b.INSTANCE_NAME)
inner join MGMT$GROUP_MEMBERS c on (a.CM_TARGET_GUID=c.TARGET_GUID)
where 
--
(a.username not in ('SPATIAL_WFS_ADMIN_USR','SPATIAL_CSW_ADMIN_USR','APEX_PUBLIC_USER','DIP','MDDATA','XS$NULL','DBAMNT','APEX_040200',
'ORACLE_OCM','SCOTT','DBSNMP','OLAPSYS','SI_INFORMTN_SCHEMA','OWBSYS','ORDPLUGINS','XDB','SYSMAN','ANONYMOUS','CTXSYS','ORDDATA','SYSKM','SYSDG','SYSBACKUP',
'RMAN_USR','OEM_OPER_USER','AUDSYS','DICDADOS','OJVMSYS',
'OWBSYS_AUDIT','APEX_030200','APPQOSSYS','WMSYS','EXFSYS','ORDSYS','MDSYS','FLOWS_FILES','SYSTEM','SYS','MGMT_VIEW','OUTLN','OEM_MON','REPSQL') 
and substr(a.username,1,2) not in ('T0','TT','TT','J0','J1','B0','B1'))
--
and a.cm_target_name not like 'S%'
--
--and ( c.group_name like '%ESI_%' and c.group_name not like '%DG' ) 
group by 
	A.cm_target_name	,
	B.HOST_NAME			,
	B.DBVERSION
order by 1,2;

col Grupo clear
col DB clear
col Host clear
col dbversion clear
col schema clear
/*
select                                    
  INSTANCE_NAME,                          
  DBVERSION,                              
  HOST_NAME,                              
  STARTUP_TIME,                           
  LOG_MODE,                               
  CHARACTERSET,                           
  creation_date,                          
  Last_collection_timestamp               
from sysman.CM$MGMT_DB_DBNINSTANCEINFO_ECM
order by 1 desc      

CM_TARGET_GUID
*/                     

