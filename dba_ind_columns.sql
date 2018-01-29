REM Parametros OWNER TABLE
Col Col format a30
Col OWN format a15
Select Table_Owner OWN,Index_name IDX,Column_name COL,Column_Position CP
from dba_ind_columns
where table_owner='&1' and table_name='&2'
Order by 1,2,4;

Col Col clear
Col OWN clear