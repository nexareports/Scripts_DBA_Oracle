--set feed off
prompt
Prompt No-Wait
select * from (
select b.name,
round((a.IMMEDIATE_GETS-a.IMMEDIATE_MISSES)/decode(a.IMMEDIATE_GETS,0,1),2) Ratio_NW
from v$latch a, v$latchname b
where a.LATCH#=b.LATCH# and 
IMMEDIATE_GETS!=0
order by 2 desc) where Ratio_NW!=1 order by 2;

prompt
Prompt Willing-To-Wait
select * from (
select b.name,
round((a.GETS-a.MISSES)/decode(a.GETS,0,1),2) Ratio_WTW
from v$latch a, v$latchname b
where a.LATCH#=b.LATCH# and 
GETS!=0
order by 2 asc) where Ratio_WTW!=1 order by 2;


prompt
Prompt Shows latch sleep statistics:
select * from (
select
  l.name,
  round(l.sleeps * l.sleeps / decode((l.misses - l.spin_gets),0,1))  impact,
  to_char(100 * l.sleeps / l.gets, '99990.00') || '%'  sleep_rate,
  l.waits_holding_latch  holding,
  l.level#
from
  sys.v_$latch  l
where
  l.sleeps > 0
order by
  2 desc) where rownum<11
/

--set feed on