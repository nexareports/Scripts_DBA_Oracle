col handle for a40
col db_name for a20
select 'RC_PRD11' as CATALOG,DB_NAME,HANDLE, START_TIME, TAG from RC_PRD11.RC_BACKUP_PIECE_DETAILS where db_name = '&1' and handle = '&2'
UNION ALL
select 'RC_PRD12' as CATALOG,DB_NAME,HANDLE, START_TIME, TAG from RC_PRD12.RC_BACKUP_PIECE_DETAILS where db_name = '&1' and handle = '&2'
UNION ALL
select 'RC_QUA11' as CATALOG,DB_NAME,HANDLE, START_TIME, TAG from RC_QUA11.RC_BACKUP_PIECE_DETAILS where db_name = '&1' and handle = '&2'
UNION ALL
select 'RC_QUA12' as CATALOG,DB_NAME,HANDLE, START_TIME, TAG from RC_QUA12.RC_BACKUP_PIECE_DETAILS where db_name = '&1' and handle = '&2'
UNION ALL
select 'RC_DSV11' as CATALOG,DB_NAME,HANDLE, START_TIME, TAG from RC_DSV11.RC_BACKUP_PIECE_DETAILS where db_name = '&1' and handle = '&2'
UNION ALL
select 'RC_DSV12' as CATALOG,DB_NAME,HANDLE, START_TIME, TAG from RC_DSV12.RC_BACKUP_PIECE_DETAILS where db_name = '&1' and handle = '&2';