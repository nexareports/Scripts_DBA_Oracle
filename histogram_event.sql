col event_name format a30
 
SELECT
  to_char(begin_interval_time, 'yyyy-mm-dd hh24:mi') end_period,
  MAX(decode(wait_time_milli, 1, wait_count)) "1ms",
  MAX(decode(wait_time_milli, 2, wait_count)) "2ms",
  MAX(decode(wait_time_milli, 4, wait_count)) "4ms",
  MAX(decode(wait_time_milli, 8, wait_count)) "8ms",
  MAX(decode(wait_time_milli, 16, wait_count)) "16ms",
  MAX(decode(wait_time_milli, 32, wait_count)) "32ms",
  MAX(decode(wait_time_milli, 64, wait_count)) "64ms",
  MAX(decode(wait_time_milli, 128, wait_count)) "128ms",
  MAX(decode(wait_time_milli, 256, wait_count)) "256ms",
  MAX(decode(wait_time_milli, 512, wait_count)) "512ms",
  MAX(decode(wait_time_milli, 1024, wait_count)) "1024ms",
  MAX(decode(wait_time_milli, 2048, wait_count)) "2048ms"
FROM
(
  SELECT
    s.begin_interval_time,
    h.event_name,
    wait_time_milli,
    wait_count - lag(wait_count) OVER (partition BY h.dbid, h.instance_number, h.event_name, h.wait_time_milli ORDER BY s.begin_interval_time) wait_count
  FROM
    dba_hist_event_histogram h,
    v$database d,
    v$instance i,
    dba_hist_snapshot s
  WHERE
    h.dbid = d.dbid AND
    h.snap_id = s.snap_id AND
    h.instance_number = h.instance_number AND
    s.begin_interval_time >trunc(sysdate) AND
    h.event_name IN ('&1')
)
GROUP BY to_char(begin_interval_time, 'yyyy-mm-dd hh24:mi')
ORDER BY 2
;
col event_name clear