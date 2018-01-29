col DATA format a20
col MESSAGE_TEXT format a130
select trunc(ORIGINATING_TIMESTAMP,'MI') DATA,MESSAGE_TEXT from V$DIAG_ALERT_EXT where COMPONENT_ID like '%rdbms%' and ORIGINATING_TIMESTAMP>trunc(&1);
col DATA clear
col MESSAGE_TEXT clear