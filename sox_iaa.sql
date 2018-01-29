break on today
column today noprint new_value xdate

select substr(to_char(sysdate,'fmMonth DD, YYYY HH:MI:SS P.M.'),1,35) today
from dual;

column dbxx_name noprint new_value sxdbname
select name dbxx_name from v$database;

set heading on
set feedback off
set markup html on spool on PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>SOX Report</TITLE> -
<STYLE type='text/css'> -
<!-- BODY {font:12pt Arial,Helvetica,sans-serif; color:black; background:White;} --> -
<!-- table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;} --> -
<!-- th {font:bold 10pt Arial,Helvetica,sans-serif; color:white; background:#C0C0C0; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;} --> -
</STYLE>"

spool sox_iaa.html

prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=1 TYPE=1>
prompt <LI> <B> Resumo Executivo </B>
prompt <OL TYPE=1>
prompt <LI > Este relatório tem por objectivo apresentar uma análise da BD Oracle da aplicação IOANNIS, na componente de Administração de Bases de Dados vertente aplicacional, para o mês de DATA_MES_ANO.
prompt </OL>
prompt </OL>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=2 TYPE=1>
prompt <LI> <B> Informação da Base de Dados </B>
prompt <OL TYPE=1>
prompt <LI > Levantamento da data de criação
prompt <DL>
prompt <DD> Este item permite identificar o nome da base de dados que irá ser usado em todo o documento e a respectiva data de criação e configuração de Logging.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
ttitle left "DATABASE:  "sxdbname"    (AS OF:  "xdate")"
select name, created, log_mode from v$database;
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=2 TYPE=1>
prompt <LI>
prompt <OL START=2 TYPE=1>
prompt <LI > Versão de Oracle
prompt <DL>
prompt <DD> Este item permite constatar a versão de Oracle que esta instância possui, permitindo assim fazer um "Crosscheck" com as versões ainda suportadas da Oracle (a nível de  ECS - Error Correction Support, ES - Extend Support).
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
ttitle left "DATABASE Version :  "sxdbname"    (AS OF:  "xdate")"
select banner version
from v$version;
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading on
set termout on
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=2 TYPE=1>
prompt <LI>
prompt <OL START=3 TYPE=1>
prompt <LI > Levantamento das Licenças Oracle
prompt <DL>
prompt <DD> Este item permite constatar as licenças Oracle que estão definidas e quantidade máxima que foi utilizado.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
col member format a40
set line 132
set pagesize 10000
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Database License Info ( As of:  "  xdate " ) ***"
col SESSIONS_WARNING form 9,999 heading "SESS_WARN"
col SESSIONS_CURRENT form 9,999 heading "SESS_CUR"
col SESSIONS_HIGHWATER form 9,999 heading "SESS_HIGHWATER"
col USERS_MAX form 9,999 heading "USERS_MAX"
select * 
from v$license;
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear breaks
clear computes
set heading on
set termout on
clear columns
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=3 TYPE=1>
prompt <LI> <B> Configurações da Instancia Oracle </B>
prompt <OL START=1 TYPE=1>
prompt <LI > Database Buffer Cache Configuration
prompt <DL>
prompt <DD> Este item permite constatar a configuração da Database Buffer Cache (memoria do Oracle responsável por fazer caching dos objectos em memoria), Métricas do seu desempenho e informações sobre a sua utilização.
prompt <DD> Caso a versão de Oracle permite extrair, a percentagem de Database Buffer Cache Hit Ratio deve encontrar-se entre os 85% e os 100%.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
clear breaks
clear computes
set pages 10000
set line 132

column "DB Parameter" format a35
column "Valor" format a30
set heading on
set termout on

TTitle left "*****  Database:  "sxdbname", DB Block Buffers Parameter ( As of:  "xdate" )   *****"
SELECT  name "DB Parameter",value "Valor"
from v$parameter
where (name = 'db_block_buffers'
or name = 'db_cache_size')
and value <> '0';
prompt 
prompt 
set heading off
set termout off
set feedback off

column "Physical Reads" format 9,999,999,999,999
column "Consistent Gets" format 9,999,999,999,999
column "DB Block Gets" format 9,999,999,999,999
column "Percent (Above 70% ?)" format 999.99
set heading on
set termout on

TTitle left "*****  Database:  "sxdbname", DB Block Buffers ( As of:  "xdate" )   *****" 
SELECT  s1.value "Physical Reads",
        s2.value "Consistent Gets",
        s3.value "DB Block Gets",
        (100*(1-((s1.value-(s4.value+s5.value))/(s2.value+s3.value)))) "Percent (Above 85% ?)"
from v$sysstat s1,
     v$sysstat s2,
     v$sysstat s3,
     v$sysstat s4,
     v$sysstat s5
where s1.name = 'physical reads'
and s2.name = 'consistent gets'
and s3.name = 'db block gets'
and s4.name = 'physical reads direct'
and s5.name = 'physical reads direct (lob)';
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
prompt 
prompt 
clear breaks
clear computes
clear columns
set heading on
set termout on
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=3 TYPE=1>
prompt <LI>
prompt <OL START=2 TYPE=1>
prompt <LI > Shared Pool Configuration
prompt <DL>
prompt <DD> Este item permite constatar a configuração da Shared Pool (memoria do Oracle responsável por fazer caching dos SQL's em memoria e Caching do Dicionário de Dados Oracle) , Métricas do seu desempenho e informações sobre a sua utilização.
prompt <DD> Caso a versão de Oracle permite extrair, a percentagem de Shared Pool Metrics deve encontrar-se abaixo dos 1%  no caso das executions, no caso das Dictionary Gets abaixo do 12%.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set trimspool on
set heading on
set termout on
column "DB Parameter" format a35
column "Valor" format a30

TTitle left "*****  Database:  "sxdbname", Shared Pool Parameter ( As of:  "xdate" )   *****" 
SELECT  name "DB Parameter",value "Valor"
from v$parameter
where (name = 'shared_pool_size'
or name = 'shared_pool_reserved_size')
and value <> '0';
ttitle off
set heading off
set termout off

column "Executions" format 999,999,999,990
column "Cache Misses Executing" format 999,999,990
column "Data Dictionary Gets" format 999,999,999,999
column "Get Misses" format 999,999,999
prompt 
prompt 
set heading on
set termout on

ttitle left skip 1 - left "**********     Shared Pool Size (Execution Misses)     **********" 
select sum(pins) "Executions",
       sum(reloads) "Cache Misses Executing",
       (sum(reloads)/sum(pins)*100) "% Ratio (STAY UNDER 1%)"
from v$librarycache
where NAMESPACE in ('SQL AREA','TABLE/PROCEDURE');
ttitle off
prompt 
prompt 

ttitle left "**********     Shared Pool Size (Dictionary Gets)     **********"  
select sum(gets) "Data Dictionary Gets",
       sum(getmisses) "Get Misses",
       100*(sum(getmisses)/sum(gets)) "% Ratio (STAY UNDER 12%)"
from v$rowcache;
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear breaks
clear computes
clear columns
set heading on
set termout on

prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=3 TYPE=1>
prompt <LI>
prompt <OL START=3 TYPE=1>
prompt <LI > Redo Log Buffer Configuration
prompt <DL>
prompt <DD> Este item permite constatar a configuração da Log Buffer (memória do Oracle responsável por fazer caching das transacções e logging das mesmas para efeitos de recuperação da informação em caso de falha), Métricas do seu desempenho e informações sobre a sua utilização.
prompt <DD> Caso a versão de Oracle permite extrair, a estatística redo log space requests deve ser 0 ou perto de 0.
prompt <DD> Em termos de Log Buffer Metric deve ser sempre abaixo de 1%.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading on
set termout on

column "DB Parameter" format a35
column "Valor" format a30

TTitle left "*****  Database:  "sxdbname", Log Buffer Parameter ( As of:  "xdate" )   *****" 
SELECT  name "DB Parameter",value "Valor"
from v$parameter
where name = 'log_buffer'
and value <> '0';
prompt 
prompt 
ttitle left "**********     Log Buffers     **********" 
select  substr(name,1,25) Name,
        substr(value,1,15) "VALUE (Near 0?)"
from v$sysstat
where name = 'redo log space requests';
prompt 
prompt 
select  (st2.value/st1.value)*100 "VALUE (> 1%)"
from v$sysstat st1,
	   v$sysstat st2
where st1.name = 'redo entries'
and st2.name = 'redo buffer allocation retries';
prompt 
prompt 
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
clear breaks
clear computes
clear columns
set heading on
set termout on

prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=3 TYPE=1>
prompt <LI>
prompt <OL START=4 TYPE=1>
prompt <LI > Latch Metrics
prompt <DL>
prompt <DD> Este item permite identificar a forma com os latches são usados (os latches são tipo semáforos que serializam acessos às estruturas de memoria Oracle e evitam corrupções de memoria), Métricas do seu desempenho e informações sobre a sua utilização.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set line 200
set trimspool on
column name        format a50 heading "LATCH TYPE"
column spin_gets              heading "SPIN GETS"
column sleep_gets             heading "SLEEP GETS"
column hit_rate    format a13 heading "SPIN HIT RATE"

set heading on
set termout on
ttitle left "**********     Latch Spin Statistics     **********" 
select
  l.name,
  l.spin_gets,
  l.misses - l.spin_gets  sleep_gets,
  to_char(100 * l.spin_gets / l.misses, '99999990.00') || '%'  hit_rate
from v$latch  l
where l.misses > 0
order by l.misses - l.spin_gets desc;
prompt 
prompt 
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear columns
clear breaks
clear computes

prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=3 TYPE=1>
prompt <LI>
prompt <OL START=5 TYPE=1>
prompt <LI > Oracle Background Processes Configuration
prompt <DL>
prompt <DD> Este item permite constatar as configurações dos processos de Background da Base de Dados Oracle (estas configurações permitem definir configurações importantes na BD).
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading on
set termout on
prompt 
prompt 
column "DB Parameter" format a35
column "Valor" format a30

TTitle left "*****  Database:  "sxdbname", DBWR and I/O Configuration ( As of:  "xdate" )   *****"  
SELECT  name "DB Parameter",value "Valor"
from v$parameter
where (name = 'db_writer_processes'
or name = 'dbwr_io_slaves'
or name = 'disk_asynch_io')
and value <> '0';
ttitle off
prompt 
prompt 
TTitle left "*****  Database:  "sxdbname", CKPT - Checkpoint Configuration ( As of:  "xdate" )   *****"  
SELECT  name "DB Parameter",value "Valor"
from v$parameter
where (name = 'log_checkpoint_interval'
or name = 'log_checkpoint_timeout'
or name = 'fast_start_io_target'
or name = 'fast_start_mttr_target'
or name = 'log_checkpoints_to_alert')
and value <> '0';
ttitle off
prompt 
prompt 
TTitle left "*****  Database:  "sxdbname", Archivelog Configuration ( As of:  "xdate" )   *****" 
SELECT  name "DB Parameter",value "Valor"
from v$parameter
where ((name = 'log_archive_start'
or name = 'log_archive_max_processes'
or name = 'log_archive_min_succeed_dest'
or name = 'log_archive_format'
or name = 'log_archive_dest')
and value <> '0')
or (name like 'log_archive_dest_%' and value is not null);
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear columns
clear breaks
clear computes

prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=3 TYPE=1>
prompt <LI>
prompt <OL START=6 TYPE=1>
prompt <LI > Oracle Server Processes Configuration
prompt <DL>
prompt <DD> Este item permite constatar as configurações dos processos que se ligam à Base de Dados Oracle (estas configurações permitem definir configurações para o processamento SQL na Base de Dados). 
prompt <DD> Caso a versão de Oracle permite extrair, os Processes Sort Information devem estar entre os 95% e os 100%.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
set heading on
set termout on
prompt 
prompt 
column "DB Parameter" format a35
column "Valor" format a30

TTitle left "*****  Database:  "sxdbname", Process Memory Allocation ( As of:  "xdate" )   *****"  
SELECT  name "DB Parameter",value "Valor"
from v$parameter
where (name = 'db_writer_processes'
or name = 'workarea_size_policy'
or name = 'pga_aggregate_target'
or name = 'bitmap_merge_area_size'
or name = 'create_bitmap_area_size'
or name = 'hash_area_size' 
or name = 'sort_area_retained_size'
or name = 'sort_area_size')
and value <> '0';
ttitle off
prompt 
prompt 

TTitle left "*****  Database:  "sxdbname", Process Sort Information( As of:  "xdate" )   *****"  
select m.value Memory_Sort, d.value Disk_Sort, (1-(d.value/m.value))*100 "PCT SortsMemoria (>95%)"
from v$sysstat m,
     v$sysstat d
where m.name = 'sorts (memory)'
and d.name = 'sorts (disk)';
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear columns
clear breaks
clear computes

rem -------------------------------------------------------------
rem     Reinstates the sxdbname parameter
rem -------------------------------------------------------------
prompt 
prompt 
column dbxx_name noprint new_value sxdbname
select name dbxx_name from v$database;
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=4 TYPE=1>
prompt <LI> <B> Configurações Físicas da Base de Dados </B>
prompt <OL START=1 TYPE=1>
prompt <LI > Tablespace Information
prompt <DL>
prompt <DD> Informação sobre a quantidade e configuração dos tablespaces existentes nesta Base de Dados.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
prompt 
col tablespace_name   for A30 head 'Tablespaces'
col extent_management for A10 head 'Extent|Management'
col allocation_type   for A10 head 'Allocation|Type'
set pagesize 10000
set line 200
set trimspool on
set heading on
set termout on

TTitle left "*******   Database:  "sxdbname", Current Tablespace Info ( As of: "xdate" )   *******" 
select tablespace_name
      ,extent_management
      ,allocation_type
      ,initial_extent
      ,next_extent
      ,min_extlen
      ,contents
from   DBA_TABLESPACES;
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=4 TYPE=1>
prompt <LI>
prompt <OL START=2 TYPE=1>
prompt <LI > Tablespace Usage
prompt <DL>
prompt <DD> Informação sobre o uso dos Tablespace, bem com as percentagem de espaço disponível e ocupado.
prompt <DD> Permite constatar o espaço livre e ocupado para prever eventuais crescimentos.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
clear breaks
clear computes
set line 200
set trimspool on
set heading on
set termout on

col name     format A30         head "Tablespace Name"
col pct_used format 999.9       head "Pct|Used"
col pct_free format 999.9       head "Pct|Free"
col Kbytes   format 99,999,999,999 head "KBytes"
col used     format 99,999,999,999 head "Used"
col free     format 99,999,999,999 head "Free"
col max_free format 99,999,999,999 head "Max Size|Free Chunk"
break   on report
compute sum of kbytes on report
compute sum of free on report
compute sum of used on report

select   nvl(FULL.tablespace_name,nvl(FREE.tablespace_name,'UNKOWN')) Name
        ,kbytes_used                    Kbytes
        ,kbytes_used-nvl(kbytes_free,0) Used
        ,nvl(kbytes_free,0)             Free
        ,((kbytes_used-nvl(kbytes_free,0)) / kbytes_used)*100 Pct_used
				,(1-((kbytes_used-nvl(kbytes_free,0)) / kbytes_used))*100 Pct_free
        ,nvl(max_free,0)                Max_free
from 
     ( select  sum(bytes)/1024    Kbytes_free
              ,max(bytes)/1024    max_free
              ,tablespace_name
       from    sys.DBA_FREE_SPACE
       group by tablespace_name ) FREE,
     ( select  sum(bytes)/1024    Kbytes_used
              ,tablespace_name
       from    sys.DBA_DATA_FILES
       group by tablespace_name ) FULL
where  FREE.tablespace_name (+) = FULL.tablespace_name
order by  name
/
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear breaks
clear computes
clear columns
set heading on
set termout on

prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=4 TYPE=1>
prompt <LI>
prompt <OL START=3 TYPE=1>
prompt <LI > Datafile Configuration and I/O Metrics
prompt <DL>
prompt <DD> Informação sobre os Datafiles da Base de Dados Oracle que são mais acedidos em termos de escritas e Leituras.
prompt <DD> Permite constatar os Datafiles mais activos a nível de I/O, para se tentar equilibrá-los por dispositivo físico.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
column "File Total" format 999,999,990
set line 300
set trimspool on
set pagesize 10000

col "ID"		format 9999
col "File Name" 	format a55
col "Phy Reads"		format 9999999999
col "Phy Writes"	format 9999999999
col "Blk Reads"		format 9999999999
col "Blk Writes"	format 9999999999
col "Read Time"		format 9999999999
col "Write Time"	format 9999999999
col "File Total"	format 9999999999

ttitle  "*****   Database:  "sxdbname", DataFile's Disk Activity (As  of:" xdate " )   *****"
select  df.file# "ID",
 	name "File Name",
 	phyrds "Phy Reads",
 	phywrts "Phy Writes",
 	phyblkrd "Blk Reads",
 	phyblkwrt "Blk Writes",
 	readtim "Read Time",
 	writetim "Write Time",
 	(sum(phyrds+phywrts+phyblkrd+phyblkwrt+readtim)) "File Total"
from v$filestat fs, 
	   v$datafile df
where fs.file# = df.file#
group by df.file#, df.name, phyrds, phywrts, phyblkrd, phyblkwrt, readtim, writetim
order by sum(phyrds+phywrts+phyblkrd+phyblkwrt+readtim) desc, df.name;
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear breaks
clear computes
clear columns
set heading on
set termout on
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=4 TYPE=1>
prompt <LI>
prompt <OL START=4 TYPE=1>
prompt <LI > Redo Log File Configuration
prompt <DL>
prompt <DD> Informação sobre a configuração dos parâmetros de escrita para os Redo Log Files, métricas relativas ao uso dos mesmos Redo Log Files por parte da Base de Dados Oracle.
prompt <DD> Caso a versão de Oracle permita extrair, os log switch ratios a media não deve ultrapassar mais de 10 por hora.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
col member format a40
set line 200
set trimspool on
set pagesize 10000

TTitle left " " skip 2 - left "*** Database:  "sxdbname", Redo Log Group( As of:  "  xdate " ) ***"
select GROUP#,
			 THREAD#,
			 SEQUENCE#,
			 BYTES,
			 MEMBERS,
			 ARCHIVED,
			 STATUS
from v$log;
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Redo Log Members( As of:  "  xdate " ) ***"
select *
from v$logfile;
ttitle off
set heading off
set termout off

COLUMN DAY	 FORMAT A6
COLUMN H00   FORMAT 999     HEADING '00'
COLUMN H01   FORMAT 999     HEADING '01'
COLUMN H02   FORMAT 999     HEADING '02'
COLUMN H03   FORMAT 999     HEADING '03'
COLUMN H04   FORMAT 999     HEADING '04'
COLUMN H05   FORMAT 999     HEADING '05'
COLUMN H06   FORMAT 999     HEADING '06'
COLUMN H07   FORMAT 999     HEADING '07'
COLUMN H08   FORMAT 999     HEADING '08'
COLUMN H09   FORMAT 999     HEADING '09'
COLUMN H10   FORMAT 999     HEADING '10'
COLUMN H11   FORMAT 999     HEADING '11'
COLUMN H12   FORMAT 999     HEADING '12'
COLUMN H13   FORMAT 999     HEADING '13'
COLUMN H14   FORMAT 999     HEADING '14'
COLUMN H15   FORMAT 999     HEADING '15'
COLUMN H16   FORMAT 999     HEADING '16'
COLUMN H17   FORMAT 999     HEADING '17'
COLUMN H18   FORMAT 999     HEADING '18'
COLUMN H19   FORMAT 999     HEADING '19'
COLUMN H20   FORMAT 999     HEADING '20'
COLUMN H21   FORMAT 999     HEADING '21'
COLUMN H22   FORMAT 999     HEADING '22'
COLUMN H23   FORMAT 999     HEADING '23'
COLUMN TOTAL FORMAT 99999 HEADING 'Total'

set heading on
set termout on
prompt 
prompt 
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Redo Log Archived Logs Rate( As of:  "  xdate " ) ***"
SELECT SUBSTR(TO_CHAR(first_time, 'DD/MM/RR HH:MI:SS'),1,5) DAY
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'00',1,0)) H00
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'01',1,0)) H01
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'02',1,0)) H02
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'03',1,0)) H03
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'04',1,0)) H04
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'05',1,0)) H05
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'06',1,0)) H06
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'07',1,0)) H07
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'08',1,0)) H08
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'09',1,0)) H09
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'10',1,0)) H10
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'11',1,0)) H11
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'12',1,0)) H12
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'13',1,0)) H13
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'14',1,0)) H14
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'15',1,0)) H15
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'16',1,0)) H16
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'17',1,0)) H17
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'18',1,0)) H18
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'19',1,0)) H19
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'20',1,0)) H20
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'21',1,0)) H21
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'22',1,0)) H22
, SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'23',1,0)) H23
, COUNT(*)                                                                      TOTAL
FROM  v$log_history  a
WHERE (TO_DATE(SUBSTR(TO_CHAR(first_time,'MM/DD/RR HH:MI:SS'),1,8),'MM/DD/RR') >= sysdate-30)
AND (TO_DATE(substr(TO_CHAR(first_time,'MM/DD/RR HH:MI:SS'),1,8),'MM/DD/RR') <=  sysdate)
GROUP BY SUBSTR(TO_CHAR(first_time, 'DD/MM/RR HH:MI:SS'),1,5);
ttitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear breaks
clear computes
set heading on
set termout on
clear columns
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=4 TYPE=1>
prompt <LI>
prompt <OL START=5 TYPE=1>
prompt <LI > Control Files Configuration
prompt <DL>
prompt <DD> Informação sobre a configuração e localização dos Control Files da Base de Dados Oracle.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
col member format a40
set line 132
set pagesize 10000

