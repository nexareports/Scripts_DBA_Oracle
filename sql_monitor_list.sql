SET LONG 1000000
SET LONGCHUNKSIZE 1000000
set lines 240
undef minutes
SELECT DBMS_SQLTUNE.report_sql_monitor_list(
  type         => 'TEXT',
  report_level => 'BASIC',
  active_since_sec=>&minutes.*60) AS report
FROM dual;
