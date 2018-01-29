
SET LINESIZE 145
SET PAGESIZE 9999
SET VERIFY   off

COLUMN ptyp      FORMAT a13                  HEADING 'Object Type'
COLUMN obj       FORMAT a42                  HEADING 'Object Name'
COLUMN noe       FORMAT 999,999,999,999,999  HEADING 'Number of Executions'

BREAK ON report
COMPUTE sum OF noe   ON report
Select * from (
SELECT
    ptyp
  , obj
  , 0 - exem noe
FROM ( select distinct exem, ptyp, obj  
       from ( select
                  o.type                    ptyp
                , o.owner || '.' || o.name  obj
                , 0 - o.executions          exem
              from  v$db_object_cache O 
              where o.type in ('FUNCTION','PACKAGE','PACKAGE BODY','PROCEDURE','TRIGGER')
	   )
     )order by 3 desc)
WHERE rownum <= 10;