TTitle left " " skip 2 - left "*** Database:  "sxdbname", Controlfile Configuration( As of:  "  xdate " ) ***"
select name
from v$controlfile;
TTitle off
prompt 
prompt 
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Controlfile RecordSection( As of:  "  xdate " ) ***"
select TYPE,RECORDS_TOTAL,RECORDS_USED
from v$controlfile_record_section;
TTitle off

set heading off
set termout off
clear breaks
clear computes
set heading on
set termout on
clear columns
prompt 
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=5 TYPE=1>
prompt <LI> <B> Configurações dos Schemas Aplicacionais </B>
prompt <OL START=1 TYPE=1>
prompt <LI > Database Object Summary per Schema
prompt <DL>
prompt <DD> Quadro que demonstra a quantidade e tipos de objectos por Utilizador da Base de Dados Oracle.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
set heading off
set termout off
set pagesize 10000
set linesize 132
COLUMN owner FORMAT a20 HEADING "Owner"
COLUMN sum_table FORMAT 999,999 HEADING "Tables"
COLUMN sum_index FORMAT 999,999 HEADING "Indexes"
COLUMN sum_view FORMAT 999,999 HEADING "Views"
COLUMN sum_sequence FORMAT 999,999 HEADING "Sequences"
COLUMN sum_synonym FORMAT 999,999 HEADING "Synonyms"
COLUMN sum_cluster FORMAT 999,999 HEADING "Clusters"
COLUMN sum_procedure FORMAT 999,999 HEADING "Procedures"
COLUMN sum_package FORMAT 999,999 HEADING "Packages"
COLUMN sum_package_body FORMAT 999,999 HEADING "Pckg Bodies"
COLUMN sum_db_link FORMAT 999,999 HEADING "DB Links"
COMPUTE SUM OF sum_table ON REPORT
COMPUTE SUM OF sum_index ON REPORT
COMPUTE SUM OF sum_view ON REPORT
COMPUTE SUM OF sum_sequence ON REPORT
COMPUTE SUM OF sum_synonym ON REPORT
COMPUTE SUM OF sum_cluster ON REPORT
COMPUTE SUM OF sum_procedure ON REPORT
COMPUTE SUM OF sum_package ON REPORT
COMPUTE SUM OF sum_package_body ON REPORT
COMPUTE SUM OF sum_db_link ON REPORT
set heading on
set termout on

