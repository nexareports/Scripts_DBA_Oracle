alter session set nls_date_format='DD-MM-YYYY HH24:MI'
/

drop table tb_load_profile_&1;

create table tb_load_profile_&1(
 bsnap          number not null,
 esnap          number not null,
 btime          date   not null,
 etime          date   not null,
 redo_size      number,
 logical_reads  number, 
 physical_reads number,
 block_changes  number,
 physical_wrts  number,
 user_calls     number,
 parses         number,
 hard_parses    number,
 sorts          number,
 logons         number,
 executes       number, 
 transactions   number,
 fl_tipo        varchar2(1 byte) not null,
 startup_time date,
    constraint pk_coleta_perfil_&1 primary key(bsnap, esnap, btime, etime, 
fl_tipo)
    using index
    storage ( initial 64k next 64k minextents 1 maxextents 250 
pctincrease 0 freelists 1 freelist groups 1)
    pctfree 10 initrans 2 maxtrans 255)
    pctfree 10 pctused 40 initrans 1
    maxtrans 255 
    storage ( initial 256k next 128k minextents 1 maxextents 250 
pctincrease 0 freelists 1 freelist groups 1)
    nologging
/

prompt Gerando os dados na tabela TB_LOAD_PROFILE_&1

declare 
    --valores obtidos no cursor cr_dados_banco
    v_dbid            number;
    v_instance_number number; 
    v_db_name         varchar2(9);
    v_instance_name   varchar2(16);
    v_host_name       varchar2(64);
    -- variveis necessárias para rodar procedure stats_change(retornam valores).
    lhtr   number; 
    bfwt   number;
    tran   number;
    chng   number;
    ucal   number;
    urol   number;
    ucom   number;
    rsiz   number;
    phyr   number;
    phyrd  number;
    phyrdl number;
    phyw   number;
    prse   number;
    hprs   number;
    recr   number;
    gets   number;
    rlsr   number;
    rent   number;
    srtm   number;
    srtd   number;
    srtr   number;
    strn   number; 
    call   number;
    lhr    number;
    sp     varchar2(512);
    bc     varchar2(512);
    lb     varchar2(512);
    bs     varchar2(512);
    twt    number;
    logc   number;
    prscpu number; 
    prsela number;
    tcpu   number;
    exe    number;
    bspm   number;
    espm   number;
    bfrm   number;
    efrm   number;
    blog   number;
    elog   number;
    bocur  number;
    eocur  number;
    dmsd   number;
    dmfc   number;
    dmsi   number;
    pmrv   number;
    pmpt   number;
    npmrv   number;
    npmpt   number;
    dbfr   number;
    dpms   number;
    dnpms   number; 
    glsg   number;
    glag   number;
    glgt   number;
    glsc   number;
    glac   number;
    glct   number;
    glrl   number;
    gcdfr  number;
    gcge   number;
    gcgt   number;
    gccv   number;
    gcct   number;
    gccrrv   number;
    gccrrt   number;
    gccurv   number;
    gccurt   number;
    gccrsv   number;
    gccrbt   number;
    gccrft   number;
    gccrst   number; 
    gccusv   number;
    gccupt   number;
    gccuft   number;
    gccust   number;
    msgsq    number;
    msgsqt   number;
    msgsqk   number;
    msgsqtk  number;
    msgrq    number;
    msgrqt   number; 

    -- cursor cr_dados obtem as informações do bancod e dados corrente.

     cursor cr_dados_banco is
      select distinct dbid, instance_number, db_name, instance_name, host_name
        from stats$database_instance;

     st_dados_banco cr_dados_banco%rowtype;

     -- cursor cr_snapshot obtem os snapshots e o tempo de duração do snapshot
     -- de uma mesma instancia em atividade.
     cursor cr_snapshot(pnm_dbid in number, pnm_instance_number in number) is
      select t.snap_id,t.snap_posterior,round(((e.snap_time - b.snap_time) * 1440 * 60), 0) ela,
             b.snap_time as snap_time_ini, e.snap_time as snap_time_fim,b.startup_time
        from stats$snapshot b
           , stats$snapshot e 
           , (select * from (
      select s.snap_id                                         snap_id
           , lead(s.snap_id,1) over (partition by s.startup_time order by s.snap_id) snap_posterior
        from stats$snapshot s 
           , stats$database_instance di
       where s.dbid              = pnm_dbid
         and di.dbid             = pnm_dbid
         and s.instance_number   = pnm_instance_number
         and di.instance_number   = pnm_instance_number
         and di.dbid             = s.dbid
         and di.instance_number  = s.instance_number
         and di.startup_time     = s.startup_time
       order by db_name, instance_name, snap_id) 
       where snap_posterior is not null) t
       where b.snap_id         = t.snap_id
         and e.snap_id         = t.snap_posterior
         and b.dbid            = pnm_dbid
         and e.dbid            = pnm_dbid 
         and b.instance_number = pnm_instance_number
         and e.instance_number = pnm_instance_number
         and b.startup_time    = e.startup_time
         and b.snap_time       < e.snap_time
         and b.snap_time>='&2'
         and e.snap_time<='&3';

    begin
      open cr_dados_banco;
        fetch cr_dados_banco into st_dados_banco;
        if cr_dados_banco%found then
           v_dbid:= st_dados_banco.dbid;
           v_instance_number:= st_dados_banco.instance_number; 
           v_db_name:= st_dados_banco.db_name;
           v_instance_name:= st_dados_banco.instance_name;
           v_host_name:= st_dados_banco.host_name;
        end if;
      close cr_dados_banco;

      for st_dados in cr_snapshot(v_dbid,v_instance_number) loop
        statspack.stat_changes
          ( st_dados.snap_id,st_dados.snap_posterior
          , v_dbid, v_instance_number
          , 'no'                 -- end of in arguments 
          , lhtr,   bfwt
          , tran,   chng
          , ucal,   urol
          , rsiz
          , phyr,   phyrd
          , phyrdl
          , phyw,   ucom
          , prse,   hprs
          , recr,   gets 
          , rlsr,   rent
          , srtm,   srtd
          , srtr,   strn
          , lhr,    bc
          , sp,     lb
          , bs,     twt
          , logc,   prscpu
          , tcpu,   exe
          , prsela
          , bspm,   espm
          , bfrm,   efrm
          , blog,   elog
          , bocur,  eocur
          , dmsd,   dmfc    -- begin of rac
          , dmsi
          , pmrv,   pmpt 
          , npmrv,  npmpt
          , dbfr
          , dpms,   dnpms
          , glsg,   glag
          , glgt,   glsc
          , glac,   glct
          , glrl,   gcdfr
          , gcge,   gcgt
          , gccv,   gcct
          , gccrrv, gccrrt
          , gccurv, gccurt
          , gccrsv
          , gccrbt, gccrft
          , gccrst, gccusv
          , gccupt, gccuft
          , gccust
          , msgsq,  msgsqt
          , msgsqk, msgsqtk
          , msgrq,  msgrqt           -- end rac
          );
          --call = ucal + recr;

       /* inserindo os valores por segundo - fl_tipo='s' */
       insert into tb_load_profile_&1(bsnap
       ,esnap
       ,btime
       ,etime
                                   ,redo_size
       ,logical_reads 
       ,block_changes
       ,physical_reads
       ,physical_wrts
                                   ,user_calls
       ,parses
       ,hard_parses
       ,sorts
                                   ,logons 
        ,executes
       ,transactions
       ,fl_tipo
       ,startup_time)
                            values (st_dados.snap_id
       ,st_dados.snap_posterior
       ,st_dados.snap_time_ini
       ,st_dados.snap_time_fim 
       ,round(rsiz/st_dados.ela,2)
        ,round(gets/st_dados.ela,2)
       ,round(chng/st_dados.ela,2)
       ,round(phyr/st_dados.ela,2)
       ,round(phyw/st_dados.ela,2)
                                   ,round(ucal/st_dados.ela,2) 
          ,round(prse/st_dados.ela,2)
       ,round(hprs/st_dados.ela,2)
       ,round((srtm+srtd)/st_dados.ela,2)
                                   ,round(logc/st_dados.ela,2)
       ,round(exe/st_dados.ela,2) 
       ,round(tran/st_dados.ela,2)
       ,'s'
       ,st_dados.startup_time);

       /* inserindo os valores por transação - fl_tipo='t' */
       insert into tb_load_profile_&1(bsnap,esnap,btime,etime,redo_size,logical_reads,block_changes,physical_reads,
                                    physical_wrts,user_calls,parses,hard_parses,sorts,logons,executes,fl_tipo,startup_time) 
                            values (st_dados.snap_id,st_dados.snap_posterior,st_dados.snap_time_ini,st_dados.snap_time_fim
                                   ,round(rsiz/tran,2),round(gets/tran,2),round(chng/tran,2),round(phyr/tran,2) 
                                   ,round(phyw/tran,2),round(ucal/tran,2),round(prse/tran,2),round(hprs/tran,2)
                                   ,round((srtm+srtd)/tran,2),round(logc/tran,2),round(exe/tran,2),'t',st_dados.startup_time); 
      end loop;
  end;
/

commit;

Prompt ===================================================================
Prompt Os dados na tabela TB_LOAD_PROFILE_&1 foram gerados com sucesso
Prompt ===================================================================
Prompt Para selecionar os dados: Select * from TB_LOAD_PROFILE_&1;
Prompt ===================================================================
Prompt Nesta tabela, contém dados de &2 e &3
Prompt ===================================================================
Prompt Outros Selects:
Prompt ===================================================================
Prompt @perf_transactions_load_profile TB_LOAD_PROFILE_&1 <MES> <ANO> <Ficheiro a ser gerado>
Prompt @perf_executions_load_profile TB_LOAD_PROFILE_&1 <MES> <ANO> <Ficheiro a ser gerado>

