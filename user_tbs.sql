select b.tablespace_name, b.initial_extent/1024 "Initial Kb", b.next_extent/1024 "Next Kb", nvl(round(sum(a.bytes)/1024/1024),0) "Free MB"
from user_free_space a , user_tablespaces b
where a.tablespace_name(+)=b.tablespace_name
and b.tablespace_name like '%SAPA%'
group by b.tablespace_name, b.initial_extent, b.next_extent
/
