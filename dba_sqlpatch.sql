--
-- DBA Registry SQL Patch
-- 
-- JAF - 2016-02-15 - v2.0
--
-- https://blogs.oracle.com/UPGRADE/entry/dba_registry_history_vs_dba
--

SET LINESIZE 400
COLUMN action_time FORMAT A20
COLUMN action FORMAT A10
COLUMN status FORMAT A10
COLUMN description FORMAT A30
COLUMN version FORMAT A10
COLUMN bundle_series FORMAT A10
COLUMN logfile FORMAT A95

SELECT TO_CHAR(action_time, 'DD-MM-YYYY HH24:MI:SS') AS action_time,
       action,
       status,
       description,
       --version,
       patch_id,
       logfile
       --,bundle_series
FROM   sys.dba_registry_sqlpatch
ORDER by action_time;