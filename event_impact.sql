Select a.*,round(a.impact*100/b.total,2) PCT from ( 
select
  l.name,
  round(l.sleeps * l.sleeps / (l.misses - l.spin_gets))  impact,
  to_char(100 * l.sleeps / l.gets, '99990.00') || '%'  sleep_rate,
  l.waits_holding_latch  holding,
  l.level#
from
  sys.v_$latch  l
where
  l.sleeps > 0
order by
  2 desc
) a,
(
select
  sum(round(l.sleeps * l.sleeps / (l.misses - l.spin_gets)))  total
  from
  sys.v_$latch  l
where
  l.sleeps > 0) b;
  