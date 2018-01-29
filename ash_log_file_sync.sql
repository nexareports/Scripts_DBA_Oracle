PROMPT
PROMPT ASH THRESHOLD...
PROMPT
column threshold_in_ms new_value threshold format 999999999.999
select min(threshold_in_ms) threshold_in_ms
from (select inst_id, to_char(sample_time,'Mondd_hh24mi') minute, 
avg(time_waited)/1000 threshold_in_ms
from gv$active_session_history
where event = 'log file sync'
group by inst_id,to_char(sample_time,'Mondd_hh24mi')
order by 3 desc)
where rownum <= 5;

col p1 for a20
col p2 for a20
col p3 for a5
PROMPT
PROMPT ASH > THRESHOLD...
PROMPT
Select * from (
select sample_time, session_id, program, time_waited/1000 TIME_WAITED,
p1text||': '||p1 p1,p2text||': '||p2 p2,p3text||': '||p3 p3
from gv$active_session_history
where event = 'log file sync'
and (time_waited)/1000 > &&threshold
order by 1 desc,2,3,4,5) where rownum<31;

col p1 clear
col p2 clear
col p3 clear