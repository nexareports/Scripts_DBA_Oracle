--set LINESIZE 120
COLUMN name          FORMAT A30
COLUMN current_value FORMAT A30
COLUMN sid           FORMAT A8
COLUMN spfile_value  FORMAT A30

SELECT p.name,
       i.instance_name AS sid,
       p.value AS current_value,
       sp.sid,
       sp.value AS spfile_value      
FROM   v$spparameter sp,
       v$parameter p,
       v$instance i
WHERE  sp.name   = p.name
AND    sp.value != p.value;

COLUMN FORMAT DEFAULT
