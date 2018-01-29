DECLARE
  l_task_name  VARCHAR2(30) := '15877_15878_AWR_SNAPSHOT_UNDO';
  l_object_id  NUMBER;
BEGIN
  -- Create an ADDM task.
  DBMS_ADVISOR.create_task (
    advisor_name      => 'Undo Advisor',
    task_name         => l_task_name,
    task_desc         => 'Undo Advisor Task');

  DBMS_ADVISOR.create_object (
    task_name   => l_task_name,
    object_type => 'UNDO_TBS',
    attr1       => NULL, 
    attr2       => NULL, 
    attr3       => NULL, 
    attr4       => 'null',
    attr5       => NULL,
    object_id   => l_object_id);

  -- Set the target object.
  DBMS_ADVISOR.set_task_parameter (
    task_name => l_task_name,
    parameter => 'TARGET_OBJECTS',
    value     => l_object_id);

  -- Set the start and end snapshots.
  DBMS_ADVISOR.set_task_parameter (
    task_name => l_task_name,
    parameter => 'START_SNAPSHOT',
    value     => 15877);

  DBMS_ADVISOR.set_task_parameter (
    task_name => l_task_name,
    parameter => 'END_SNAPSHOT',
    value     => 15878);

  -- Execute the task.
  DBMS_ADVISOR.execute_task(task_name => l_task_name);
END;
/