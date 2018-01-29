select
c.target_name,
  c.host_name,
  p.property_value
FROM mgmt$target c,
  mgmt$target_properties p
WHERE c.target_type =p.target_type
AND c.target_name   =p.target_name
AND p.target_type   = 'oracle_database'
AND p.property_name = 'Port' ;






--Query para colocar em LDAP:
SELECT 'dn: cn='||upper(c.target_name)||',cn=OracleContext,dc=onr,dc=esi,dc=pt
cn:'||upper(c.target_name)||'
objectclass: top
objectclass: orclNetService
orclnetdescstring: (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST='||upper(c.host_name)||')(PORT='||p.property_value||'))(CONNECT_DATA=(SERVICE_NAME='||upper(c.target_name)||')))
'
FROM mgmt$target c,
  mgmt$target_properties p
WHERE c.target_type =p.target_type and
c.target_name   =p.target_name and
 p.target_type   = 'oracle_database'
AND p.property_name = 'Port' ;