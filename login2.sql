
define _editor=NotEpad
set lines 140
set pages 23
set feed on
set pagesize 2000
set echo off
set timing off
set time off
set doc off

col avgwaittime format a30 head "Average Wait Time Per Response"
col Avgtimeresp format a30  head "Average Time per Response"
col broken format a1 head "B"
col busy_time_cur format 9999999 head "BsyTimeCur"
col busy_time_total format 9999999 head "BsyTimeTot"
col buf format 99,999,999,999,999 head "BufGet"
col bytes format 99,999,999 head Bytes
col cr_get format 999999 head "CrGet"
col cr_change format 999999 head "CrChange"
col column_name format a25 head "Column"
col codigo_pl format a73 head "Codigo PL Sql"
col curext format 99 head Ex
col curblk format  99999 head Blk
col column_position format 999 head "Col Pos"
col db_link format a25
col extents format 99999 head "Exts"
col executions format 99,999,999 head "Executions"
col disk format 99,999,999 head "DskRead"
col event format a30 head Event
col file_name format a45 head FileName
col freelists format 99 head FLsts 
col gets format 999999999 head Gets
col horario format a19 head "Horario"
col hitrat format 999.99 head "HitRat"
col host format a20
col idle_time_cur format 9999999 head "IdlTimCur"
col index_name format a30 head "Indice"
col interval format a15 head "Interval"
col initial_extent format 9,999,999,999 head IniExt
col idle format 999,999,999 head "Idle"
col idle_time_total format 9999999 head "IdlTimTot"
col job format 99999 head "Job #"
col kbytes format 99,999,999.99 head KBytes
col Last_date format a9 head "lastDate"
col lin format 9999999 head "RowProc"
col line format 99999 head "Linha"
col logtime format a8 head "LogTime"
col log_io format 99999 head "LogIO"
col logon_time format a20 head "Logon Day"
col log_user format a8 head "Log User"
col listener format 99999 head "Listener"
col latch_name format a25 head "Latch Name"
col machine format a25 head "Machine"
col module format a20 head "Module"
col megas format 99,999,999.99 head Megas
col misses format 9999999 head Misses
col messages format 999,999,999 head "Messages"
col member format a35 head Member
col namespace format a15 head "NameSpace"
col name_disp format a6 head "Dispat"
col network format a15 head "Network Protocol"
col num format 9999 head "Num"
col nextmega format 999,999.99 head "Next M"
col nexecution format a20 head "Next Execution"
col next_extent format 9,999,999,999 head NxtExt
col name format a30 head Name
col name_dep format a12 head Name
col object_type format a16 head "ObjectType"
col object_id format 9999 head "ObjId"
col object_name format a30 head "Object"
col operation   format a30 head "Operation"
col osuser format a9 head "OS User"
col opt format a10 head "Optimizer"
col optsize format 99.9 head "Opt"
col owner format a15 head Owner
col pct_increase format 999 head PctI
col pctpinsreloads format 999.99 head PctPinRel
col process format 9999999 head "Process"
col protocol format a45 head "Protocol"
col pins format 999,999,999 head Pins
col pcalls format 99,999,999 head "PaC"
col phy_io format 99999 head "PhyIO"
col phyrds format 999,999,999 head "PhyRds"
col phyblkrd format 999,999,999 head "PhyBlkRds"
col phywrts format 999,999,999 head "PhyWrts"
col phyblkwrt format 999,999,999 head "PhyBlkWrts"
col referenced_name format a12 head "Ref Name"
col referenced_owner format a10 head "Ref Owner"
col referenced_type format a12 head "Ref Type"
col reloads format 999,999,999 head Reloads
col rbs format a6 head "Rbs"
col statistic format a30 head "Statistic"
col status format a8 head "Status"
col spid format 99999 head "OsPId"
col segment_name format a30 head "Segment Name"
col segtorbs format a6 head "Rbs"
col segment_type format a10 head "Segmt Type"
col serial# format 99999 head "Serial"
col secswait format 999,999,999 head "Seconds Wait"
col sessions format 99999 head "Sessions"
col slave_name format a20 head "Slave Name"
col sleeps format 999999 head "Sleeps"
col status format a8 head Status
col shrinks format 999 head Skrs
col sid format 99999 head "Sid"
col start_time format a17 head "Start Time"
col session_id format 99999 head SesId
col "SLEEPS/MISS" format 999.99 head Slp/Mis
col table_name format a30 head "Table Name"
col tablespacefree format a25 head "Tablespace Free Space"
col tablespace_name format a25 head Tablespace
col total_waits format 999,999,999 head "Tot Waits"
col total format 99999 head "Tot Tipo"
col terminal format a10 head "Terminal"
col texto format a32 head "Text in SQL Area"
col totbusyrat format 99,999.9999 head "Total Busy Rate"
col time format a6
col timebusy format 999.99 head "Dispatchers Perct Time Busy"
col type format a15 head "Type"
col total_timeouts format 999,999,999 head "Tot TimOuts"
col xidsqn format 99999999 head "XSeqN"
col xidusn format 999 head Usn
col xacts format 9999 head "XActs"
col "%hit rat" format 999.99   
col users format 999 head "Usr"
col used_ublk format 99999999 head UsedBlocks
col username format a15 head "Username"
col value format 99,999,999,999 head "Value"
col value_set format a30 head Value
col waits format 99999999 head Waits
col what format a15 head "What is the Job"
col wraps format 9999 head Wraps

col sqpromp noprint new_value sq_promp
select distinct a.host_name||'.'||c.osuser||'.'||user||'@'||a.instance_name||'.'||'SID='||b.sid sqpromp
from v$instance a, v$mystat b, v$session c
where c.username is null and c.osuser is not null
/
define sq_promp=&&sq_promp

set sqlprompt &&sq_promp> 

undefine sq_promp
define _editor=Notepad

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS'
/
clear screen