SELECT 'Exec DBMS_JOB.what( job =>'||J.job||', what => ''DBMS_REFRESH_DURATION('''''||r.rowner||''''','''''||R.RNAME||''''');'')'
FROM DBA_jobs J, dba_refresh R
WHERE J.JOB=R.JOB
AND R.rowner in ('DSITRP','DSAPARP','DNSOMRP','DGCARP','DINTGLRP','DSIGNETRP')
AND J.WHAT NOT LIKE '%DBMS_REFRESH_DURATION%'
ORDER BY R.RNAME;