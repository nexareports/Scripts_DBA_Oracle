SELECT * from MGMT_CURRENT_SEVERITY 
where severity_code > 20;

exec EM_SEVERITY.delete_current_severity(TARGET_GUID,METRIC_GUID,KEY_VALUE);

SELECT ' exec SYSMAN.EM_SEVERITY.delete_current_severity('''||TARGET_GUID||''','''||METRIC_GUID||''','''||KEY_VALUE||''');'
from MGMT_CURRENT_SEVERITY 
--where severity_code > 20;

--All Metric Errors
--MGMT_CURRENT_METRIC_ERRORS