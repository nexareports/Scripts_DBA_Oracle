CREATE OR REPLACE PROCEDURE COMPILE_USER_OBJECTS
AS

CURSOR c1 IS
    SELECT  DECODE(OBJECT_TYPE,'PACKAGE BODY',' PACKAGE ',OBJECT_TYPE) cTYPE,
        OBJECT_NAME cOBJECT_NAME,
        DECODE(OBJECT_TYPE,'PACKAGE BODY',' COMPILE BODY',' COMPILE') cCOMP
    FROM USER_OBJECTS
    WHERE  STATUS = 'INVALID'
    ORDER  BY OBJECT_TYPE,OBJECT_NAME ;

v_calter     VARCHAR(6)    :='ALTER ';    -- String 'ALTER '
v_ctype     VARCHAR(20)    :='';        -- Tipo do objecto a compilar
v_cobject     VARCHAR(100)    :='';        -- Nome do objecto a compilar
v_ccomp     VARCHAR(20)    :='';        -- Tipo de compilação
v_cspace    VARCHAR(2)    :=' ';        -- Caracter de espaço
v_count        INT        :=1;        -- Contador do Num de LOOPS
v_MAX_X_COMP     INT        :=5;        -- Numero de LOOPS a executar
v_obj_comp    INT        :=0;        -- Contador do numero de objectos compilados num LOOP

BEGIN

  LOOP
     v_obj_comp:=0;        -- reinicia a variavel

     FOR c01 IN c1
     LOOP
         v_ctype    :=c01.cTYPE;
         v_cobject:=c01.cOBJECT_NAME;
         v_ccomp    :=c01.cCOMP;

         -- dbms_output.put_line(v_calter||v_ctype||v_cspace||v_cobject||v_ccomp||';');

         BEGIN
             v_obj_comp:=v_obj_comp+1;
             EXECUTE IMMEDIATE v_calter||v_ctype||v_cspace||v_cobject||v_ccomp;
             EXCEPTION
                 WHEN OTHERS THEN NULL;
         END;

    END LOOP;

    dbms_output.put_line(' ');
    dbms_output.put_line('#### #### '||v_count||'º LOOP foram compilados '||v_obj_comp||' OBJECTOS INVALIDOS #### ####');

    IF MOD(v_count,v_MAX_X_COMP) = 0  THEN
        dbms_output.put_line('#### #### Após '||v_count||' compilações ficaram '||v_obj_comp||' OBJECTOS INVALIDOS #### ####');
        EXIT;
    END IF;

    v_count:=v_count+1;

  END LOOP;
END;
/
