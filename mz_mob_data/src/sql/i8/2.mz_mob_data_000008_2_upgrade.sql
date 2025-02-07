-- MZMOB-193 Deployment for IGOR
--

-- Create the IGOR package and procedures
--
--BEGIN_PLSQL
--
CREATE OR REPLACE PACKAGE IGOR_PACKAGE AS 
--/*********************************************************************************
-- * Package      : Package_IGOR
-- *
-- * Author       : Bruce Knowles
-- * Date Written : 2016-09-01
-- *
-- * Overview
-- *    This package has been created to encapsulate necessary DDL functions for
-- *    management of the Project IGOR Oracle Tables. 
-- *
-- *    At the time of initial development this group of procedures was intended
-- *    to provide an ordered set of tools to support the daily truncation of each
-- *    of the tables used by the Mediation Zone application when processing the
-- *    data sets extracted from the OCS platforms' Oracle tables.
-- *
-- *    The intended order of use is:
-- *       1. DISABLE_FOREIGN_KEYS()
-- *       2. TRUNCATE_TABLE()
-- *       3. Load new data into the Mediation Zone copy of the OCS tables
-- *       4. REBUILD_INDEX()
-- *       5. ENABLE_FOREIGN_KEYS()
-- *
-- *    WARNING:
-- *       Currently very basic defensive measures have been taken. A user should
-- *       provide proper data in the passed parameters. For example: truncating
-- *       tables that do not exist or dropping non-exsistant indexes will all
-- *       cause the procedures to terminate early. However, all Oracle errors
-- *       are trapped and returned to the calling process. 
-- *
-- *********************************************************************************/

--/*********************************************************************************
-- *
-- * Package Header
-- *
-- *********************************************************************************/
--    /*****************************************************************************
--     * Procedure  : DISABLE_FOREIGN_KEYS
--     * Purpose    : Disable all foreign key references which point to the
--     *              designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE DISABLE_FOREIGN_KEYS (TableName IN VARCHAR2, TableOwner IN VARCHAR2);

--    /*****************************************************************************
--     * Procedure  : ENABLE_FOREIGN_KEYS
--     * Purpose    : Enable all foreign key references which point to the
--     *              designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE ENABLE_FOREIGN_KEYS (TableName IN VARCHAR2, TableOwner IN VARCHAR2);

--    /*****************************************************************************
--     * Procedure  : TRUNCATE_TABLE
--     * Purpose    : Truncate the supplied table. It will also drop an associated
--     *              index which is deemed to store the Primary Key for this table. 
--     *              The Primary Key Constraint will also be deleted. This happens
--     *              before the Index is dropped.
--     *
--     * Parameters :
--     *    TableName        - This is a mandatory field.
--     *    TableOwner       - This is a mandatory field.
--     *    PrimaryIndexName - This is a mandatory field.
--     *
--     * Usage      :
--     *    This procedure can only handle a single Index file. If the field
--     *    PrimaryIndexName contains the value 'NO INDEXES' then no attempt
--     *    to delete the Index or Primary Key Constraint will occur.
--     *
--     *****************************************************************************/
  PROCEDURE TRUNCATE_TABLE (TableName IN VARCHAR2, TableOwner IN VARCHAR2, PrimaryIndexName IN VARCHAR2);

--    /*****************************************************************************
--     * Procedure  : REBUILD_INDEX
--     * Purpose    : Rebuild the defined Primary Key Index for the supplied table.
--     *               It will also reconstruct the Primary Key Constraint. 
--     *
--     * Parameters :
--     *    TableName        - This is a mandatory field.
--     *    TableOwner       - This is a mandatory field.
--     *    PrimaryIndexName - This is a mandatory field.
--     *
--     * Usage      :
--     *    This procedure can only handle a single Index file. If the field
--     *    PrimaryIndexName contains the value 'NO INDEXES' then no attempt
--     *    to reconstruct the Index or Primary Key Constraint will occur.
--     *
--     *****************************************************************************/
  PROCEDURE REBUILD_INDEX(TableName IN VARCHAR2, TableOwner IN VARCHAR2, PrimaryIndexName IN VARCHAR2, PrimaryKeyDefinition IN VARCHAR2);

