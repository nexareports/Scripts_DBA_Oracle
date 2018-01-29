spo C:\TEMP\CVT\tst.log

set echo on

select INSTANCE_NAME, VERSION, STARTUP_Time, STATUS, DATABASE_STATUS
from v$instance;
select OBJECT_NAME, OBJECT_TYPE, CREATED, STATUS
from user_objects
where status='INVALID';
