--set PAGES 1000
--set LINESIZE 200
col Factor format a6

SELECT 
       l.name,
       l.gets,
       l.misses,
       to_char(round((l.misses/l.gets),2)*100)||'%' Factor,
       l.spin_gets
FROM   v$latch l
WHERE  l.gets > 0 and round((l.misses/l.gets),2)*100 > 0
ORDER BY 4 DESC;
