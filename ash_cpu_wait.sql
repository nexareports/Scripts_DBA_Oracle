select
   trunc(sample_time,'MI') Data,
   sum(decode(session_state, 'ON CPU', 1, 0))  as on_cpu,
   sum(decode(session_state, 'WAITING', 1, 0)) as waiting,
   count(*) as active_sessions
from
   v$active_session_history
where
   -- last 15 seconds
   sample_time > trunc(sysdate)
group by
      trunc(sample_time,'MI')
order by
   1
;

