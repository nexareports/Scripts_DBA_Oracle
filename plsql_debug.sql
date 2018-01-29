col PLSQL_DEBUG for a30
col PLSQL_WARNINGS for a30

SELECT owner, name, type, PLSQL_DEBUG, PLSQL_WARNINGS
FROM dba_plsql_object_settings
WHERE plsql_debug='TRUE' and owner='&1'
ORDER BY 1,3,2;

col PLSQL_DEBUG clear
col PLSQL_WARNINGS clear