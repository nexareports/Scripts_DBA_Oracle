--
-- JAF - 31/10/2017
--
-- LISTENER INFO FROM CLOUD CONTROL
--

select  LISTENER_NAME, 
        CASE 
        WHEN LISTENER_NAME = 'LISTENER' THEN 'ASM'
        WHEN substr(LISTENER_NAME,0,5) = 'LSNR_' THEN substr(LISTENER_NAME,6)
        ELSE 'N/A' 
        END DB_NAME,
        HOST_NAME, PORT from 
(select TARGET_NAME, TARGET_GUID, property_name, property_value from sysman.MGMT$TARGET_PROPERTIES 
where target_type = 'oracle_listener' and property_name in ('LsnrName','Machine','Port')
)
PIVOT ( max(property_value) for (property_name) in ('LsnrName' as LISTENER_NAME, 'Machine' as HOST_NAME, 'Port' as PORT) )
order by HOST_NAME;