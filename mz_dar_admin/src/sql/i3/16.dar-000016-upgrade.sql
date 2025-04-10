--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE dar_owner.dar_edition_manager 
AUTHID CURRENT_USER
AS

  PROCEDURE setEdition (pName VARCHAR2);
  FUNCTION getEdition RETURN VARCHAR2;
  PROCEDURE getEdition;

  PROCEDURE grantEdition;
  PROCEDURE finaliseEdition;

  PROCEDURE checkForInvalidObjects;
  PROCEDURE checkForXETriggers;

  PROCEDURE doChunkSQL (pTable VARCHAR2, pChunkSize NUMBER, pParallelLevel NUMBER, pSqlStmt VARCHAR2, pTrigger VARCHAR2);

END dar_edition_manager;
/
--END_PLSQL
--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE BODY dar_owner.dar_edition_manager AS

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE setEdition (pName VARCHAR2) IS
  -----------------------------------------------------------------------------------------------------------------------------------------
  BEGIN

    dar_edition_manager_defn.setEdition(pName);

  ---------------
  END setEdition;
  ---------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  FUNCTION getEdition RETURN VARCHAR2 IS
  -----------------------------------------------------------------------------------------------------------------------------------------

    lSession				VARCHAR2(200);

  BEGIN

    SELECT SYS_CONTEXT('USERENV', 'SESSION_EDITION_NAME') 
    INTO   lSession
    FROM   DUAL;

    RETURN lSession;

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

    lApp            VARCHAR2(200) := SUBSTR(USER, 1, INSTR(USER, '_', -1) -1);

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
      EXECUTE IMMEDIATE 'GRANT SELECT,INSERT,UPDATE,DELETE ON ' || getGrantObjectsRec.object_name || ' TO ' || UPPER(lApp) || '_READONLY';
      EXECUTE IMMEDIATE 'GRANT SELECT,INSERT,UPDATE,DELETE ON ' || getGrantObjectsRec.object_name || ' TO ' || UPPER(lApp) || '_UPDATE';
      EXECUTE IMMEDIATE 'GRANT SELECT,INSERT,UPDATE,DELETE ON ' || getGrantObjectsRec.object_name || ' TO ' || UPPER(lApp) || '_EXECUTE';
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

    lObjects        typObjects;

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
  PROCEDURE checkForXETriggers IS
  -----------------------------------------------------------------------------------------------------------------------------------------
  
    CURSOR getObjects IS
    SELECT o.object_name, o.edition_name
    FROM   user_objects_ae o, user_source_ae s 
    WHERE  o.object_name = s.name 
    AND    o.object_type = 'TRIGGER'
    AND    UPPER(s.text) LIKE '%CROSSEDITION%';

    getObjectsRec   getObjects%ROWTYPE;

  BEGIN
  
    OPEN getObjects;
    FETCH getObjects INTO getObjectsRec;

    IF getObjects%FOUND THEN
      RAISE_APPLICATION_ERROR(-20902, 'Crossedition Triggers Exist (' || getObjectsRec.object_name || ' in ' || getObjectsRec.edition_name || ')');
    END IF;

    CLOSE getObjects; 

  -----------------------
  END checkForXETriggers;
  -----------------------
 
  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE doChunkSQL (pTable VARCHAR2, pChunkSize NUMBER, pParallelLevel NUMBER, pSqlStmt VARCHAR2, pTrigger VARCHAR2) IS
  -----------------------------------------------------------------------------------------------------------------------------------------

    lTries          NUMBER;
    lStatus         NUMBER;

    lTimeout        NUMBER := 300;

    lRet            BOOLEAN;
    lSCN            NUMBER;

  BEGIN
 
    lRet := DBMS_UTILITY.WAIT_ON_PENDING_DML(tables => pTable, timeout => lTimeout, scn => lSCN);

    -- Create the task
    DBMS_PARALLEL_EXECUTE.CREATE_TASK(task_name => 'chunkTask');
 
    -- Chunk the table by ROWID
    DBMS_PARALLEL_EXECUTE.CREATE_CHUNKS_BY_ROWID(task_name => 'chunkTask', table_owner => USER, table_name => pTable, by_row => TRUE, chunk_size => pChunkSize);
 
    -- Execute the DML in parallel
    DBMS_PARALLEL_EXECUTE.RUN_TASK(task_name => 'chunkTask', sql_stmt => pSqlStmt, language_flag => DBMS_SQL.NATIVE, parallel_level => pParallelLevel, apply_crossedition_trigger => pTrigger, fire_apply_trigger => TRUE);
 
    -- If there is an error, RESUME it for at most 2 times
    lTries := 0;
    lStatus := DBMS_PARALLEL_EXECUTE.TASK_STATUS('chunkTask');

    WHILE (lTries < 2 AND lStatus != DBMS_PARALLEL_EXECUTE.FINISHED) LOOP
      lTries := lTries + 1;

      DBMS_PARALLEL_EXECUTE.RESUME_TASK('chunkTask');
      lStatus := DBMS_PARALLEL_EXECUTE.TASK_STATUS('chunkTask');
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('Parallel Execute Exit Code: ' || DBMS_PARALLEL_EXECUTE.TASK_STATUS('chunkTask'));

    -- Done with processing; drop the task
    DBMS_PARALLEL_EXECUTE.DROP_TASK('chunkTask');
  
  EXCEPTION
    WHEN OTHERS THEN 
      DBMS_PARALLEL_EXECUTE.DROP_TASK('chunkTask');
      RAISE;

  ---------------
  END doChunkSQL;
  ---------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE dropEdition (pName VARCHAR2) IS
  -----------------------------------------------------------------------------------------------------------------------------------------

    CURSOR getChildren IS
    SELECT edition_name
    FROM   all_editions
    CONNECT BY PRIOR edition_name = parent_edition_name
    START WITH parent_edition_name = pName;

    lEditions       SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();

    editionDoesNotExist   EXCEPTION;
    PRAGMA EXCEPTION_INIT (editionDoesNotExist, -38802);

  BEGIN

    OPEN getChildren;
    FETCH getChildren BULK COLLECT INTO lEditions;
    CLOSE getChildren;

    IF lEditions.COUNT > 0 THEN
      FOR i IN REVERSE lEditions.FIRST..lEditions.LAST LOOP
        EXECUTE IMMEDIATE 'DROP EDITION ' || lEditions(i);
      END LOOP;
    END IF;

    EXECUTE IMMEDIATE 'DROP EDITION ' || pName;
  
  EXCEPTION
    WHEN editionDoesNotExist THEN
      NULL;

  ----------------
  END dropEdition;
  ----------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE actualise IS
  -----------------------------------------------------------------------------------------------------------------------------------------

    CURSOR getObjects IS
    SELECT object_name, DECODE(object_type, 'PACKAGE BODY', 'PACKAGE', object_type) AS object_type
    FROM   user_objects
    WHERE  object_type IN ('SYNONYM', 'VIEW', 'TRIGGER', 'PACKAGE BODY', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'TYPE');

    TYPE typObjects IS TABLE OF getObjects%ROWTYPE INDEX BY BINARY_INTEGER;

    lObjects        typObjects;

  BEGIN

    IF lObjects.COUNT > 0 THEN
      FOR i IN lObjects.FIRST..lObjects.LAST LOOP
        EXECUTE IMMEDIATE 'ALTER ' || lObjects(i).object_type || ' ' || lObjects(i).object_name || ' COMPILE';
      END LOOP;
    END IF;

  --------------
  END actualise;
  --------------

END dar_edition_manager;
/
--END_PLSQL

GRANT EXECUTE ON dar_owner.dar_edition_manager TO PUBLIC;

