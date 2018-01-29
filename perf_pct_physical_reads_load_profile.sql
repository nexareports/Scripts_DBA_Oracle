alter session set nls_date_format='DD-MM-YYYY HH24';
set lines 700
set pages 1000
set feed off
spoo &4

Prompt =============================================
Prompt == PERCENTUAL PHYSICAL READS  -  MES &2-&3 ==
Prompt =============================================

SELECT to_char(btime,'HH24') Hora,
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'01-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "01-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'02-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "02-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'03-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "03-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'04-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "04-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'05-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "05-&2-&3",             
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'06-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "06-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'07-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "07-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'08-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "08-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'09-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "09-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'10-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "10-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'11-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "11-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'12-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "12-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'13-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "13-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'14-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "14-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'15-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "15-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'16-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "16-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'17-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "17-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'18-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "18-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'19-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "19-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'20-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "20-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'21-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "21-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'22-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "22-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'23-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "23-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'24-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "24-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'25-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "25-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'26-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "26-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'27-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "27-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'28-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "28-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'29-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "29-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'30-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "30-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'31-&2-&3',PHYSICAL_READS*100/(PHYSICAL_READS+LOGICAL_READS)))) "31-&2-&3"
           from 													
	   		 	 tb_load_profile_&1
where
     fl_tipo='s'
GROUP BY 
to_char(btime,'HH24')
/

spoo off
set feed on
