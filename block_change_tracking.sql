select * from V$BLOCK_CHANGE_TRACKING;

select name
from v$datafile;

ALTER DATABASE ENABLE BLOCK CHANGE TRACKING USING FILE '+DADOS/bdopdas/changetracking/backups_incr.bct';

ALTER DATABASE DISABLE BLOCK CHANGE TRACKING;
