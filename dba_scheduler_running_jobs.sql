select s.username, rj.job_name, rj.running_instance, s.sid, s.serial#, p.spid, s.lockwait, s.logon_time
from dba_scheduler_running_jobs rj,
     gv$session s,
     gv$process p
where rj.running_instance = s.inst_id
and   rj.session_id = s.sid
and   s.inst_id = p.inst_id
and   s.paddr = p.addr
order by s.username, rj.job_name;