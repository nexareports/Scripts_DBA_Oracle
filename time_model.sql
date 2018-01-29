
with total as (select sum(value) tot from v$sys_time_model)
Select stat_name,value/1000000 "Time (s)", round(value*100/tot,2) "%"
from v$sys_time_model, total
order by 3 desc;

