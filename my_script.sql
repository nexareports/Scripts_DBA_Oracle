set lines 200
define gname=idle
column global_name new_value gname

alter session set NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI';

set termout off
/*
select lower(user) || '@' || substr( global_name,1,
decode( dot, 0, length(global_name), dot-1) ) global_name
from (select global_name, instr(global_name,'.') dot from global_name );
*/

select lower(user) || '@' || (select sys_context('USERENV','DB_NAME') from dual) global_name
from dual;

set sqlprompt '&gname> '

set termout on
set timing on
set time on
--set echo on
