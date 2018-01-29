/* Formatted on 2012-07-26 16:28:12 (QP5 v5.115.810.9015) */
CREATE OR REPLACE PROCEDURE SSIADM.ON_OFF_BACKUPS_EXCPT_INDICADO (
   BDS       VARCHAR2,                   --NOME DA BD IDENTIFICADA NO JOB_NAME
   TIPOS     VARCHAR2,         --STRING DE IDENTIFICACAO DO JOB_NAME A EXCLUIR
   ON_OFF    VARCHAR2
--STRING BOOLEANA IDENTIFICADORA DA ACCAO: ON -> ACTIVA TODOS OS BACKUPS EXCEPTO O INDICADO EM "TIPO"
-- OFF -> SUSPENDE TODOS OS BACKUPS EXCEPTO O INDICADO EM "TIPO"
)
IS
BEGIN
   FOR jguid
   IN (SELECT   j.job_id,
                job_name,
                job_status,
                DECODE (status,
                        1, 'SCHEDULED',
                        2, 'RUNNING',
                        3, 'FAILED INIT',
                        4, 'FAILED',
                        5, 'SUCCEEDED',
                        6, 'SUSPENDED',
                        7, 'AGENT DOWN',
                        8, 'STOPPED',
                        9, 'SUSPENDED/LOCK',
                        10, 'SUSPENDED/EVENT',
                        11, 'SUSPENDED/BLACKOUT',
                        12, 'STOP PENDING',
                        13, 'SUSPEND PENDING',
                        14, 'INACTIVE',
                        15, 'QUEUED',
                        16, 'FAILED/RETRIED',
                        17, 'WAITING',
                        18, 'SKIPPED',
                        s.status)
                   "STATUS"
         FROM   mgmt_job j, MGMT_JOB_EXEC_SUMMARY s
        WHERE       job_name LIKE '%RMAN%'
                AND job_owner = 'SYSMAN'
                AND parent_job_id IS NULL
                AND job_name LIKE '%' || BDS || '%'
                AND job_name NOT LIKE '%' || TIPOS || '%'
                AND J.job_id = S.job_id
                AND J.JOB_STATUS IN (0, 1)           --job activo ou suspended
                AND s.status IN (1, 2, 6)  --agendado, em execucao ou suspenso
                                         )
   LOOP
      BEGIN
         IF (ON_OFF = 'ON') -- ACTIVA TODOS OS BACKUPS NAO INDICADOS EM "TIPO"
         THEN
            --mgmt_job_engine.suspend_job(jguid.job_id);
            mgmt_job_engine.resume_job (jguid.job_id);
            DBMS_OUTPUT.put_line (
               jguid.job_id || ' -- ON -> ' || jguid.job_name
            );
         ELSE             -- SUSPENDE TODOS OS BACKUPS NAO INDICADOS EM "TIPO"
            mgmt_job_engine.suspend_job (jguid.job_id);
            --mgmt_job_engine.resume_job (jguid.job_id);
            DBMS_OUTPUT.put_line (
               jguid.job_id || ' -- OFF -> ' || jguid.job_name
            );
         END IF;
      END;
   END LOOP;

   COMMIT;
END;
/