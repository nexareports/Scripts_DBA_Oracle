Select 
	trunc(DATA_RECOLHA,'DD') DATA,
	round(sum(DIM_EM_MB)) "Tamanho BD (MB)"
From BMIMS.DIM_SEGMENTOS
where DATA_RECOLHA>trunc(sysdate)-180
group by trunc(DATA_RECOLHA,'DD')
order by 1;