TTitle left " " skip 2 - left "*** Database:  "sxdbname", Database Objects Summary ( As of:  "  xdate " ) ***"
SELECT O.owner,
  			Sum( Decode( O.object_type, 'TABLE', 1, 0 ) ) AS "sum_table",
  			Sum( Decode( O.object_type, 'INDEX', 1, 0 ) ) AS "sum_index",
  			Sum( Decode( O.object_type, 'VIEW', 1, 0 ) ) AS "sum_view",
  			Sum( Decode( O.object_type, 'SEQUENCE', 1, 0 ) ) AS "sum_sequence",
  			Sum( Decode( O.object_type, 'SYNONYM', 1, 0 ) ) AS "sum_synonym",
  			Sum( Decode( O.object_type, 'CLUSTER', 1, 0 ) ) AS "sum_cluster",
  			Sum( Decode( O.object_type, 'PROCEDURE', 1, 0 ) ) AS "sum_procedure",
  			Sum( Decode( O.object_type, 'PACKAGE', 1, 0 ) ) AS "sum_package",
  			Sum( Decode( O.object_type, 'PACKAGE BODY', 1, 0 ) ) AS "sum_package_body",
  			Sum( Decode( O.object_type, 'DATABASE LINK', 1, 0 ) ) AS "sum_db_link"
