column  NA      format a39          heading 'STATISTIC'
column  VALUE   format 999999999999999999990  heading 'VALUE'

select  rpad (NAME, 39, '.') as NA,
        VALUE
  from  V$SYSSTAT
 where  NAME like ('%SQL*Net%')
 order  by NA
/

column  NA      clear
column  VALUE   clear
