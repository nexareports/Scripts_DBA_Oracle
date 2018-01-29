/*
ACCEPT BD PROMPT "BD ==> " 
ACCEPT CONNECT PROMPT "CONNECT STRING ==> " 
CREATE DATABASE LINK "&BD"
 CONNECT TO DAA
 IDENTIFIED BY "PTSI#1002#PTSI"
 USING '&CONNECT';
 -- USING '(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP) (HOST = vbqpsv01) (PORT = 1539))) (CONNECT_DATA = (SID = SGNTST)))';
*/

ACCEPT bd1 PROMPT "bd ==> "
ACCEPT host1 PROMPT "host ==> "
ACCEPT ambiente1 PROMPT "ambiente (PRD/TST/DEV)  ==> "
ACCEPT gestao1 PROMPT "gestao (PTSI/DTI) ==> "
ACCEPT dba1 PROMPT "DBA (PTS) ==> " 
ACCEPT monitor1 PROMPT "monitor  (Y/N) ==> "
EXEC MONITORIAS.INSERE_BD('&bd1', '&host1', '&ambiente1', '&gestao1',  '&dba1', '&monitor1');