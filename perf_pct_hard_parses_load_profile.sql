alter session set nls_date_format='DD-MM-YYYY HH24';
set lines 700
set pages 1000
set feed off
spoo &4

Prompt ==========================================
Prompt == PERCENTUAL HARD PARSES  -  MES &2-&3 ==
Prompt ==========================================

SELECT to_char(btime,'HH24') Hora,
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'01-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "01-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'02-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "02-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'03-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "03-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'04-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "04-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'05-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "05-&2-&3",             
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'06-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "06-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'07-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "07-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'08-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "08-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'09-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "09-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'10-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "10-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'11-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "11-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'12-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "12-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'13-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "13-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'14-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "14-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'15-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "15-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'16-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "16-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'17-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "17-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'18-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "18-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'19-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "19-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'20-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "20-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'21-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "21-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'22-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "22-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'23-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "23-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'24-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "24-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'25-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "25-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'26-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "26-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'27-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "27-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'28-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "28-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'29-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "29-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'30-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "30-&2-&3",
                round(avg(decode(substr(to_char(btime,'DD-MM-YYYY HH24'),1,10),'31-&2-&3',HARD_PARSES*100/(PARSES+HARD_PARSES)))) "31-&2-&3"
           from 													
	   		 	 tb_load_profile_&1
where
     fl_tipo='s'
GROUP BY 
to_char(btime,'HH24')
/

spoo off
set feed on
