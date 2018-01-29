-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2008 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : rman_configuration.sql                                          |
-- | CLASS    : Recovery Manager                                                |
-- | PURPOSE  : Provide a listing of all non-default RMAN configuration         |
-- |            parameters.                                                     |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+


COLUMN name     FORMAT a48   HEADING 'Name'
COLUMN value    FORMAT a55   HEADING 'Value'

prompt 
prompt All RMAN Configuration Settings that are not default
prompt 

SELECT
    name
  , value
FROM
    v$rman_configuration
ORDER BY
    name
/

