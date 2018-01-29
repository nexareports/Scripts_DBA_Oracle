column  STATISTIC#  form 999999        head 'Id'
column  NA          form a32        head 'Statistic'
column  RIA         form 9999990.90     head 'Row Access via|Index [%]'
column  RTS         form 9999990.90     head 'Row Access via|Table Scan [%]'
column  RA          form 99999999999999990 head 'Rows accessed'
column  PCR         form 9999990.90     head 'Chained|Rows [%]'
colum   CL          form 9999990.90     head 'Cluster|Length'

ttitle  left  'Monitor Data Access Activities'  skip 2

spool   monitor_data_activites.log

select  rpad (NAME, 32, '.') as NA,
        VALUE
  from  V$SYSSTAT
 where  NAME like '%table scan%'
    or  NAME like '%table fetch%'
    or  NAME like '%cluster%';

ttitle  off

select  A.VALUE + B.VALUE                     as RA,
        A.VALUE / (A.VALUE + B.VALUE) * 100.0 as RIA,
        B.VALUE / (A.VALUE + B.VALUE) * 100.0 as RTS,
        C.VALUE / (A.VALUE + B.VALUE) * 100.0 as PCR,
        E.VALUE / D.VALUE                     as CL
  from  V$SYSSTAT A,
        V$SYSSTAT B,
        V$SYSSTAT C,
        V$SYSSTAT D,
        V$SYSSTAT E
 where  A.NAME = 'table fetch by rowid'
   and  B.NAME = 'table scan rows gotten'
   and  C.NAME = 'table fetch continued row'
   and  D.NAME = 'cluster key scans'
   and  E.NAME = 'cluster key scan block gets'
/

column  STATISTIC#  clear
column  NA          clear
column  RIA         clear
column  RTS         clear
column  RA          clear
column  PCR         clear
colum   CL          clear