-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2007 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : temp_sort_users.sql                                             |
-- | CLASS    : Temporary_Tablespace                                            |
-- | PURPOSE  : List all temporary tablespaces and the users performing sorts.  |
-- |            The statistics will come from the v$sort_usage view which shows |
-- |            currently active sorts for the instance. Joining "v$sort_usage" |
-- |            to "v$session" will provide the user who is performing a sort   |
-- |            within the sort segment.                                        |
-- |            The CONTENTS column shows whether the segment is created in a   |
-- |            temporary or permanent tablespace, however, unless you are      |
-- |            using Oracle8, this should always be temporary.                 |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

--set LINESIZE 145
--set PAGESIZE 9999
--set VERIFY   off

COLUMN tablespace_name       FORMAT a15               HEAD 'Tablespace Name'
COLUMN username              FORMAT a15               HEAD 'Username'
COLUMN sid                   FORMAT 9999              HEAD 'SID'
COLUMN serial_id             FORMAT 99999999          HEAD 'Serial#'
COLUMN contents              FORMAT a9                HEAD 'Contents'
COLUMN extents               FORMAT 999,999           HEAD 'Extents'
COLUMN blocks                FORMAT 999,999,999       HEAD 'Blocks'
COLUMN bytes                 FORMAT 999,999,999       HEAD 'MB'
COLUMN segtype               FORMAT a12               HEAD 'Segment Type'

BREAK ON tablespace_name ON report
COMPUTE SUM OF extents   ON report
COMPUTE SUM OF blocks    ON report
COMPUTE SUM OF bytes     ON report


SELECT
    b.tablespace          					tablespace_name
  , a.username            					username
  , a.sid                 					sid
  , a.serial#             					serial_id
  , b.contents            					contents
  , b.segtype             					segtype
  , b.extents             					extents
  , b.blocks              					blocks
  , round((b.blocks * c.value)/1048576)  	bytes
FROM
    v$session     a
  , v$sort_usage  b
  , (select value from v$parameter
     where name = 'db_block_size') c
WHERE
      a.saddr = b.session_addr
ORDER BY b.tablespace      
/

