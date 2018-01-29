  select 
    trunc(to_date(st.start_timestamp),'MI'),upper(to_char(st.availability_status)) --into data, status
  from 
  sysman.MGMT$GROUP_DERIVED_MEMBERSHIPS O ,
      sysman.MGMT$TARGET T ,
      sysman.MGMT$AVAILABILITY_CURRENT st
  where     
       O.MEMBER_TARGET_TYPE in ('oracle_database', 'rac_database')
  and  T.TARGET_TYPE ='oracle_database'
  and  o.composite_target_name='ESI'
  and  o. member_target_guid = t.target_guid
  and  T.TARGET_GUID = ST.TARGET_GUID
  and T.DISPLAY_NAME =  upper('&1');