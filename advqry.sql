DECLARE
l_sql_tune_task_id  VARCHAR2(100);
BEGIN
l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
sql_id      => '&1',
scope       => DBMS_SQLTUNE.scope_comprehensive,
time_limit  => 60,
task_name   => '&1_tuning_task',
description => 'MOAM-Tuning task for statement &1.');
DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/
begin 
DBMS_SQLTUNE.execute_tuning_task(task_name => '&1_tuning_task'); 
end;
/

SET LONG 10000;
SET PAGESIZE 1000
SELECT DBMS_SQLTUNE.report_tuning_task('&1_tuning_task') AS recommendations FROM dual;




