set pages 0
select ORIGINATING_TIMESTAMP, MESSAGE_TEXT from V$DIAG_ALERT_EXT where COMPONENT_ID like '%rdbms%' and ORIGINATING_TIMESTAMP>trunc(sysdate-1);