--set serveroutput on SIZE 1000000
clear screen;
--@__conf
--set feedback off
variable Opc Number;

--show user
--set head off
--Select 'BD: '||instance_name from v$instance
/
--set head on

Declare
Begin
	dbms_output.put_line('menu-v3.0------------------------------------------------------------m-0-4-M---b-r');
	dbms_output.put_line(SYSDATE);
	dbms_output.put_line('----------------------------------------------------------------------------------');
	dbms_output.put_line('1) Sessions / Activities');
	dbms_output.put_line('2) ASH / ADDM / AWR');
	dbms_output.put_line('3) Events/Latches/Hit ratios');
	dbms_output.put_line('4) Armazenamento/Datafiles');
	dbms_output.put_line('5) Objetos');
	dbms_output.put_line('6) Rman');	
	dbms_output.put_line('7) Informacoes / Parametros / Panorama');	
	dbms_output.put_line('8) Queries ao Dicionario do Cloud Control');
	dbms_output.put_line('----------------------------------------------------------------------------------');
	dbms_output.put_line('@cl - Limpar a tela : @info - Informacoes');
	dbms_output.put_line('@dic - Dicionario de Dados');
	dbms_output.put_line('@__alter - Alterar parametros de sessao');
	dbms_output.put_line('----------------------------------------------------------------------------------');
	dbms_output.put_line('@log_start e @log_stop Iniciar e Parar o Logging');
	dbms_output.put_line('----------------------------------------------------------------------------------');
End;
/

Declare
	Opc2 number;
Begin
	Opc2:=&Opcao;
	:Opc:=Opc2;
End;
/

clear screen;

Declare
	Opc number;
