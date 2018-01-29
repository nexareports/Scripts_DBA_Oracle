col host_name for a30
col target_name for a38
col property_name for a20
col property_value for a5

SELECT mgmt$target.host_name
 , mgmt$target.target_name
 --, mgmt$target.target_type
 , mgmt$target_properties.property_name
 , mgmt$target_properties.property_value
 FROM mgmt$target
 , mgmt$target_properties
 WHERE ( mgmt$target.target_name = mgmt$target_properties.target_name )
 AND ( mgmt$target.target_type = mgmt$target_properties.target_type )
 and ( mgmt$target.target_type = 'oracle_listener' )
 and ( mgmt$target_properties.property_name = 'Port' )
 and upper(mgmt$target.target_name) like '%&1%';
 
col host_name clear
col target_name clear
col property_name clear
col property_value clear