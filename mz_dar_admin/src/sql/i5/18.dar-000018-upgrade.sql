--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE dar_owner.dar_edition_manager 
AUTHID CURRENT_USER
AS

  FUNCTION safeToNumber (pIn VARCHAR2, pReturn NUMBER DEFAULT NULL) RETURN NUMBER;

  PROCEDURE setEdition (pName VARCHAR2, pCreate VARCHAR2 DEFAULT 'TRUE');
  FUNCTION getEdition RETURN VARCHAR2;
  PROCEDURE getEdition;
  FUNCTION getLatestEdition (pAppName VARCHAR2) RETURN VARCHAR2;

  PROCEDURE grantEdition;
  PROCEDURE finaliseEdition;

  PROCEDURE checkForInvalidObjects;
  PROCEDURE checkForXETriggers (pFailOnFound VARCHAR2 DEFAULT 'TRUE');

  PROCEDURE doChunkSQL (pTable VARCHAR2, pChunkSize NUMBER, pParallelLevel NUMBER, pSqlStmt VARCHAR2, pTrigger VARCHAR2);

END dar_edition_manager;
/
--END_PLSQL
--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE BODY dar_owner.dar_edition_manager AS

  -----------------------------------------------------------------------------------------------------------------------------------------
  FUNCTION safeToNumber (pIn VARCHAR2, pReturn NUMBER DEFAULT NULL) RETURN NUMBER IS
  -----------------------------------------------------------------------------------------------------------------------------------------

    invalid_numeric     EXCEPTION;
    PRAGMA EXCEPTION_INIT(invalid_numeric, -6502);

  BEGIN

    RETURN TO_NUMBER(pIn);

  EXCEPTION
    WHEN invalid_numeric THEN
      RETURN pReturn;
  
  -----------------
  END safeToNumber; 
  -----------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE setEdition (pName VARCHAR2, pCreate VARCHAR2 DEFAULT 'TRUE') IS
  -----------------------------------------------------------------------------------------------------------------------------------------
  BEGIN

    IF pCreate = 'TRUE' THEN
      dar_edition_manager_defn.setEdition(pName);

      EXECUTE IMMEDIATE 'ALTER SESSION SET ddl_lock_timeout = 300';
    ELSE
      DBMS_SESSION.SET_EDITION_DEFERRED(pName);
    END IF;

  ---------------
  END setEdition;
  ---------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  FUNCTION getEdition RETURN VARCHAR2 IS
  -----------------------------------------------------------------------------------------------------------------------------------------

    lEdition				    VARCHAR2(200);

  BEGIN

    SELECT SYS_CONTEXT('USERENV', 'SESSION_EDITION_NAME') 
    INTO   lEdition
    FROM   DUAL;

    RETURN lEdition;

  ---------------
  END getEdition;
  ---------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE getEdition IS
  -----------------------------------------------------------------------------------------------------------------------------------------
  BEGIN

    DBMS_OUTPUT.PUT_LINE('Edition: ' || getEdition);

  ---------------
  END getEdition;
  ---------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  FUNCTION getLatestEdition (pAppName VARCHAR2) RETURN VARCHAR2 IS
  -----------------------------------------------------------------------------------------------------------------------------------------

    CURSOR getEdition (cAppName VARCHAR2) IS
    SELECT edition_name
    FROM   all_editions
    WHERE  edition_name LIKE cAppName || '%'
    ORDER BY dar_edition_manager.safeToNumber(SUBSTR(edition_name, INSTR(edition_name, '_', -1) +1), 0) DESC;

    lEdition            VARCHAR2(200);

  BEGIN

    OPEN getEdition (pAppName);
    FETCH getEdition Into lEdition;
    CLOSE getEdition;

    RETURN lEdition;

  ---------------------
  END getLatestEdition;
  ---------------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE grantEdition IS
  -----------------------------------------------------------------------------------------------------------------------------------------
  BEGIN

     finaliseEdition;

  -----------------
  END grantEdition;
  -----------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE finaliseEdition IS
  -----------------------------------------------------------------------------------------------------------------------------------------

    CURSOR getGrantObjects IS
    SELECT object_name
    FROM   user_objects
    WHERE  edition_name IS NOT NULL
    AND    object_type IN ('VIEW');

    CURSOR getSynonymObjects IS
    SELECT object_name
    FROM   user_objects
    WHERE  object_type IN ('TABLE', 'VIEW', 'SEQUENCE', 'FUNCTION', 'TYPE', 'PACKAGE', 'PROCEDURE');

    lApp                VARCHAR2(200) := SUBSTR(USER, 1, INSTR(USER, '_', -1) -1);

  BEGIN

    BEGIN
      EXECUTE IMMEDIATE 'GRANT USE ON EDITION ' || getEdition || ' TO ' || UPPER(lApp) || '_READONLY';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      EXECUTE IMMEDIATE 'GRANT USE ON EDITION ' || getEdition || ' TO ' || UPPER(lApp) || '_UPDATE';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      EXECUTE IMMEDIATE 'GRANT USE ON EDITION ' || getEdition || ' TO ' || UPPER(lApp) || '_EXECUTE';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    FOR getGrantObjectsRec IN getGrantObjects LOOP
      BEGIN
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || getGrantObjectsRec.object_name || ' TO ' || UPPER(lApp) || '_READONLY';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;

      BEGIN
        EXECUTE IMMEDIATE 'GRANT INSERT,UPDATE,DELETE ON ' || getGrantObjectsRec.object_name || ' TO ' || UPPER(lApp) || '_UPDATE';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;

    FOR getSynonymObjectsRec IN getSynonymObjects LOOP
      BEGIN
        EXECUTE IMMEDIATE 'CREATE SYNONYM ' || UPPER(lApp) || '_USER' || '.' || getSynonymObjectsRec.object_name || ' FOR ' || USER || '.' || getSynonymObjectsRec.object_name;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;

  --------------------
  END finaliseEdition;
  --------------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE checkForInvalidObjects IS
  -----------------------------------------------------------------------------------------------------------------------------------------
  
    CURSOR getObjects IS
    SELECT object_name, DECODE(object_type, 'PACKAGE BODY', 'PACKAGE', object_type) AS object_type
    FROM   user_objects
    WHERE  status = 'INVALID';

    TYPE typObjects IS TABLE OF getObjects%ROWTYPE INDEX BY BINARY_INTEGER;

    lObjects            typObjects;

    compilationFailException EXCEPTION;
    PRAGMA EXCEPTION_INIT(compilationFailException, -24344);

  BEGIN
  
    OPEN getObjects;
    FETCH getObjects BULK COLLECT INTO lObjects;
    CLOSE getObjects;

    IF lObjects.COUNT > 0 THEN
      FOR i IN lObjects.FIRST..lObjects.LAST LOOP
        BEGIN
          EXECUTE IMMEDIATE 'ALTER ' || lObjects(i).object_type || ' ' || lObjects(i).object_name || ' COMPILE';
        EXCEPTION 
          WHEN compilationFailException THEN
            RAISE_APPLICATION_ERROR(-20901, 'Object ' || lObjects(i).object_name || ' Failed Compilation and is Invalid.');
        END;
      END LOOP;
    END IF;

  ---------------------------
  END checkForInvalidObjects;
  ---------------------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE checkForXETriggers (pFailOnFound VARCHAR2 DEFAULT 'TRUE') IS
  -----------------------------------------------------------------------------------------------------------------------------------------
  
    CURSOR getObjects IS
    SELECT CASE 
             WHEN REGEXP_LIKE(s.text, 'FORWARD([[:blank:]]+)CROSSEDITION', 'i') THEN
               'Forward'
             WHEN REGEXP_LIKE(s.text, 'REVERSE([[:blank:]]+)CROSSEDITION', 'i') THEN
               'Reverse'
             ELSE
               'Unknown'
           END trigger_type,
           o.object_name,
           o.edition_name
    FROM   user_objects_ae o, user_source_ae s 
    WHERE  o.object_name = s.name 
    AND    o.object_type = 'TRIGGER'
    AND    REGEXP_LIKE(s.text, 'CROSSEDITION', 'i');

    TYPE typObjects IS TABLE OF getObjects%ROWTYPE INDEX BY BINARY_INTEGER;

    lObjects            typObjects;

 BEGIN

    OPEN getObjects;
    FETCH getObjects BULK COLLECT INTO lObjects;
    CLOSE getObjects;

    IF lObjects.COUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE('Crossedition Triggers:');
      FOR i IN lObjects.FIRST..lObjects.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(lObjects(i).trigger_type || ' Trigger ' || lObjects(i).object_name || ' in ' || lObjects(i).edition_name);
      END LOOP;

      IF pFailOnFound = 'TRUE' THEN
        RAISE_APPLICATION_ERROR(-20902, 'ERROR: Crossedition Triggers Exist.');
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('No Crossedition Triggers Found.');
    END IF;

  -----------------------
  END checkForXETriggers;
  -----------------------
 
  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE doChunkSQL (pTable VARCHAR2, pChunkSize NUMBER, pParallelLevel NUMBER, pSqlStmt VARCHAR2, pTrigger VARCHAR2) IS
  -----------------------------------------------------------------------------------------------------------------------------------------
  
    lTaskName       VARCHAR2(200);

    lTries          NUMBER;
    lStatus         NUMBER;

    lTimeout        NUMBER := 300;

    lRet            BOOLEAN;
    lSCN            NUMBER;
    
    lCursor         NUMBER;

  BEGIN
 
    lCursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(lCursor, pSqlStmt, DBMS_SQL.NATIVE);
    DBMS_SQL.CLOSE_CURSOR(lCursor);

    lRet := DBMS_UTILITY.WAIT_ON_PENDING_DML(tables => UPPER(pTable), timeout => lTimeout, scn => lSCN);

    -- Create the task
    lTaskName := DBMS_PARALLEL_EXECUTE.GENERATE_TASK_NAME('DAR_EDITION_MANAGER_');
    DBMS_PARALLEL_EXECUTE.CREATE_TASK(task_name => lTaskName);
 
    -- Chunk the table by ROWID
    DBMS_PARALLEL_EXECUTE.CREATE_CHUNKS_BY_ROWID(task_name => lTaskName, table_owner => USER, table_name => UPPER(pTable), by_row => TRUE, chunk_size => pChunkSize);
 
    -- Execute the DML in parallel
    DBMS_PARALLEL_EXECUTE.RUN_TASK(task_name => lTaskName, sql_stmt => pSqlStmt, language_flag => DBMS_SQL.NATIVE, parallel_level => pParallelLevel, apply_crossedition_trigger => pTrigger, fire_apply_trigger => TRUE);
 
    -- If there is an error, RESUME it for at most 2 times
    lTries := 0;
    lStatus := DBMS_PARALLEL_EXECUTE.TASK_STATUS(lTaskName);

    WHILE (lTries < 2 AND lStatus IN (DBMS_PARALLEL_EXECUTE.CRASHED, DBMS_PARALLEL_EXECUTE.FINISHED_WITH_ERROR)) LOOP
      lTries := lTries + 1;

      DBMS_PARALLEL_EXECUTE.RESUME_TASK(lTaskName);
      lStatus := DBMS_PARALLEL_EXECUTE.TASK_STATUS(lTaskName);
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('doChunkSQL Status: ' || lStatus);

    -- Done with processing; drop the task
    DBMS_PARALLEL_EXECUTE.DROP_TASK(lTaskName);
  
  EXCEPTION
    WHEN OTHERS THEN 
      IF lTaskName IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: doChunkSQL failed unexpectedly. Task Name: ' || lTaskName || ' Status: ' || DBMS_PARALLEL_EXECUTE.TASK_STATUS(lTaskName));
        DBMS_PARALLEL_EXECUTE.DROP_TASK(lTaskName);
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
      RAISE;

  ---------------
  END doChunkSQL;
  ---------------

END dar_edition_manager;
/
--END_PLSQL

GRANT execute ON dar_owner.dar_edition_manager TO public;
GRANT execute ON dar_owner.dar_edition_manager TO dar_execute;