FROM dba_objects O
GROUP BY O.owner
ORDER BY O.owner;
TTitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=5 TYPE=1>
prompt <LI> 
prompt <OL START=2 TYPE=1>
prompt <LI > Database Object Summary of Invalid Objects
prompt <DL>
prompt <DD> Quadro que demonstra a quantidade e tipos de objectos inválidos por Utilizador da Base de Dados Oracle.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
set heading off
set termout off
clear breaks
clear computes
clear columns
set pagesize 10000
set linesize 132
COLUMN owner FORMAT a20 HEADING "Owner"
COLUMN sum_table FORMAT 999,999 HEADING "Tables"
COLUMN sum_index FORMAT 999,999 HEADING "Indexes"
COLUMN sum_view FORMAT 999,999 HEADING "Views"
COLUMN sum_sequence FORMAT 999,999 HEADING "Sequences"
COLUMN sum_synonym FORMAT 999,999 HEADING "Synonyms"
COLUMN sum_cluster FORMAT 999,999 HEADING "Clusters"
COLUMN sum_procedure FORMAT 999,999 HEADING "Procedures"
COLUMN sum_package FORMAT 999,999 HEADING "Packages"
COLUMN sum_package_body FORMAT 999,999 HEADING "Pckg Bodies"
COLUMN sum_db_link FORMAT 999,999 HEADING "DB Links"
COMPUTE SUM OF sum_table ON REPORT
COMPUTE SUM OF sum_index ON REPORT
COMPUTE SUM OF sum_view ON REPORT
COMPUTE SUM OF sum_sequence ON REPORT
COMPUTE SUM OF sum_synonym ON REPORT
COMPUTE SUM OF sum_cluster ON REPORT
COMPUTE SUM OF sum_procedure ON REPORT
COMPUTE SUM OF sum_package ON REPORT
COMPUTE SUM OF sum_package_body ON REPORT
COMPUTE SUM OF sum_db_link ON REPORT
set heading on
set termout on

