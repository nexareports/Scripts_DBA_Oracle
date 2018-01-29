set timing on
--914340615
Declare
P_NUM_    VARCHAR2(1000) ;
ROW_ID_   VARCHAR2(1000) ;
CON_ID_   VARCHAR2(1000) ;
FST_NAME_ VARCHAR2(1000) ;
LAST_NAME_ VARCHAR2(1000) ;
CLNT_ID_  VARCHAR2(1000) ;
CLNT_NUM_ VARCHAR2(1000) ;
ACCNT_ID_ VARCHAR2(1000) ;
ACCNT_NUM_ VARCHAR2(1000) ;
CLNT_CLSS_ VARCHAR2(1000) ;
CLNT_VL_  VARCHAR2(1000) ;
ACCNT_LVL_ VARCHAR2(1000) ;
begin
P_NUM_:='914340615';
M_PROC_2(P_NUM_,ROW_ID_,CON_ID_,FST_NAME_,LAST_NAME_,CLNT_ID_,CLNT_NUM_,ACCNT_ID_,ACCNT_NUM_,CLNT_CLSS_,CLNT_VL_,ACCNT_LVL_);
dbms_output.put_line(P_NUM_);
dbms_output.put_line(ROW_ID_);
dbms_output.put_line(CON_ID_);
dbms_output.put_line(FST_NAME_);
dbms_output.put_line(LAST_NAME_);
dbms_output.put_line(CLNT_ID_);
dbms_output.put_line(CLNT_NUM_);
dbms_output.put_line(ACCNT_ID_);
dbms_output.put_line(ACCNT_NUM_);
dbms_output.put_line(CLNT_CLSS_);
dbms_output.put_line(CLNT_VL_);
dbms_output.put_line(ACCNT_LVL_);
end;
/

set timing off