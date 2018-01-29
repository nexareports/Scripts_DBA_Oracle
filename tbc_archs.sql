alter session set current_schema=MONITORIZACAO;

select 'PTIB1',GREEN_ARCHIVE_STATUS_FUNC('PTIB1') F,case  GREEN_ARCHIVE_STATUS_FUNC('PTIB1') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual
union all
select 'PTIBL1',GREEN_ARCHIVE_STATUS_FUNC('PTIBL1') F,case  GREEN_ARCHIVE_STATUS_FUNC('PTIBL1') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual 
union all
select 'PTIBL2',GREEN_ARCHIVE_STATUS_FUNC('PTIBL2') F,case  GREEN_ARCHIVE_STATUS_FUNC('PTIBL2') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual 
union all
select 'PTIBO1',GREEN_ARCHIVE_STATUS_FUNC('PTIBO1') F,case  GREEN_ARCHIVE_STATUS_FUNC('PTIBO1') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual 
union all
select 'PTIBO2',GREEN_ARCHIVE_STATUS_FUNC('PTIBO2') F,case  GREEN_ARCHIVE_STATUS_FUNC('PTIBO2') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual
union all
select 'SPTIB1',GREEN_ARCHIVE_STATUS_FUNC('SPTIB1') F,case  GREEN_ARCHIVE_STATUS_FUNC('SPTIB1') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual
union all
select 'SPTIBL1',GREEN_ARCHIVE_STATUS_FUNC('SPTIBL1') F,case  GREEN_ARCHIVE_STATUS_FUNC('SPTIBL1') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual
union all
select 'SPTIBL2',GREEN_ARCHIVE_STATUS_FUNC('SPTIBL2') F,case  GREEN_ARCHIVE_STATUS_FUNC('SPTIBL2') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual 
union all
select 'SPTIBO1',GREEN_ARCHIVE_STATUS_FUNC('SPTIBO1') F,case  GREEN_ARCHIVE_STATUS_FUNC('SPTIBO1') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual 
union all
select 'SPTIBO2',GREEN_ARCHIVE_STATUS_FUNC('SPTIBO2') F,case  GREEN_ARCHIVE_STATUS_FUNC('SPTIBO2') when 0 then 'Ok' when 1 then 'Warning' when 2 then  'Archive Area Full' when 3 then 'Em intervenção' end MSG from dual
order by  2,1;



