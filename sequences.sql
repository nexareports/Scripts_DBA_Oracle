set long 2000000 set longchunksize 2000000


--This line add a semicolon at the end of each statement
execute dbms_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',true);

 SELECT DBMS_METADATA.GET_DDL( replace(object_type,' ','_'), object_name, owner) 
  FROM dba_objects 
 WHERE object_type in ('SEQUENCE')
   AND owner in ('PPAGO');