TTitle left " " skip 2 - left "*** Database:  "sxdbname", Invalid Objects Summary ( As of:  "  xdate " ) ***"
SELECT O.owner,
  			Sum( Decode( O.object_type, 'TABLE', 1, 0 ) ) AS "sum_table",
  			Sum( Decode( O.object_type, 'INDEX', 1, 0 ) ) AS "sum_index",
  			Sum( Decode( O.object_type, 'VIEW', 1, 0 ) ) AS "sum_view",
  			Sum( Decode( O.object_type, 'SEQUENCE', 1, 0 ) ) AS "sum_sequence",
  			Sum( Decode( O.object_type, 'SYNONYM', 1, 0 ) ) AS "sum_synonym",
  			Sum( Decode( O.object_type, 'CLUSTER', 1, 0 ) ) AS "sum_cluster",
  			Sum( Decode( O.object_type, 'PROCEDURE', 1, 0 ) ) AS "sum_procedure",
  			Sum( Decode( O.object_type, 'PACKAGE', 1, 0 ) ) AS "sum_package",
  			Sum( Decode( O.object_type, 'PACKAGE BODY', 1, 0 ) ) AS "sum_package_body",
  			Sum( Decode( O.object_type, 'DATABASE LINK', 1, 0 ) ) AS "sum_db_link"
