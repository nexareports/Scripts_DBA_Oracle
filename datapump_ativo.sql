Promp Currently Active DataPump Operations
COL owner_name          FORMAT A10      HEADING 'Owner'
COL job_name            FORMAT A20      HEADING 'JobName'
COL operation           FORMAT A12      HEADING 'Operation'
COL job_mode            FORMAT A12      HEADING 'JobMode'
COL state               FORMAT A12      HEADING 'State'
COL degree              FORMAT 9999     HEADING 'Degr'
COL attached_sessions   FORMAT 9999     HEADING 'Sess'

SELECT 
     owner_name
    ,job_name
    ,operation
    ,job_mode
    ,state
    ,degree
    ,attached_sessions
  FROM dba_datapump_jobs
;


Prompt Currently Active DataPump Sessions
COL owner_name          FORMAT A06      HEADING 'Owner'
COL job_name            FORMAT A06      HEADING 'Job'
COL osuser              FORMAT A12      HEADING 'UserID'

SELECT 
     DPS.owner_name
    ,DPS.job_name
    ,S.osuser
  FROM 
     dba_datapump_sessions DPS
    ,v$session S
 WHERE S.saddr = DPS.saddr
;      

COL owner_name clear       
COL job_name   clear       
COL operation        clear 
COL job_mode          clear
COL state             clear
COL degree            clear
COL attached_sessions clear
COL osuser clear

@__conf



