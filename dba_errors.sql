-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2008 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : dba_errors.sql                                                  |
-- | CLASS    : Database Administration                                         |
-- | PURPOSE  : Report on all procedural (PL/SQL, Views, Triggers, etc.) errors.|
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

SET LINESIZE 145
SET PAGESIZE 9999
SET VERIFY   off

COLUMN type                 FORMAT a15      HEAD 'Object Type'
COLUMN owner                FORMAT a17      HEAD 'Schema'
COLUMN name                 FORMAT a30      HEAD 'Object Name'
COLUMN sequence             FORMAT 999,999  HEAD 'Sequence'
COLUMN line                 FORMAT 999,999  HEAD 'Line'
COLUMN position             FORMAT 999,999  HEAD 'Position'
COLUMN text                                 HEAD 'Text'

SELECT
    type
  , owner
  , name
  , sequence
  , line
  , position
  , text || chr(10) || chr(10) text
FROM
    dba_errors
ORDER BY
    1, 2, 3
/

