DECLARE
  v_osuserid  VARCHAR2(30);
  v_sid       NUMBER(10);
  v_serial    NUMBER(10);
  v_omode     VARCHAR2(15);
  v_program   VARCHAR2(48);
  v_flag      NUMBER(1);
  v_count     NUMBER;
  CURSOR c1 IS
    SELECT sid, serial#, osuser, program FROM v$session WHERE audsid = userenv('sessionid');
  CURSOR c2 IS SELECT open_mode FROM v$database ;
  CURSOR c3 IS SELECT flag FROM esiratrp.sir_activa ;
BEGIN
  v_flag := 1 ;
  OPEN c2;
  FETCH c2 INTO v_omode ;
  IF v_omode = 'READ WRITE' THEN
     OPEN C3;
     FETCH c3 INTO v_flag ;
     IF v_flag = 1 THEN
        OPEN c1;
        FETCH c1 INTO v_sid, v_serial, v_osuserid, v_program ;
        INSERT INTO esiratrp.logon_sirel VALUES ( v_sid, v_serial, sysdate, user, v_osuserid, v_program );
        CLOSE c1;
     ELSE
        SELECT COUNT(1) INTO v_count FROM supgbd.USERS_EXCEPCAO
         WHERE USERNAME=user;
        IF (user <> 'SYS') and (user <> 'SYSTEM') and
           (user not like '%RP') and v_count = 0 THEN
           RAISE_APPLICATION_ERROR(-20001, 'BD indisponivel. Contactar DBA Oracle PTSI.');
           CLOSE C3;
           CLOSE C2;
        END IF;
     END IF;
  CLOSE C3;
  END IF;
  CLOSE C2;
END;