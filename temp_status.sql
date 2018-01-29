-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2007 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : temp_status.sql                                                 |
-- | CLASS    : Temporary_Tablespace                                            |
-- | PURPOSE  : List all temporary tablespaces along with a brief status.       |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

--set LINESIZE 145
--set PAGESIZE 9999
--set VERIFY   off

COLUMN tablespace_name       FORMAT a18               HEAD 'Tablespace Name'
COLUMN tablespace_status     FORMAT a9                HEAD 'Status'
COLUMN tablespace_size       FORMAT 999,999,999,999   HEAD 'Size'
COLUMN used                  FORMAT 999,999,999,999   HEAD 'Used'
COLUMN used_pct              FORMAT 999               HEAD 'Pct. Used'
COLUMN current_users         FORMAT 9,999             HEAD 'Current Users'

BREAK ON report
COMPUTE SUM OF tablespace_size  ON report
COMPUTE SUM OF used             ON report
COMPUTE SUM OF current_users    ON report

SELECT
    d.tablespace_name                      tablespace_name
  , d.status                               tablespace_status
  , NVL(a.bytes, 0)                        tablespace_size
  , NVL(t.bytes, 0)                        used
  , TRUNC(NVL(t.bytes / a.bytes * 100, 0)) used_pct
  , NVL(s.current_users, 0)                current_users
FROM
    sys.dba_tablespaces d
  , ( select tablespace_name, sum(bytes) bytes
      from dba_temp_files
      group by tablespace_name
    ) a
  , ( select tablespace_name, sum(bytes_cached) bytes
      from v$temp_extent_pool
      group by tablespace_name
    ) t
  , v$sort_segment  s
WHERE
      d.tablespace_name = a.tablespace_name(+)
  AND d.tablespace_name = t.tablespace_name(+)
  AND d.tablespace_name = s.tablespace_name(+)
  AND d.extent_management like 'LOCAL'
  AND d.contents like 'TEMPORARY'
/

