col event format a25
select
substr(e.event, 1, 40)  event,
e.time_waited/100 "Time waited seconds",
round(e.time_waited / decode(
e.event,
'latch free', e.total_waits,
decode(e.total_waits-e.total_timeouts,0, 1,e.total_waits-e.total_timeouts)),2) "Average wait cs"
from
sys.v_$system_event  e,
sys.v_$instance  i
where
e.event = 'buffer busy waits' or
e.event = 'enqueue' or
e.event = 'free buffer waits' or
e.event = 'global cache freelist wait' or
e.event = 'latch free' or
e.event = 'log buffer space' or
e.event = 'parallel query qref latch' or
e.event = 'pipe put' or
e.event = 'write complete waits' or
e.event like 'library cache%' or
e.event like 'log file switch%' or
e.event = 'log file sync' or
( e.event = 'row cache lock' and
i.parallel = 'NO'
)
order by "Time waited seconds" desc;

col event clear