--
-- List Flashback Database Restore Points
--

SET PAGESIZE 60
SET LINESIZE 300
SET VERIFY OFF
 
COLUMN scn FOR 999999999999999
COLUMN Incar FOR 99
COLUMN name FOR A25
COLUMN guarantee_flashback_database FOR A3
 
SELECT 
      database_incarnation# as Incar,
      scn,
      name,
      time,
      round(storage_size/1048576) storage_size_MB,
      guarantee_flashback_database
FROM 
      v$restore_point
ORDER BY
	  time
/