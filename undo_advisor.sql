DECLARE
 prob VARCHAR2(100);
 reco VARCHAR2(100);
 rtnl VARCHAR2(100);
 retn PLS_INTEGER;
 utbs PLS_INTEGER;
 retv PLS_INTEGER;
BEGIN
  retv := dbms_undo_adv.undo_health(prob, reco, rtnl, retn, utbs);
  dbms_output.put_line('Problem: ' || prob);
  dbms_output.put_line('Recmmnd: ' || reco);
  dbms_output.put_line('Rationl: ' || rtnl);
  dbms_output.put_line('Retentn: ' || TO_CHAR(retn));
  dbms_output.put_line('UTBSize: ' || TO_CHAR(utbs));
END;
/