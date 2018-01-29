set pages 500
set lines 200
set long 100000

exec dbms_metadata.set_transform_param(dbms_metadata.SESSION_TRANSFORM,'SQLTERMINATOR',TRUE);
select dbms_metadata.get_ddl( 'USER', 'OPS$BTPBK' ) from dual
UNION ALL
select dbms_metadata.get_granted_ddl( 'SYSTEM_GRANT', 'OPS$BTPBK' ) from dual
UNION ALL
select dbms_metadata.get_granted_ddl( 'OBJECT_GRANT', 'OPS$BTPBK' ) from dual
UNION ALL
select dbms_metadata.get_granted_ddl( 'ROLE_GRANT', 'OPS$BTPBK' ) from dual; 