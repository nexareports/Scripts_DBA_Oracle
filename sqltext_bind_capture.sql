select sql_id, child_number, name, VALUE_STRING
from V$SQL_BIND_CAPTURE
where sql_id='ax7mqqbdtzcm6';


select * from dba_hist_sqlbind
where sql_id='5b5b5vg4yn7dn'
and snap_id=13152;