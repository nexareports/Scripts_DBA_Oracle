SELECT 'ALTER SYSTEM KILL SESSION '''
|| sid
|| ','
|| serial#
|| ',@'
|| inst_id
|| ''' immediate;',
status
FROM gv$session
WHERE username = 'HRCTABLES'
;