set serveroutput on

DECLARE
     CURSOR rowid_duplicados IS 
        select rowid
	from t_subopr
	where operacao = 'O'
	 and sub_operacao = 38
	 and rowid not in
	(SELECT MIN(rowid)
	 FROM t_subopr
	 where operacao = 'O'
	 and sub_operacao = 38
	 GROUP BY 
	 operacao,38,'Acções Portabilidade Voip Nómada',linha_rede,equip,ensaio,app_valid,dist_accao ,rec_equip,rec_relat,predist,mostra_int_act,ens_dist,
               predist_dist,op_cae,anot_predist,react_int,conv_sap,rotina,
               cco,def_acl,data_obj,baixa_distr,n_equipas,estado_redist,deb_cli,
               desloc,valor,eq_instal,ordem_act, baixa_provisoria,est_ant_ag,hor_ant_ag,
               obs_obrig_baixa,cod_deb,check_ot,check_ot_j,check_ot_c,check_anota,check_baix,
               check_baix_equipa,check_baix_prov,op_red_cons,atende_on_line,msg_ens_gerex,
               msg_pre_distr,excel_oper,tip_equipa,rec_tarefa,acesso_artt,rec_prdsrv,rec_ot_auto,
               ponto_ava,dist_aut,rec_teste,tempo_obj_util,atende_on_line_rr,fecho_aut,oper_ivr
	);
	
	v_count number :=0; 
BEGIN
   dbms_output.enable(10000);
   v_count :=0; 
   FOR rowid_d IN rowid_duplicados
   LOOP
      v_count := v_count + 1;
      insert into t_subopr_bck
      select * from t_subopr 
      where rowid=rowid_d.rowid;
      
      delete from  t_subopr 
      where rowid=rowid_d.rowid;
      
      IF MOD( v_count, 100)=0 then 
      	dbms_output.put_line('LOOP registos eliminados da tabela t_subopr:'||v_count);
      	COMMIT;
      end if;      	
   END LOOP;
   dbms_output.put_line('Total de registos eliminados da tabela t_subopr:'||v_count);
   COMMIT;
END;
/
