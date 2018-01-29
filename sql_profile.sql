col sql_profile_name for a30
col sql_text         for a40
col status           for a10

select distinct p.name sql_profile_name
    , to_char(p.created,'YYYY-MM-DD HH24:MI:SS') created
    , dbms_lob.substr(p.sql_text,40,1) sql_text
    , p.force_matching 
    , p.status
    , s.sql_id    
 from dba_sql_profiles p
    , DBA_HIST_SQLSTAT s
where p.name=s.sql_profile(+)
  and p.name like '%&1%';
