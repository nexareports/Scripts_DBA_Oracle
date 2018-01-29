col name for a40
select name, 
round(space_limit / 1048576) space_limit_in_mb, 
round(space_used / 1048576) space_used_in_mb, 
round((space_used / 1048576) / (space_limit / 1048576),2)*100 percent_usage
from v$recovery_file_dest;