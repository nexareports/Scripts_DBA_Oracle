col sample_id format 999999999
col sample_time format a35
col prev_sample_time format a30
col sample_id_diff format 9999 head 'SMPLL|ID|DIFF'
col aas format 99999.9

def n_interval_minutes=5

with ashdata as (
  select distinct
      -- 15 minute interval
      ash.sample_id
      -- number of sessions in sample
      , count(sample_id) over (partition by sample_id order by sample_id)
session_count
      , trunc(ash.sample_time,'DD') sample_time
      , ( extract (hour from ash.sample_time - trunc(ash.sample_time,'DD')
) * 60 * 60)
            + (
            ( extract (minute from ash.sample_time -
trunc(ash.sample_time,'hh24') ) * 60 )
            -  mod(extract (minute from ash.sample_time -
trunc(ash.sample_time,'hh24') ) * 60, (&&n_interval_minutes*60))
        ) seconds
  from V$ACTIVE_SESSION_HISTORY ash
  -- may take a long time on active system
  --from DBA_HIST_ACTIVE_SESS_HISTORY ash
),
-- correct the date - add the seconds
ashdc as (
  select
      a.sample_id
      , a.session_count
      , a.sample_time + ( decode(a.seconds,0,1,a.seconds) / (24*60*60))
sample_time
  from ashdata a
),
interval_aas as (
  select distinct
      a.sample_time
      , sum(a.session_count) over (partition by sample_time order by
sample_time) sessions
      , count(a.sample_id)  over (partition by sample_time order by
sample_time) sample_count
  from ashdc a
)
select
  sample_time
  , sessions / sample_count aas
from interval_aas
order by sample_time
/


col sample_id clear
col sample_time format clear
col prev_sample_time format clear
col sample_id_diff clear
col aas clear