Begin

	Opc:=:Opc;
	If Opc=0 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('0 - Scripts 10g');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@10g_alertas');
		dbms_output.put_line('@10g_feature_usage');
		dbms_output.put_line('@10g_lock_tree');
		dbms_output.put_line('@10g_query_advisor');
		dbms_output.put_line('@10g_seg_advisor');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc=1 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('1 - Sessions / Activities');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@alertlog             {trunc(sysdate)}');
		dbms_output.put_line('@addm_last_hour       [Ver Advisors da ultima hora]');
		dbms_output.put_line('@dba_hist_snapshot    [Visualizar ultimos snapshots]');
		dbms_output.put_line('@awr_snap             [Criar Snapshot]');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@runa                 [Ver Sessoes Ativas] - @runi para sessoes inativas');
		dbms_output.put_line('@runa_sql             [Ver Statements Ativas]');
		dbms_output.put_line('@jobsrun				[Ver os jobs q estao a correr]');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@sql_monitor_runa     [Ver Statements Ativas]');
		dbms_output.put_line('@sql_monitor_error    [Ver que abortaram]');
		dbms_output.put_line('@sqltext              {sql_id} - [Ver Statement, utilizar @sqlfulltext para ver formatado] ');
		dbms_output.put_line('@sql_hints sqlid      {sql_id} - [Ver Hints utilizadas em uma query]');
		dbms_output.put_line('@sql_plan_memory      {sql_id plan_hash_value} [@sql_plan_memory para ver na DBA_HIST_SQLPLAN]');
		dbms_output.put_line('@sql_bind				{sql_id} - [Ver valores para as BIND Variables]');
		dbms_output.put_line('@sql_planos			{sql_id} - [Ver os varios planos de execucoes]');
		dbms_output.put_line('@reading              [Ver o que estas sessoes estao a ler]');
		dbms_output.put_line('@query_advisor		[Gerar o Advisor para a query]');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@load                 [Ver Load do dia commits, execs, os load e etc]');
		dbms_output.put_line('@load_schema			[Ver a carga gerada por schema]');
		dbms_output.put_line('@load_module          [Ver a carga gerada por modulo]');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@lock					[Ver locks na Base de Dados]');
		dbms_output.put_line('@lock_latch			[Ver os latches e Locks]');
		dbms_output.put_line('@locks_dml_ddl		[Ver os locks por DDL/DML');
		dbms_output.put_line('@latch_free			[Ver os latches]');
		dbms_output.put_line('@latch_report         [Gerar Report sobre os latches]');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');		
		dbms_output.put_line('@trx_ativas		');
		dbms_output.put_line('@trx_progress		');
		dbms_output.put_line('@rollback_progress');
		dbms_output.put_line('@rollback_contention');
		dbms_output.put_line('@rollback_users');
		dbms_output.put_line('@rmv_transac_2pc      [Remover transacoes distribuidas - 2PC]');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@runtopaas            {aas:<refresh rate>} - [Grafico AAS]');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@sid                  {sid serial#} - [Ver informacaoes da sessao, @sid2 para ver mais detalhes]');
		dbms_output.put_line('@');
		dbms_output.put_line('@');
		dbms_output.put_line('@');
		dbms_output.put_line('@');
		dbms_output.put_line('@');
		dbms_output.put_line('@');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc=2 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('2 - Armazenamento/Datafiles');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('	@allfiles');		
		dbms_output.put_line('	@datafile_por_tbs');		
		dbms_output.put_line('	@pctfreetbs				');
		dbms_output.put_line('FRAGMENTACAO/HWM');		
		dbms_output.put_line('	@chained_rows');		
		dbms_output.put_line('	@verfrag		');		
		dbms_output.put_line('	@hwm');		
		dbms_output.put_line('	@hwm_tbs');	
		dbms_output.put_line('	@ts_extent_map');			
		dbms_output.put_line('REDO LOG / ARCHIVE');
		dbms_output.put_line('	@redo_log_contention');
		dbms_output.put_line('	@avg_switch_logs');
		dbms_output.put_line('TEMP');		
		dbms_output.put_line('	@temp_sort_segment');		
		dbms_output.put_line('	@temp_sort_users');		
		dbms_output.put_line('	@temp_status');		
		dbms_output.put_line('	@space_temp');		
		dbms_output.put_line('UNDO / RBS');		
		dbms_output.put_line('	@rbs_stats');		
		dbms_output.put_line('	@UndoConfig');		
		dbms_output.put_line('	@UndoExtents');		
		dbms_output.put_line('	@UndoHealthCheck');		
		dbms_output.put_line('	@Undo_Activity');		
		dbms_output.put_line('	@Undo_Transactions');		
		dbms_output.put_line('	@unused_space');		
		dbms_output.put_line('PERFORMANCE');				
		dbms_output.put_line('	@datafile_read_time');	
		dbms_output.put_line('	@qtd_row_per_file');				
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc=3 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('3 - ASM');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@asm_diskgroups');
		dbms_output.put_line('@asm_disks');
		dbms_output.put_line('@asm_disks_perf');
		dbms_output.put_line('@asm_drop_files');
		dbms_output.put_line('@asm_files2');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc=4 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('4 - Events/Locks/Latches/Hit ratios');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('	@ratios');
		dbms_output.put_line('	@SessionWaits');
		dbms_output.put_line('	@response_time_breakdown');
		dbms_output.put_line('	@db_block_efficiency');
		dbms_output.put_line('	@e_tx');
		dbms_output.put_line('	@event_impact');
		dbms_output.put_line('LATCHES');
		dbms_output.put_line('	@latch_hold');
		dbms_output.put_line('	@latch_report');
		dbms_output.put_line('	@top_latches');
		dbms_output.put_line('LOCKS');
		dbms_output.put_line('	@hold_locks');
		dbms_output.put_line('	@lock');
		dbms_output.put_line('	@locks_dml_ddl');
		dbms_output.put_line('	@lock_completo');
		dbms_output.put_line('	@lock_latch');
		dbms_output.put_line('	@lock_rac');
		dbms_output.put_line('HOT BLOCKS');
		dbms_output.put_line('	@hotblocks');
		dbms_output.put_line('	@blocks_in_wait');
		dbms_output.put_line('	@block_discover');
		dbms_output.put_line('	@cache_buffer_chains');	
		dbms_output.put_line('	@what_block_in_wait');		
		dbms_output.put_line('	@top_block_wait');
		dbms_output.put_line('	@top_block_wait2');					
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc=5 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('5 - Sessões / Aividades');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('SESSOES');
		dbms_output.put_line('	@top_sessions');
		dbms_output.put_line('	@sessions_ratio');
		dbms_output.put_line('	@session_group_info');
		dbms_output.put_line('	@sessoes_events_waits');
		dbms_output.put_line('	@sess_users_by_cpu');
		dbms_output.put_line('	@sess_users_by_io');
		dbms_output.put_line('	@sess_users_by_memory');
		dbms_output.put_line('	@sess_users_by_transactions');
		dbms_output.put_line('	@sid');
		dbms_output.put_line('	@spid');
		dbms_output.put_line('SESSOES');
		dbms_output.put_line('	@sqlhash_groups');
		dbms_output.put_line('	@sqlrun');
		dbms_output.put_line('	@sqltext');
		dbms_output.put_line('	@topsql');
		dbms_output.put_line('	@opencursor');
		dbms_output.put_line('	@topsessionsinativas');
		dbms_output.put_line('	@top_users_buffer_gets');
		dbms_output.put_line('	@workarea - VER PGA');
		dbms_output.put_line('RUNING');
		dbms_output.put_line('	@run');
		dbms_output.put_line('	@runA');
		dbms_output.put_line('	@runI');
		dbms_output.put_line('	@transac_ativas');		
		dbms_output.put_line('	@checkpoint_progress');
		dbms_output.put_line('	@longops');
		dbms_output.put_line('	@jobsrun');
		dbms_output.put_line('	@top_tables');
		dbms_output.put_line('	@vbh');
		dbms_output.put_line('RBS / UNDO SEGMENTS');
		dbms_output.put_line('	@rollback_contention');
		dbms_output.put_line('	@rollback_segments');
		dbms_output.put_line('	@rollback_users');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');	
	End;
	End if;
	If Opc=6 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('6 - Consulta Perfstat');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@statspack_perf_topsql - VER TOP SQLS [DATA1 HORA1 DATA2 HORA2]');
		dbms_output.put_line('@statspack_perf_med_users_mes - VER QTD DE USERS POR HORAxDATA [MES ANO]');
		dbms_output.put_line('--------------------------------------------------------------------');
		dbms_output.put_line('Coleta Perfil:');
		dbms_output.put_line('--------------------------------------------------------------------');
		dbms_output.put_line('@statspack_perf_coleta_perfil - COLETAR LOAD PROFILE DETERMINADO TEMPO');
		dbms_output.put_line('_________[COMPLEMENTO TBL, DATA_INICIO e DATA_FIM]');
		dbms_output.put_line('--------------------------------------------------------------------');
		dbms_output.put_line('OS Scripts abaixo dependem de uma Tabela de Coleta de Perfil gerada:');
		dbms_output.put_line('--------------------------------------------------------------------');
		dbms_output.put_line('@statspack_perf_consulta_tab_coleta - CONSULTAR TODAS AS TBL LOAD PROFILE EXISTENTES');
		dbms_output.put_line('Parametros a serem usados pelas queries abaixo:');
		dbms_output.put_line('--------------------------------------------------------------------');
		dbms_output.put_line('_________[TB_LOAD_PROFILE_<COMPLEMENTO> <MES> <ANO> <Ficheiro a ser gerado>]');
		dbms_output.put_line('@statspack_perf_transactions_load_profile - CONSULTAR DADOS DE TRANSACOES POR SEGUNDO');
		dbms_output.put_line('@statspack_perf_executes_load_profile - CONSULTAR DADOS DE EXECUTIONS POR SEGUNDO');
		dbms_output.put_line('@statspack_perf_ph_wrts_load_profile - CONSULTAR DADOS DE ESCRITAS FISICAS');
		dbms_output.put_line('@statspack_perf_pct_physical_reads_load_profile - PERCENTUAL DE LEITURAS FISICAS');
		dbms_output.put_line('@statspack_perf_pct_hard_parses_load_profile - PERCENTUAL DE HARD PARSES');
		dbms_output.put_line('@statspack_perf_parses_load_profile - CONSULTA DE PARSES');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc=7 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('7 - Consulta AWR');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');

		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc=8 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('8 Queries ao Dicionario do Cloud Control');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@oem_search_user     {username} [Procurar por um user nos targets do OEM]');
		dbms_output.put_line('@oem_objinv          [Lista todos os objetos invalidos]');
		dbms_output.put_line('@oem_objinv          {DB Name} [Lista os objetos invalidos por BD]');
		dbms_output.put_line('@oem_param           {Parametro} [Lista os valores por parametro e por BD]');
		dbms_output.put_line('@oem_param           {DB Name}   [Lista os parametros de uma BD]');
		dbms_output.put_line('@oem_db_list         [Lista das bases de dados registado no Cloud Control]');
		dbms_output.put_line('@oem_db_space        [Espaco por Base de Dados]');
		dbms_output.put_line('');
		dbms_output.put_line('');
		dbms_output.put_line('');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc=9 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('9 - Rman');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@ver_backups');
		dbms_output.put_line('@rman_backup_sets');
		dbms_output.put_line('@rman_configuration');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc=10 then
	Begin
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('10 - Informacoes / Parametros / Panorama');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
		dbms_output.put_line('@cbo_stats_table');
		dbms_output.put_line('@CursorEfficiency');
		dbms_output.put_line('@grants');
		dbms_output.put_line('@map_sga');
		dbms_output.put_line('@mts');
		dbms_output.put_line('@parameters');
		dbms_output.put_line('@parameters_difdefault');
		dbms_output.put_line('@performance_snapshot');
		dbms_output.put_line('@report_db10g');
		dbms_output.put_line('@report_db9i');
		dbms_output.put_line('@rmv_transac_2pc');
		dbms_output.put_line('@sort_area_size');
		dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------');
	End;
	End if;
	If Opc > 10 and Opc <0 Then
		dbms_output.put_line('Opção errada');
	End if;
End;
/

--set feedback on
