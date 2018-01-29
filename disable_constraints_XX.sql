/* Before disabling primary key constraints, disable
referential constraints. Otherwise oracle gives dependency error. */

set linesize 100
set pagesize 0
set feedback off
spool disable_constraints.out

prompt ---- Check Constraints

select ' alter table '||owner||'.'||table_name||' disable constraint '||constraint_name||';'
from dba_constraints
where owner in ('RESTORE_EIAARP')
and constraint_type='C';

prompt ---- Unique Constraints

select ' alter table '||owner||'.'||table_name||' disable constraint '||constraint_name||';'
from dba_constraints
where owner in ('RESTORE_EIAARP')
and constraint_type='U';

prompt ---- Referential Constraints

select ' alter table '||owner||'.'||table_name||' disable constraint '||constraint_name||';'
from dba_constraints
where owner in ('RESTORE_EIAARP')
and constraint_type='R';

prompt ---- Primary key Constraints

select ' alter table '||owner||'.'||table_name||' disable constraint '||constraint_name||';'
from dba_constraints
where owner in ('RESTORE_EIAARP')
and constraint_type='P';

spool off
