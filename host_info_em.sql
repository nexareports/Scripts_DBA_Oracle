--
-- JAF - 03/11/2017
--
-- HOST INFO FROM CLOUD CONTROL
--

select  t.target_name HOST_NAME,
		t.VERSION VERSION,
		t.PATCH_LEVEL PATCH_LEVEL,
		t.IP_ADDRESS IP_ADDRESS,
		os.DOMAIN DOMAIN,
		os.ma "32/64 bits",
		os.mem MEMORY,
		os.physical_cpu_count PHYSICAL_CPU_COUNT,
		os.logical_cpu_count LOGICAL_CPU_COUNT,
		os.VIRTUAL VIRTUAL from 
(select target_name, property_name, property_value from sysman.mgmt$target_properties where target_type = 'host' 
and property_name in ('Version','OS_patchlevel','IP_address')
and target_name in (select distinct host_name from sysman.mgmt$target where target_type IN ('rac_database','oracle_database')))
PIVOT ( max(property_value) for (property_name) in ('Version' as VERSION, 'OS_patchlevel' as PATCH_LEVEL, 'IP_address' as IP_ADDRESS)) t,
SYSMAN.MGMT$OS_HW_SUMMARY os
where os.target_name = t.target_name
UNION ALL
select  t.target_name HOST_NAME,
		t.VERSION VERSION,
		t.PATCH_LEVEL PATCH_LEVEL,
		t.IP_ADDRESS IP_ADDRESS,
		os.DOMAIN DOMAIN,
		os.ma "32/64 bits",
		os.mem MEMORY,
		os.physical_cpu_count PHYSICAL_CPU_COUNT,
		os.logical_cpu_count LOGICAL_CPU_COUNT,
		os.VIRTUAL VIRTUAL from
(select target_name, property_name, property_value from sysman.mgmt$target_properties@DBL_POEM2 where target_type = 'host' 
and property_name in ('Version','OS_patchlevel','IP_address')
and target_name in (select distinct host_name from sysman.mgmt$target@DBL_POEM2 where target_type IN ('rac_database','oracle_database'))) 
PIVOT ( max(property_value) for (property_name) in ('Version' as VERSION, 'OS_patchlevel' as PATCH_LEVEL, 'IP_address' as IP_ADDRESS))  t,
SYSMAN.MGMT$OS_HW_SUMMARY@DBL_POEM2 os
where os.target_name = t.target_name
order by HOST_NAME;