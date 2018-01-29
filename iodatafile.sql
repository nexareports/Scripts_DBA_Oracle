set lines 250
SET PAGESIZE 1000

SELECT Substr(d.name,1,50) "Arquivo",
       f.phyblkrd "Blocos lidos",
       f.phyblkwrt "Blocos escritos",
       f.phyblkrd + f.phyblkwrt "Total I/O",
       f.AVGIOTIM "Avg"
FROM   v$filestat f,
       v$datafile d
WHERE  d.file# = f.file#
ORDER BY f.AVGIOTIM desc,f.phyblkrd + f.phyblkwrt DESC;

SET PAGESIZE 18
