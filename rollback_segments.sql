-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2009 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : rollback_segments.sql                                           |
-- | CLASS    : Rollback Segments                                               |
-- | PURPOSE  : Reports rollback statistic information including name, shrinks, |
-- |            wraps, size and optimal size.                                   |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

--set LINESIZE 145
--set PAGESIZE 9999

COLUMN roll_name   FORMAT a40                HEADING 'Rollback Name'
COLUMN tablespace  FORMAT a11                HEADING 'Tablspace'
COLUMN in_extents  FORMAT a20                HEADING 'Init/Next Extents'
COLUMN m_extents   FORMAT a20                HEADING 'Min/Max Extents'
COLUMN status      FORMAT a8                 HEADING 'Status'
COLUMN wraps       FORMAT 999,999            HEADING 'Wraps' 
COLUMN shrinks     FORMAT 999,999            HEADING 'Shrinks'
COLUMN opt         FORMAT 999,999,999        HEADING 'Opt. Size'
COLUMN bytes       FORMAT 999,999,999,999    HEADING 'Bytes'
COLUMN extents     FORMAT 999                HEADING 'Extents'

SELECT
    a.owner || '.' || a.segment_name          roll_name
  , a.tablespace_name                         tablespace
  , TO_CHAR(a.initial_extent) || ' / ' ||
    TO_CHAR(a.next_extent)                    in_extents
  , TO_CHAR(a.min_extents)    || ' / ' ||
    TO_CHAR(a.max_extents)                    m_extents
  , a.status                                  status
  , b.bytes                                   bytes
  , b.extents                                 extents
  , d.shrinks                                 shrinks
  , d.wraps                                   wraps
  , d.optsize                                 opt
FROM
    dba_rollback_segs a
  , dba_segments b
  , v$rollname c
  , v$rollstat d
WHERE
       a.segment_name = b.segment_name
  AND  a.segment_name = c.name (+)
  AND  c.usn          = d.usn (+)
ORDER BY a.segment_name
/