FROM dba_objects O
where o.status = 'INVALID'
GROUP BY O.owner
ORDER BY O.owner;
TTitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear breaks
clear computes
clear columns

set heading on
set termout on
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=5 TYPE=1>
prompt <LI> 
prompt <OL START=3 TYPE=1>
prompt <LI > Segments with lots of Extents (OverExtended Segments)
prompt <DL>
prompt <DD> Informação sobre as tabelas ou indexes com demasiados fragmentos da Base de Dados Oracle.
prompt <DD> Constata-se que existem algumas tabelas/indexes com mais de 200 extents.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Potentially Overextended Segments ( As of:  "  xdate " ) ***"
select SEGMENT_TYPE, 
			 OWNER, 
			 SEGMENT_NAME, 
			 PARTITION_NAME PARTITION, 
			 TABLESPACE_NAME, 
			 EXTENTS, 
			 MAX_EXTENTS
from dba_segments
where extents > 199
and SEGMENT_TYPE <> 'TEMPORARY'
order by extents desc;
TTitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=5 TYPE=1>
prompt <LI> 
prompt <OL START=4 TYPE=1>
prompt <LI > Top 10 Largest Tables
prompt <DL>
prompt <DD> Informação sobre as 10 maiores tabelas da Base de Dados Oracle.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
clear breaks
clear computes
clear columns
col OWNER form a20
col TABLE_NAME form a30
col MB form 999,999,999
set linesize 132
set heading on
set termout on
TTitle left " " skip 2 - left "*** Database:  "sxdbname", 10 Largest tables - Only Works 8i or above ( As of:  "  xdate " ) ***"
select * 
from  (select OWNER, 
						  SEGMENT_NAME TABLE_NAME, 
						  TABLESPACE_NAME, 
						  round(BYTES/1024/1024,0) MB
			from dba_segments
			where PARTITION_NAME is NULL
			and SEGMENT_TYPE = 'TABLE'
			order by MB desc)
