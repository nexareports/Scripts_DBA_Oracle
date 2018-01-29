select ''''||sid||','||serial#||'''' SS,osuser, username, program, to_char(logon_time,'YYYY/MM/DD, HH24:MI'), last_call_et, machine
from v$session
order by 6 desc;

select status, count(*)
from v$session
group by status;