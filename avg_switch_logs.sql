alter session set nls_date_format='DD-MM-YYYY HH24:MI:SS';

select
	trunc(first_time,'DD') Data,
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'00',1,0)) "0h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'01',1,0)) "1h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'02',1,0)) "2h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'03',1,0)) "3h",	
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'04',1,0)) "4h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'05',1,0)) "5h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'06',1,0)) "6h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'07',1,0)) "7h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'08',1,0)) "8h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'09',1,0)) "9h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'10',1,0)) "10h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'11',1,0)) "11h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'12',1,0)) "12h"
from gv$log_history
where trunc(first_time) > trunc(sysdate-10)
group by trunc(first_time,'DD') order by 1 desc
/

select
	trunc(first_time,'DD') Data,
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'13',1,0)) "13h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'14',1,0)) "14h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'15',1,0)) "15h",	
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'16',1,0)) "16h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'17',1,0)) "17h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'18',1,0)) "18h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'19',1,0)) "19h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'20',1,0)) "20h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'21',1,0)) "21h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'22',1,0)) "22h",
	sum(decode(substr(trunc(first_time,'HH24'),12,2),'23',1,0)) "23h"
from gv$log_history
where trunc(first_time) > trunc(sysdate-10)
group by trunc(first_time,'DD')  order by 1 desc
/


@__conf