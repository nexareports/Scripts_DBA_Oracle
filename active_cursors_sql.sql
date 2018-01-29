
column sql_text format a75 word_wrapped

select
  s.sid,
  c.kglnaobj  sql_text
from
  sys.x_$kglpn  p,
  sys.x_$kglcursor  c,
  sys.v_$session  s
where
  p.inst_id = userenv('Instance') and
  c.inst_id = userenv('Instance') and
  p.kglpnhdl = c.kglhdadr and
  c.kglhdadr != c.kglhdpar and
  p.kglpnses = s.saddr
order by
  s.sid
/

col sql_text clear

