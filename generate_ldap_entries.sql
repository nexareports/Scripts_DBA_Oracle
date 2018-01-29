spool M:\Scripts\Output\LDAP.ldif
select 
--p3.property_value||', '||t.target_name||' = (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = '||p1.property_value||')(PORT = '||p2.property_value||'))) (CONNECT_DATA = (service_name = '||p3.property_value||')))'
--
'dn## cn='||t.target_name||',cn=OracleContext,dc=gest,dc=bes'||chr(10)||
'cn## '||t.target_name||chr(10)||
'objectclass## top'||chr(10)||
'objectclass## orclNetService'||chr(10)||
'orclnetdescstring## (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = '||p1.property_value||')(PORT = '||p2.property_value||'))) (CONNECT_DATA = (service_name = '||t.target_name||')))'||chr(10)
from SYSMAN.MGMT_TARGETS t, SYSMAN.MGMT_TARGET_PROPERTIES p1, SYSMAN.MGMT_TARGET_PROPERTIES p2, SYSMAN.MGMT_TARGET_PROPERTIES p3
where upper(t.TARGET_NAME) like '%' 
and t.target_type='oracle_database'
and t.target_guid = p1.target_guid
and t.target_guid = p2.target_guid
and t.target_guid = p3.target_guid(+)
and p1.property_name='MachineName'
and p2.property_name='Port'
and p3.property_name(+)='ServiceName'
order by 1;

spool off;

Prompt ldapmodify -h vopenldap.marte.gbes -p 389 -D "cn=admin,dc=bes" -w "|F9HDd l9^?." -f "M:\Scripts\Output\LDAP.ldif" -v

/*
S2PTIB1 = (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = sltibbp12.BESP.DSP.GBES)(PORT = 1532))) (CONNECT_DATA = (service_name = )))

dn## cn=D1BPM,cn=OracleContext,dc=gest,dc=bes
cn## D1BPM
objectclass## top
objectclass## orclNetService
orclnetdescstring## (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = SLCSTDD01.Marte.GBES)(PORT = 1531)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = D1BPM) ) )
*/