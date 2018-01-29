
col name format a35

--set feed off 
prompt
prompt Todos os tempos estao em ms
prompt Oracle considers average read times of greater than 20 ms unacceptable. - Note 228913.1
prompt
prompt IO timing analysis - data files
select * from (
select  f.file#
,d.name,phyrds,phywrts,round((readtim/100/phyrds)*1000,2) Read_Time,round(d.bytes/1024/1024) Mb
from v$filestat f, v$datafile d
where f.file#=d.file#
and phyrds>0 and phywrts>0
order by 5 desc) where rownum<11
/

prompt IO timing analysis - temp files
select  a.file#
,b.name,phyrds,phywrts,round((readtim/100/phyrds)*1000,2) Read_Time,round(b.bytes/1024/1024) Mb
from v$tempstat a, v$tempfile b
where a.file#=b.file#
and phyrds>0 and phywrts>0
order by 5 desc
/

@__conf

--set feed on 