where rownum < 11;
TTitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=5 TYPE=1>
prompt <LI> 
prompt <OL START=5 TYPE=1>
prompt <LI > Top 10 Largest Indexes
prompt <DL>
prompt <DD> Informação sobre as 10 maiores Indexes da Base de Dados Oracle.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
set heading off
set termout off
clear breaks
clear computes
clear columns
col OWNER form a20
col INDEX_NAME form a30
col MB form 999,999,999
set linesize 132
set heading on
set termout on
TTitle left " " skip 2 - left "*** Database:  "sxdbname", 10 Largest indexes - Only Works 8i or above ( As of:  "  xdate " ) ***"
select * 
from (select OWNER, 
					   SEGMENT_NAME INDEX_NAME, 
					   TABLESPACE_NAME, 
					   round(BYTES/1024/1024,0) MB
from dba_segments
where PARTITION_NAME is NULL
and SEGMENT_TYPE = 'INDEX'
order by MB desc)
where rownum < 11;
TTitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=5 TYPE=1>
prompt <LI> 
prompt <OL START=6 TYPE=1>
prompt <LI > Database Schema/Users Information
prompt <DL>
prompt <DD> Informação sobre os utilizadores que contem segmentos de Base de dados (objectos de Base de Dados que ocupam espaço físico na mesma, ex: Tabelas, indexes, materialized view, etc) e respectivo espaço ocupado pelos segmentos.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
set heading off
set termout off
clear breaks
clear computes
clear columns
set linesize 350
col id form 9999
col username form a20
col def_tblspc form a15
col tmp_tblspc form a10
col profile form a23
col status form a16
col MB_USED form 999,999,999
set heading on
set termout on
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Database Users ( As of:  "  xdate " ) ***"
select  username, 
			  user_id id, 
			  default_tablespace def_tblspc, 
			  temporary_tablespace tmp_tblspc, 
			  created, 
			  profile,
			  account_status status, 
			  round(sum(bytes/1024/1024),0) MB_USED
from dba_users du, dba_segments ds
where username=owner
group by username, user_id, default_tablespace,temporary_tablespace,created,profile,account_status;
TTitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear breaks
clear computes
clear columns
set heading on
set termout on
clear columns
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=6 TYPE=1>
prompt <LI> <B> Configurações de Segurança </B>
prompt <OL START=1 TYPE=1>
prompt <LI > Database Security Parameters
prompt <DL>
prompt <DD> Este item permite constatar as configurações de segurança da Base de Dados Oracle.
prompt <DD> Como se pode observar, estes parâmetros respeitam as boas praticas da Oracle.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
set linesize 140
column name format a35
col parameter form a12
set pagesize 10000

TTitle left " " skip 2 - left "*** Database:  "sxdbname", Security Related Parameters( As of:  "  xdate " ) ***"
select name, value "PARAMETER"
from   v$parameter 
where name in ('remote_login_passwordfile', 
							 'remote_os_authent', 
	       			 'os_authent_prefix', 
	       			 'dblink_encrypt_login',
	       			 'audit_trail', 
	       			 'transaction_auditing');
TTitle off
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
set heading off
set termout off
clear breaks
clear computes
clear columns
set heading on
set termout on
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=6 TYPE=1>
prompt <LI> 
prompt <OL START=2 TYPE=1>
prompt <LI > Information about Database Roles
prompt <DL>
prompt <DD> Este item permite obter informações sobre todos os Roles criados na Base de Dados (os Roles são grupos de privilégios que são atribuídos aos utilizadores).
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Info about Database Roles ( As of:  "  xdate " ) ***"
select * 
from dba_roles
order by role;
TTitle off
set heading off
set termout off
clear breaks
clear computes
clear columns
break on grantee
set heading on
set termout on
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=6 TYPE=1>
prompt <LI> 
prompt <OL START=3 TYPE=1>
prompt <LI > Worrying User with Some Admin Privileges
prompt <DL>
prompt <DD> Este item permite obter informações sobre os Utilizadores criados na Base de Dados com privilégios especiais.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Worrying System Privileges ( As of:  "  xdate " ) ***"
select grantee, 
			 privilege, 
			 admin_option
