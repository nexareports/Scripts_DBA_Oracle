select tablespace_name, initial_extent/1024 "Init Kb", next_extent/1024 "Next Kb"
from user_tablespaces
where tablespace_name like '&tbs';