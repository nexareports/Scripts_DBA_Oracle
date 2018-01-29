SET LONG 1000000
SET LONGCHUNKSIZE 1000000
set lines 240
undef sql_id

SELECT DBMS_SQLTUNE.report_sql_monitor(
  sql_id       => '&sql_id',
  type         => 'TEXT',
 report_level => 'ALL') AS report
FROM dual;


