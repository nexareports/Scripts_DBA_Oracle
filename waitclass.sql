col pct_time_waited_bar_graph for a20
prompt ##########################################################################
prompt HOJE
prompt ##########################################################################
select wait_class, wait_class_id,
       sum_waited,
       round((sum_waited / sum(sum_waited) over ())*100,2) pct_of_time_waited,
       lpad('|',round((sum_waited / sum(sum_waited) over ())*100,0),'|') pct_time_waited_bar_graph
from
(
select ash.wait_class, ash.wait_class_id,
        sum(ash.time_waited) sum_waited,
        avg(ash.time_waited) avg_waited,
        count(1) total_waits
from dba_hist_active_sess_history ash, dba_hist_snapshot snap
where ash.snap_id = snap.snap_id
and snap.begin_interval_time > trunc(sysdate)
group by ash.wait_class, ash.wait_class_id
)
order by wait_class
/


prompt ##########################################################################
prompt Memoria
prompt ##########################################################################
SELECT WAIT_CLASS,
TOTAL_WAITS,
round(100 * (TOTAL_WAITS / SUM_WAITS),2) PCT_TOTWAITS,
ROUND((TIME_WAITED / 100),2) TOT_TIME_WAITED,
round(100 * (TIME_WAITED / SUM_TIME),2) PCT_TIME
FROM
(select WAIT_CLASS,
TOTAL_WAITS,
TIME_WAITED
FROM V$SYSTEM_WAIT_CLASS
WHERE WAIT_CLASS != 'Idle'),
(select sum(TOTAL_WAITS) SUM_WAITS,
sum(TIME_WAITED) SUM_TIME
from V$SYSTEM_WAIT_CLASS
where WAIT_CLASS != 'Idle')
ORDER BY PCT_TIME DESC; 

col pct_time_waited_bar_graph clear