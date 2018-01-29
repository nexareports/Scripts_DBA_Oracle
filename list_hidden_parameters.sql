--
-- List all hidden database parameters.
--
 
SET PAUSE ON
SET PAUSE 'Press Return to Continue'
SET PAGESIZE 60
SET LINESIZE 300
 
COLUMN ksppinm FORMAT A50
COLUMN ksppstvl FORMAT A50
 
SELECT
  ksppinm,
  ksppstvl
FROM
  x$ksppi a,
  x$ksppsv b
WHERE
  a.indx=b.indx 
AND
  substr(ksppinm,1,1) = '_'
ORDER BY ksppinm
/