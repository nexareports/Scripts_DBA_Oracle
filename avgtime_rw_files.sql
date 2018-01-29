set lines 250
set pages 1000
col name format a65
col readtim/phyrds heading 'avg|read time' format 9,999.999
col writetim/phywrts heading 'avg|write time' format 9,999.999
set lines 132 pages 45
set feed off 

prompt IO timing analysis - data files
select  f.file#
,d.name,phyrds,phywrts,readtim/phyrds,writetim/phywrts
from v$filestat f, v$datafile d
where f.file#=d.file#
and phyrds>0 and phywrts>0
and rownum<&1+1
order by 5 desc
/

prompt IO timing analysis - temp files
select  a.file#
,b.name,phyrds,phywrts,readtim/phyrds,writetim/phywrts
from v$tempstat a, v$tempfile b
where a.file#=b.file#
and phyrds>0 and phywrts>0
and rownum<&1+1
order by 5 desc
/


prompt   
prompt select file_id,bytes/1024/1024 mb from dba_datafiles where file_id=
prompt /
prompt   



set feed on 

