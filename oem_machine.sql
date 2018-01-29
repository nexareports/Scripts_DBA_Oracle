
col impl for a50
col vendor_name for a15
col name for a40
col bus for a30
col resource_name for a25
col mount_location for a35
col mount_options for a30
col domain for a20
col OS_SUMMARY for a20
col SYSTEM_CONFIG for a20
col OS_VENDOR for a20
col DISTRIBUTOR_VERSION for a20
col source for a20
col PARAM for a20
col value for a40
col Nome for a50
col version for a30

select FREQ_IN_MHZ,ECACHE_IN_MB,IMPL from SYSMAN.CM$EM$ECM_HW_CPU where UPPER(CM_TARGET_NAME) like UPPER('%&1%');
select VENDOR_NAME,name,BUS from SYSMAN.CM$EM$ECM_HW_IOCARD where UPPER(CM_TARGET_NAME) like UPPER('%&1%');
select RESOURCE_NAME,MOUNT_LOCATION,type,DISK_SPACE_IN_GB,MOUNT_OPTIONS from SYSMAN.CM$MGMT_ECM_OS_FILESYSTEM where UPPER(CM_TARGET_NAME) like UPPER('%&1%');
select DOMAIN,OS_SUMMARY,SYSTEM_CONFIG,MEM,CPU_COUNT,PHYSICAL_CPU_COUNT,LOGICAL_CPU_COUNT,OS_VENDOR,DISTRIBUTOR_VERSION from SYSMAN.MGMT$OS_HW_SUMMARY where UPPER(HOST_NAME) like UPPER('%&1%');
select source,name PARAM,value from SYSMAN.MGMT$OS_KERNEL_PARAMS where UPPER(HOST) like UPPER('%&1%');
--select name NOME,version,INSTALLATION_DATE from SYSMAN.CM$MGMT_ECM_OS_COMPONENT where UPPER(CM_TARGET_NAME) like UPPER('%&1%'); 


col impl clear
col vendor_name clear
col name clear
col bus clear
col resource_name clear
col mount_location clear
col mount_options clear
col domain clear
col OS_SUMMARY clear
col SYSTEM_CONFIG clear
col OS_VENDOR clear
col DISTRIBUTOR_VERSION clear
col source clear
col PARAM clear
col value clear
col Nome clear
col version clear