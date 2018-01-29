alter session set nls_date_format='DD-MM-YYYY HH24';
set feed off
set lines 700
set pages 1000

spoo &4

Prompt ========================================
Prompt == NUMERO DE EXECUTIONS  -  MES &2-&3 ==
Prompt ========================================

SELECT to_char(btime,'HH24') Hora,
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'01-&2-&3',executes))) "01-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'02-&2-&3',executes))) "02-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'03-&2-&3',executes))) "03-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'04-&2-&3',executes))) "04-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'05-&2-&3',executes))) "05-&2-&3",             
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'06-&2-&3',executes))) "06-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'07-&2-&3',executes))) "07-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'08-&2-&3',executes))) "08-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'09-&2-&3',executes))) "09-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'10-&2-&3',executes))) "10-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'11-&2-&3',executes))) "11-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'12-&2-&3',executes))) "12-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'13-&2-&3',executes))) "13-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'14-&2-&3',executes))) "14-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'15-&2-&3',executes))) "15-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'16-&2-&3',executes))) "16-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'17-&2-&3',executes))) "17-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'18-&2-&3',executes))) "18-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'19-&2-&3',executes))) "19-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'20-&2-&3',executes))) "20-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'21-&2-&3',executes))) "21-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'22-&2-&3',executes))) "22-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'23-&2-&3',executes))) "23-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'24-&2-&3',executes))) "24-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'25-&2-&3',executes))) "25-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'26-&2-&3',executes))) "26-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'27-&2-&3',executes))) "27-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'28-&2-&3',executes))) "28-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'29-&2-&3',executes))) "29-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'30-&2-&3',executes))) "30-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'31-&2-&3',executes))) "31-&2-&3"
           from 													
	   		 	 system.tb_load_profile_&1
where
     fl_tipo='s'
GROUP BY 
to_char(btime,'HH24')
/

spoo off
set feed on
