--Média de Utilizadores
set lines 700
set pages 1000
alter session set nls_date_format='DD-MM-YYYY HH24';

spoo &3


SELECT to_char(b.snap_time,'HH24') Hora,
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'01-&1-&2',a.value))) "01-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'02-&1-&2',a.value))) "02-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'03-&1-&2',a.value))) "03-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'04-&1-&2',a.value))) "04-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'05-&1-&2',a.value))) "05-&1-&2",             
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'06-&1-&2',a.value))) "06-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'07-&1-&2',a.value))) "07-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'08-&1-&2',a.value))) "08-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'09-&1-&2',a.value))) "09-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'10-&1-&2',a.value))) "10-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'11-&1-&2',a.value))) "11-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'12-&1-&2',a.value))) "12-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'13-&1-&2',a.value))) "13-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'14-&1-&2',a.value))) "14-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'15-&1-&2',a.value))) "15-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'16-&1-&2',a.value))) "16-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'17-&1-&2',a.value))) "17-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'18-&1-&2',a.value))) "18-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'19-&1-&2',a.value))) "19-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'20-&1-&2',a.value))) "20-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'21-&1-&2',a.value))) "21-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'22-&1-&2',a.value))) "22-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'23-&1-&2',a.value))) "23-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'24-&1-&2',a.value))) "24-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'25-&1-&2',a.value))) "25-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'26-&1-&2',a.value))) "26-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'27-&1-&2',a.value))) "27-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'28-&1-&2',a.value))) "28-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'29-&1-&2',a.value))) "29-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'30-&1-&2',a.value))) "30-&1-&2",
                round(avg(decode(substr(to_char(b.snap_time,'DD-MM-YYYY HH24'),1,10),'30-&1-&2',a.value))) "31-&1-&2"
           from 													
	   		 	 perfstat.STATS$SYSSTAT a,
	   			 perfstat.STATS$SNAPSHOT b
where
		 	 a.snap_id=b.snap_id
			 and a.name in ('logons current')
			 and b.snap_time between '01-&1-&2 00' and '31-&1-&2 23'
GROUP BY 
to_char(b.snap_time,'HH24')
/

spoo off

