ALTER SESSION FORCE PARALLEL DML;
set timing on;


truncate table csaadm.NXPP_CSA_COMM_LINES_HIST;

declare
  TYPE MYARRAY IS TABLE OF csaadm.NXPP_CSA_COMM_LINES_HIST%ROWTYPE;
  l_data MYARRAY;

  CURSOR cur_data IS
     select /*+ PARALLEL(b, 15) */ *
     from A2I3994.NXPP_CSA_COMM_LINES_HIST b;

BEGIN
    OPEN cur_data;
    LOOP
       FETCH cur_data BULK COLLECT INTO l_data LIMIT 100000;

       FORALL i IN 1..l_data.COUNT
        INSERT INTO csaadm.NXPP_CSA_COMM_LINES_HIST VALUES l_data(i);

       commit;
       EXIT WHEN cur_data%NOTFOUND;
    END LOOP;
    CLOSE cur_data;
    commit;
END;
/
