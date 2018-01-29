select 'PTIB1',a.* from (with tbs as (select monitorizacao.GREEN_TBS_FUNC('PTIB1') V from dual) select V, Case V when 0 then 'Ok' when 1 then 'Warning' when 2 then 'Critical' when 3 then 'Em intervenção' end MSG from tbs) a
union all
select 'PTIBL1',a.* from (with tbs as (select monitorizacao.GREEN_TBS_FUNC('PTIBO1') V from dual) select V, Case V when 0 then 'Ok' when 1 then 'Warning' when 2 then 'Critical' when 3 then 'Em intervenção' end MSG from tbs) a
union all
select 'PTIBL2',a.* from (with tbs as (select monitorizacao.GREEN_TBS_FUNC('PTIBO2') V from dual) select V, Case V when 0 then 'Ok' when 1 then 'Warning' when 2 then 'Critical' when 3 then 'Em intervenção' end MSG from tbs) a
union all
select 'PTIBO1',a.* from (with tbs as (select monitorizacao.GREEN_TBS_FUNC('PTIBL1') V from dual) select V, Case V when 0 then 'Ok' when 1 then 'Warning' when 2 then 'Critical' when 3 then 'Em intervenção' end MSG from tbs) a
union all
select 'PTIBO2',a.* from (with tbs as (select monitorizacao.GREEN_TBS_FUNC('PTIBL2') V from dual) select V, Case V when 0 then 'Ok' when 1 then 'Warning' when 2 then 'Critical' when 3 then 'Em intervenção' end MSG from tbs) a;