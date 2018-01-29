set pagesize 1000

SELECT 'ALTER '||                                                         
       DECODE(OBJECT_TYPE,'PACKAGE BODY',' PACKAGE ',OBJECT_TYPE)||       
       ' '||                                                              
       OBJECT_NAME||                                                      
       ' '||                                                              
       DECODE(OBJECT_TYPE,'PACKAGE BODY',' COMPILE BODY ;','COMPILE ;')   
FROM USER_OBJECTS                                                         
WHERE  STATUS = 'INVALID'                                                 
ORDER  BY OBJECT_TYPE,OBJECT_TYPE ; 