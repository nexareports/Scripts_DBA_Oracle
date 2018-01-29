column oper_type format a14
column component format a24
column parameter format a21         
 
select
    to_char(start_time,'yyyy-mm-dd hh24:mi:ss') timed_at,
    oper_type,
    component,
    parameter,
    oper_mode,
    initial_size,
    final_size
from
    v$sga_resize_ops
--where start_time >= trunc(sysdate)
order by
    start_time, component
;     

column oper_type clear
column component clear
column parameter clear
