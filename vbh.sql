prompt xcur - This is a RAM block that has been acquired in exclusive current mode. 
prompt scur - (RAC) a current mode block, shared with other instances
prompt cr - This mode indicates a cloned RAM block (a stale block), that was once in xcur mode.
prompt free - This is an available RAM block.  It might contain data, but it is not currently in-use by Oracle.
prompt read – The buffer is reserved for a block that is currently being read from disk.
prompt mrec – Indicates a block in media recovery mode
prompt irec – This is a block in instance (crash) recovery mode

prompt

col object_name format a20

Select * from (
SELECT o.owner,
       o.object_name,
       SUM(DECODE(bh.status, 'free', 1, 0)) AS free,
       SUM(DECODE(bh.status, 'xcur', 1, 0)) AS xcur,
       SUM(DECODE(bh.status, 'scur', 1, 0)) AS scur,
       SUM(DECODE(bh.status, 'cr', 1, 0)) AS cr,
       SUM(DECODE(bh.status, 'read', 1, 0)) AS read,
       SUM(DECODE(bh.status, 'mrec', 1, 0)) AS mrec,
       SUM(DECODE(bh.status, 'irec', 1, 0)) AS irec,
       count(*)
FROM   v$bh bh
       JOIN dba_objects o ON o.object_id = bh.objd
GROUP BY o.owner, o.object_name
order by 10 desc) where rownum<21;


