select 'SPTIB1',GREEN_DG_LAG_FUNC('SPTIB1') F,case  GREEN_DG_LAG_FUNC('SPTIB1') when 0 then 'Ok' when 1 then 'Dataguard atrasado >15min' when 2 then  'Dataguard atrasado >30min' when 3 then 'Em intervenção' end MSG from dual
union all
select 'SPTIBL1',GREEN_DG_LAG_FUNC('SPTIBL1') F,case  GREEN_DG_LAG_FUNC('SPTIBL1') when 0 then 'Ok' when 1 then 'Dataguard atrasado >15min' when 2 then  'Dataguard atrasado >30min' when 3 then 'Em intervenção' end MSG from dual
union all
select 'SPTIBL2',GREEN_DG_LAG_FUNC('SPTIBL2') F,case  GREEN_DG_LAG_FUNC('SPTIBL2') when 0 then 'Ok' when 1 then 'Dataguard atrasado >15min' when 2 then  'Dataguard atrasado >30min' when 3 then 'Em intervenção' end MSG from dual 
union all
select 'SPTIBO1',GREEN_DG_LAG_FUNC('SPTIBO1') F,case  GREEN_DG_LAG_FUNC('SPTIBO1') when 0 then 'Ok' when 1 then 'Dataguard atrasado >15min' when 2 then  'Dataguard atrasado >30min' when 3 then 'Em intervenção' end MSG from dual 
union all
select 'SPTIBO2',GREEN_DG_LAG_FUNC('SPTIBO2') F,case  GREEN_DG_LAG_FUNC('SPTIBO2') when 0 then 'Ok' when 1 then 'Dataguard atrasado >15min' when 2 then  'Dataguard atrasado >30min' when 3 then 'Em intervenção' end MSG from dual;


