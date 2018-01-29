SELECT s.sid, s.serial#, s.username, s.program,
i.block_changes
FROM v$session s, v$sess_io i
WHERE s.sid = i.sid
ORDER BY 5 desc, 1, 2, 3, 4;


SELECT s.sid, s.serial#, s.username, s.program, 
t.used_ublk, t.used_urec
FROM v$session s, v$transaction t
WHERE s.taddr = t.addr
ORDER BY 5 desc, 6 desc, 1, 2, 3, 4;

/* 
SQL: How to Find Sessions Generating Lots of Redo or Archive logs (Doc ID 167492.1)	To BottomTo Bottom	
Modified:07-May-2014Type:HOWTO	
Rate this document	Email link to this document	Open document in new window	Printable Page
***Checked for relevance on 22-Sep-2011***

    goal: How to find sessions generating lots of redo
    fact: Oracle Server - Enterprise Edition 8
    fact: Oracle Server - Enterprise Edition 9
    fact: Oracle Server - Enterprise Edition 10 



fix:

To find sessions generating lots of redo, you can use either of the following 
methods. Both methods examine the amount of undo generated. When a transaction 
generates undo, it will automatically generate redo as well.

The methods are:
1) Query V$SESS_IO. This view contains the column BLOCK_CHANGES which indicates
   how much blocks have been changed by the session. High values indicate a 
   session generating lots of redo.

   The query you can use is:
       SQL> SELECT s.sid, s.serial#, s.username, s.program,
         2  i.block_changes
         3  FROM v$session s, v$sess_io i
         4  WHERE s.sid = i.sid
         5  ORDER BY 5 desc, 1, 2, 3, 4;

   Run the query multiple times and examine the delta between each occurrence
   of BLOCK_CHANGES. Large deltas indicate high redo generation by the session.

2) Query V$TRANSACTION. This view contains information about the amount of
   undo blocks and undo records accessed by the transaction (as found in the 
   USED_UBLK and USED_UREC columns).
 
  The query you can use is:
      SQL> SELECT s.sid, s.serial#, s.username, s.program, 
        2  t.used_ublk, t.used_urec
        3  FROM v$session s, v$transaction t
        4  WHERE s.taddr = t.addr
        5  ORDER BY 5 desc, 6 desc, 1, 2, 3, 4;

   Run the query multiple times and examine the delta between each occurrence
   of USED_UBLK and USED_UREC. Large deltas indicate high redo generation by 
   the session.

You use the first query when you need to check for programs generating lots of 
redo when these programs activate more than one transaction. The latter query 
can be used to find out which particular transactions are generating redo.

*/