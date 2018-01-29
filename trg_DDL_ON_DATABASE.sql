CREATE TABLE SYSTEM.DDL_LOG
(
  USER_NAME    VARCHAR2(50 BYTE),
  DDL_DATE     DATE,
  DDL_TYPE     VARCHAR2(50 BYTE),
  OBJECT_TYPE  VARCHAR2(50 BYTE),
  OWNER        VARCHAR2(50 BYTE),
  OBJECT_NAME  VARCHAR2(250 BYTE),
  OSUSER       VARCHAR2(250 BYTE),
  TERMINAL     VARCHAR2(250 BYTE),
  HOST         VARCHAR2(250 BYTE)
)
TABLESPACE USERS;

CREATE OR REPLACE TRIGGER SYS.ddl_trig
AFTER DDL
ON DATABASE
BEGIN
  INSERT INTO SYSTEM.ddl_log
  (user_name, ddl_date, ddl_type,
   object_type, owner,
   object_name,osuser,terminal,host)
  VALUES
  (ora_login_user, SYSDATE, ora_sysevent,
   ora_dict_obj_type, ora_dict_obj_owner,
   ora_dict_obj_name,sys_context('USERENV','OS_USER'),sys_context('USERENV','TERMINAL'),sys_context('USERENV','HOST'));
END ddl_trig;
/