--Classes de espera
select trunc(sample_time,'HH24') Data,
sum(decode(wait_class,'User I/O',time_waited,0))        "User I/O",
sum(decode(wait_class,'Network',time_waited,0))         "Network",
sum(decode(wait_class,'Application',time_waited,0))     "Application",
sum(decode(wait_class,'Concurrency',time_waited,0))     "Concurrency",
sum(decode(wait_class,'Configuration',time_waited,0))   "Configuration",
sum(decode(wait_class,'Commit',time_waited,0))       	"Commit",
sum(decode(wait_class,'System I/O',time_waited,0))      "System I/O"
from dba_hist_active_sess_history
where sample_time>sysdate-(1)
group by trunc(sample_time,'HH24') order by 1;