from   sys.dba_sys_privs 
where  (privilege like '% ANY %'
or   privilege in ('BECOME USER', 'UNLIMITED TABLESPACE')
or   admin_option = 'YES')
and   grantee not in ('SYS', 
                      'SYSTEM', 
                      'OUTLN', 
                      'AQ_ADMINISTRATOR_ROLE',
		                  'DBA', 
		                  'EXP_FULL_DATABASE', 
		                  'IMP_FULL_DATABASE',
		                  'OEM_MONITOR', 
		                  'CTXSYS', 
		                  'DBSNMP', 
		                  'IFSSYS',
		                  'IFSSYS$CM', 
		                  'MDSYS', 
		                  'ORDPLUGINS', 
		                  'ORDSYS',
		                  'TIMESERIES_DBA')
order by grantee;
TTitle off
set heading off
set termout off
clear breaks
clear computes
clear columns
set heading on
set termout on
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Users with SYSDBA Priv ( As of:  "  xdate " ) ***"
select * 
from V$PWFILE_USERS;
TTitle off
set heading off
set termout off
clear breaks
clear computes
clear columns
set heading on
set termout on
clear columns
prompt 
prompt 

set heading off
set termout off
clear breaks
clear computes
clear columns
set heading on
set termout on
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=6 TYPE=1>
prompt <LI> 
prompt <OL START=4 TYPE=1>
prompt <LI > Usuários com senhas iguais aos respectivos nomes
prompt <DL>
prompt <DD> Não devem haver usuários com senhas iguais aos respectivos nomes.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
prompt
col n form 9,999 heading "NUM_USERS"
var n number
TTitle left " " skip 2 - left "*** Database:  "sxdbname", Number of users that have password equal their names ( As of:  "  xdate " ) ***"
begin
 :n:=daa.count_weak_pass;
end;
/
print :n 
TTitle off
set heading off
set termout off
clear breaks
clear computes
clear columns
set heading on
set termout on
prompt
set heading on
set termout on
prompt
SET MARKUP HTML ENTMAP OFF
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt
SET MARKUP HTML ENTMAP OFF
prompt <OL START=6 TYPE=1>
prompt <LI> 
prompt <OL START=5 TYPE=1>
prompt <LI > Recomendação de aplicação de patches RDBMS Oracle (CPU - Critical Patch Update)
prompt <DL>
prompt <DD> A recomendação é feita pelo fabricante (Oracle) em bases regulares (normalmente em intervalos de 03 meses); a mensagem de recomendação do fabricante é enviada por email para a equipa DBA, e referencia os documentos de recomendação correlatos.
prompt </DL>
prompt </OL>
prompt </OL>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
SET MARKUP HTML ENTMAP OFF
prompt </td>
prompt </tr>
prompt </table>
prompt <table border='1' width='90%' align='center' summary='Script output'>
prompt <tr>
prompt <th scope="col">
prompt Aplicação
prompt </th>
prompt <th scope="col">
prompt BD
prompt </th>
prompt <th scope="col">
prompt Patch Recomendado
prompt </th>
prompt <th scope="col">
prompt Finalidade
prompt </th>
prompt <th scope="col">
prompt Verificação de necessidade
prompt </th>
prompt <th scope="col">
prompt Indicado por
prompt </th>
prompt <th scope="col">
prompt Documentação
prompt </th>
prompt <th scope="col">
prompt Data Aplicação Patch
prompt </th>
prompt <th scope="col">
prompt Constrangimentos
prompt </th>
prompt </tr>
prompt <tr>
prompt <td>
prompt NOME_APLICACAO
prompt </td>
prompt <td>
prompt NOME_BD
prompt </td>
prompt <td>
prompt PATCH(ES)_RECOMENDADOS
prompt </td>
prompt <td>
prompt Segurança de Dados
prompt </td>
prompt <td>
prompt DATA_EMISSAO_DOC_ORACLE_CRITICAL_PATCH_UPDATE_ADVISORY
prompt </td>
prompt <td>
prompt Oracle
prompt </td>
prompt <td>
prompt a) Oracle Critical Patch Update MES ANO Advisory (Metalink Note xxxxxx.x)
prompt b) Critical Patch Update MES ANO Availability for Oracle Server and Middleware Products (Metalink Note xxxxxx.x)
prompt </td>
prompt <td>
prompt ASD OU N/A, CONFORME O CASO (SE EXISTIR PATCH, VALOR=ASD)
prompt </td>
prompt <td>
prompt Necessidade de verificação de matriz de compatibilidade (versão do patch RDBMS versus Aplicação), análise e testes por parte das equipas de ST (Aplicação).
prompt </td>
prompt </tr>
prompt </table>
prompt <p>
prompt <HR>
SET MARKUP HTML ENTMAP ON
prompt 
prompt
prompt **********************************************************
prompt **********************************************************
PROMPT *******************  END OF REPORT   *********************
prompt **********************************************************
prompt **********************************************************

spool off
set feedback on

set markup html off spool off

exit