--    /*****************************************************************************
--     * Procedure  : ANALYZE_TABLE
--     * Purpose    : Analyze the designated table .
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE ANALYZE_TABLE(TableName IN VARCHAR2, TableOwner IN VARCHAR2);
END IGOR_PACKAGE;
/
--
--END_PLSQL


--BEGIN_PLSQL
--
CREATE OR REPLACE PACKAGE BODY IGOR_PACKAGE IS 
--/*********************************************************************************
-- * Package      : Package_IGOR
-- *
-- * Author       : Bruce Knowles
-- * Date Written : 2016-09-01
-- *
-- * Overview
-- *    This package has been created to encapsulate necessary DDL functions for
-- *    management of the Project IGOR Oracle Tables. 
-- *
-- *    At the time of initial development this group of procedures was intended
-- *    to provide an ordered set of tools to support the daily truncation of each
-- *    of the tables used by the Mediation Zone application when processing the
-- *    data sets extracted from the OCS platforms' Oracle tables.
-- *
-- *    The intended order of use is:
-- *       1. DISABLE_FOREIGN_KEYS()
-- *       2. TRUNCATE_TABLE()
-- *       3. Load new data into the Mediation Zone copy of the OCS tables
-- *       4. REBUILD_INDEX()
-- *       5. ENABLE_FOREIGN_KEYS()
-- *
-- *    WARNING:
-- *       Currently very basic defensive measures have been taken. A user should
-- *       provide proper data in the passed parameters. For example: truncating
-- *       tables that do not exist or dropping non-exsistant indexes will all
-- *       cause the procedures to terminate early. However, all Oracle errors
-- *       are trapped and returned to the calling process. 
-- *
-- *********************************************************************************/

--/*********************************************************************************
-- *
-- * Package Implementation
-- *
-- *********************************************************************************/

