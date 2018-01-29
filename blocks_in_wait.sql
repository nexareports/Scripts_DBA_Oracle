--set lines 250
--set pages 1000

select
   p1 "File #",
   p2 "Block #",
   p3 "Reason Code"
from
   v$session_wait
where
   event like 'buffer busy waits' or event like '%read by other%';  

@__conf   