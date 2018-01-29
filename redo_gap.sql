SELECT max(sequence#),count(*),applied
FROM   v$archived_log where first_time>trunc(sysdate)-1 and applied!='YES'
group by applied
ORDER BY 1;