--    /*****************************************************************************
--     * Procedure  : DISABLE_FOREIGN_KEYS
--     * Purpose    : Disable all foreign key references which point to the
--     *              designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE DISABLE_FOREIGN_KEYS (TableName IN VARCHAR2, TableOwner IN VARCHAR2) AS 
    error_number NUMBER;
    error_message VARCHAR2(1500);
  BEGIN
    FOR cur IN (SELECT fk.owner, fk.constraint_name , fk.table_name 
      FROM all_constraints fk, all_constraints pk 
        WHERE fk.CONSTRAINT_TYPE = 'R'                AND 
          pk.owner               = TableOwner         AND
          fk.r_owner             = pk.owner           AND
          fk.R_CONSTRAINT_NAME   = pk.CONSTRAINT_NAME AND 
          pk.TABLE_NAME          = TableName) LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE ' || cur.owner || '.' || cur.table_name || ' MODIFY CONSTRAINT ' || cur.constraint_name || ' DISABLE';
    END LOOP;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message);
        RAISE_APPLICATION_ERROR(-20000, 'ERROR::' || error_number || ' -> ' || error_message);
  END;
  
--    /*****************************************************************************
--     * Procedure  : ENABLE_FOREIGN_KEYS
--     * Purpose    : Enable all foreign key references which point to the
--     *              designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE ENABLE_FOREIGN_KEYS (TableName IN VARCHAR2, TableOwner IN VARCHAR2) AS 
    error_number NUMBER;
    error_message VARCHAR2(1500);
  BEGIN
    FOR cur IN (SELECT fk.owner, fk.constraint_name, fk.table_name
      FROM all_constraints fk, all_constraints pk 
        WHERE fk.CONSTRAINT_TYPE = 'R'                AND
          pk.owner               = TableOwner         AND
          fk.r_owner             = pk.owner           AND
          fk.R_CONSTRAINT_NAME   = pk.CONSTRAINT_NAME AND pk.CONSTRAINT_TYPE = 'P' AND 
          pk.TABLE_NAME          = TableName) LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE ' || cur.owner || '.' || cur.table_name || ' MODIFY CONSTRAINT ' || cur.constraint_name || ' ENABLE';
    END LOOP;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message);
        RAISE_APPLICATION_ERROR(-20001, 'ERROR::' || error_number || ' -> ' || error_message);
  END;
  
--    /*****************************************************************************
--     * Procedure  : TRUNCATE_TABLE
--     * Purpose    : Truncate the supplied table. It will also drop an associated
--     *              index which is deemed to store the Primary Key for this table. 
--     *              The Primary Key Constraint will also be deleted. This happens
--     *              before the Index is dropped.
--     *
--     * Parameters :
--     *    TableName        - This is a mandatory field.
--     *    TableOwner       - This is a mandatory field.
--     *    PrimaryIndexName - This is a mandatory field.
--     *
--     * Usage      :
--     *    This procedure can only handle a single Index file. If the field
--     *    PrimaryIndexName contains the value 'NO INDEXES' then no attempt
--     *    to delete the Index or Primary Key Constraint will occur.
--     *
--     *****************************************************************************/
  PROCEDURE TRUNCATE_TABLE (TableName IN VARCHAR2, TableOwner IN VARCHAR2, PrimaryIndexName IN VARCHAR2) AS 
    error_number NUMBER;
    error_message VARCHAR2(1500);
    cmd varchar2(150);
    
  BEGIN
    IF PrimaryIndexName <> 'NO INDEXES' THEN
      cmd := 'ALTER TABLE "' || TableOwner || '"."' || TableName || '" DROP CONSTRAINT "' || PrimaryIndexName || '"';
      EXECUTE IMMEDIATE cmd;
      cmd := 'DROP INDEX "' || TableOwner || '"."' || PrimaryIndexName || '"';
      EXECUTE IMMEDIATE cmd;
    END IF;

    cmd := 'TRUNCATE TABLE "' || TableOwner || '"."' || TableName || '" DROP STORAGE';
    EXECUTE IMMEDIATE cmd;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
        RAISE_APPLICATION_ERROR(-20002, 'ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
  END;
  
--    /*****************************************************************************
--     * Procedure  : REBUILD_INDEX
--     * Purpose    : Rebuild the defined Primary Key Index for the supplied table.
--     *               It will also reconstruct the Primary Key Constraint. 
--     *
--     * Parameters :
--     *    TableName        - This is a mandatory field.
--     *    TableOwner       - This is a mandatory field.
--     *    PrimaryIndexName - This is a mandatory field.
--     *
--     * Usage      :
--     *    This procedure can only handle a single Index file. If the field
--     *    PrimaryIndexName contains the value 'NO INDEXES' then no attempt
--     *    to reconstruct the Index or Primary Key Constraint will occur.
--     *
--     *****************************************************************************/
  PROCEDURE REBUILD_INDEX(TableName IN VARCHAR2, TableOwner IN VARCHAR2, PrimaryIndexName IN VARCHAR2, PrimaryKeyDefinition IN VARCHAR2) AS 
    error_number NUMBER;
    error_message VARCHAR2(1500);
    cmd varchar2(150);
    
  BEGIN
    IF PrimaryIndexName <> 'NO INDEXES' THEN
      cmd := 'CREATE UNIQUE INDEX ' || TableOwner || '.' || PrimaryIndexName || ' ON ' || TableOwner || '.' || TableName || ' ' || PrimaryKeyDefinition;
      EXECUTE IMMEDIATE cmd;
      cmd := 'ALTER TABLE ' || TableOwner || '.' || TableName || ' ADD CONSTRAINT ' || PrimaryIndexName || ' PRIMARY KEY ' || PrimaryKeyDefinition;
      EXECUTE IMMEDIATE cmd;
    END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
        RAISE_APPLICATION_ERROR(-20003, 'ERROR::' || error_number || ' -> ' || error_message  || ' >>' || cmd || '<<');
  END;

--    /*****************************************************************************
--     * Procedure  : ANALYZE_TABLE
--     * Purpose    : Analyze the designated table .
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE ANALYZE_TABLE(TableName IN VARCHAR2, TableOwner IN VARCHAR2) AS
    error_number  NUMBER;
    error_message VARCHAR2(1500);
    cmd           varchar2(150);
    
  BEGIN
  	cmd := 'ANALYZE TABLE ' || TableOwner || '.' || TableName || 'ESTIMATE STATISTICS';
  	
  	EXECUTE IMMEDIATE cmd;

    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
        
        RAISE_APPLICATION_ERROR(-20004, 'ERROR::' || error_number || ' -> ' || error_message  || ' >>' || cmd || '<<');
  END;
END;
/
--
--END_PLSQL

-- Insert MZ duplicate configuration for IGOR
--
insert into MZ_CONFIGURATION(PARAMETER, PARAMETER_VALUE) values  ('DUP_BATCH_CHECK_IGOR', 1);
