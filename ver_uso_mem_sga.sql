set lines 250
set pages 1000
set feed off
select pool,
       name,
       sgasize/1024/1024 "Allocated (M)",
       bytes/1024 "Free (K)",
       round(bytes/sgasize*100, 2) "% Free"
from   (select sum(bytes) sgasize from sys.v_$sgastat) s, sys.v_$sgastat f
where  f.name = 'free memory'
/

set feed on

