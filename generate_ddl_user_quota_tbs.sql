set pages 500
set lines 200
set long 100000

exec dbms_metadata.set_transform_param(dbms_metadata.SESSION_TRANSFORM,'SQLTERMINATOR',TRUE);

select (case 
        when ((select count(*)
               from   dba_users
               where  username = '&&Username') > 0)
        then  dbms_metadata.get_ddl ('USER', '&&Username') 
        else  to_clob ('   -- Note: User not found!')
        end ) Extracted_DDL from dual
UNION ALL
select (case 
        when ((select count(*)
               from   dba_ts_quotas
               where  username = '&&Username') > 0)
        then  dbms_metadata.get_granted_ddl( 'TABLESPACE_QUOTA', '&&Username') 
        else  to_clob ('   -- Note: No TS Quotas found!')
        end ) from dual
UNION ALL
select (case 
        when ((select count(*)
               from   dba_role_privs
               where  grantee = '&&Username') > 0)
        then  dbms_metadata.get_granted_ddl ('ROLE_GRANT', '&&Username') 
        else  to_clob ('   -- Note: No granted Roles found!')
        end ) from dual
UNION ALL
select (case 
        when ((select count(*)
               from   dba_sys_privs
               where  grantee = '&&Username') > 0)
        then  dbms_metadata.get_granted_ddl ('SYSTEM_GRANT', '&&Username') 
        else  to_clob ('   -- Note: No System Privileges found!')
        end ) from dual
UNION ALL
select (case 
        when ((select count(*)
               from   dba_tab_privs
               where  grantee = '&&Username') > 0)
        then  dbms_metadata.get_granted_ddl ('OBJECT_GRANT', '&&Username') 
        else  to_clob ('   -- Note: No Object Privileges found!')
        end ) from dual
/