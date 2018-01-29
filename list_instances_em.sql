--
-- JAF 31/10/2017
--
-- Lista Instancias Cloud Control
--

select host_name, display_name, type_display_name, version, type, substr(environment,2) environment, target_group
FROM
(
	SELECT t.host_name,
	       t.display_name,
	       t.type_display_name,
           t.CATEGORY_PROP_1 version,
           t.CATEGORY_PROP_3 type,
	       case 
	       		when t.display_name like 'P%' then '1PRD'
	       		when t.display_name like 'Q%' then '3QUA'
	       		when t.display_name like 'D%' then '5DSV'
	       		when t.display_name like 'SP%' or t.display_name like 'S1%' or t.display_name like 'S2%' then '2PRD_DG'
	       		when t.display_name like 'SQ%' then '4QUA_DG'
	       		when t.display_name = 'dbfwdb_PRD' or t.display_name = 'RFU' or t.display_name = 'CREP' then '1PRD'
	       		when t.display_name = 'CVUC' then '6POC'
	       		else 'MISC'
	       	end environment,
	       case
	       		when max(g.composite_target_name) like '%ESI%' then 'NBSI'
	       		when max(g.composite_target_name) like '%IBM%' then 'IBM'
	       		else 'CLOUD'
	       end target_group
	FROM sysman.mgmt_targets t,
	     SYSMAN.MGMT$GROUP_DERIVED_MEMBERSHIPS g
	WHERE t.target_type IN ('rac_database',
	                        'oracle_database')
	  AND t.target_type=g.member_target_type(+)
	  AND t.target_name=g.member_target_name(+)
	  AND (g.composite_target_name LIKE ('ESI%')
	       OR g.composite_target_name LIKE ('IBM%'))
	GROUP BY t.host_name,
	         t.display_name,
	         t.type_display_name,
             t.CATEGORY_PROP_1,
             t.CATEGORY_PROP_3
	UNION ALL
	SELECT t.host_name,
	       t.display_name,
	       t.type_display_name,
           t.CATEGORY_PROP_1 version,
           t.CATEGORY_PROP_3 type,
	       case 
	       		when t.display_name like 'P%' then '1PRD'
	       		when t.display_name like 'Q%' then '3QUA'
	       		when t.display_name like 'D%' then '5DSV'
	       		when t.display_name like 'SP%' or t.display_name like 'S1%' or t.display_name like 'S2%' then '2PRD_DG'
	       		when t.display_name like 'SQ%' then '4QUA_DG'
	            when t.display_name = 'RFU' or t.display_name = 'TCLY1' or t.display_name = 'TTIB' then '5DSV'
	       		when t.display_name = 'CVUC' then '6POC'
	       		else 'MISC'
	       	end environment,
	       case
	       		when max(g.composite_target_name) like '%ESI%' then 'NBSI'
	       		when max(g.composite_target_name) like '%IBM%' then 'IBM'
	       		else 'CLOUD'
	       end target_group
	FROM sysman.mgmt_targets@DBL_POEM2 t,
	     SYSMAN.MGMT$GROUP_DERIVED_MEMBERSHIPS@DBL_POEM2 g
	WHERE t.target_type IN ('rac_database',
	                        'oracle_database')
	  AND t.target_type=g.member_target_type(+)
	  AND t.target_name=g.member_target_name(+)
	  AND (g.composite_target_name LIKE ('ESI%')
	       OR g.composite_target_name LIKE ('IBM%'))
	GROUP BY t.host_name,
	         t.display_name,
	         t.type_display_name,
             t.CATEGORY_PROP_1,
             t.CATEGORY_PROP_3
ORDER BY 6,2,1
)