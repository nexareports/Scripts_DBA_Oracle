--set LINESIZE 500
--set feedback off
COLUMN name  FORMAT A30
COLUMN value FORMAT A60

SELECT p.name,
       p.type,
       p.value,
       p.isses_modifiable,
       p.issys_modifiable
FROM   v$parameter p
ORDER BY p.name;
--set feedback on
