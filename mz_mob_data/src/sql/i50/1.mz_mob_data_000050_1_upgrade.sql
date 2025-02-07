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
-- *              : MZMOB-193 Deployment for IGOR
-- *
-- * Updated      : MZMOB-202 Deployment for IGOR 2017-03-09 [BK]
-- *              : MZMOB-312 More Indexes Performance Enhancement 2017-03-09 [BK]
-- *              : MZMOB-356 2017-06-08 [BK]
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
-- *       1. DISABLE_FOREIGN_KEYS() or 1 or more DISABLE_FOREIGN_KEY() calls 
-- *                             or
-- *       1. DROP_FOREIGN_KEY()
-- *       2. TRUNCATE_TABLE()
-- *       3. Load new data into the Mediation Zone copy of the OCS tables
-- *       4. REBUILD_INDEX()
-- *       5. ENABLE_FOREIGN_KEYS() or 1 or more ENABLE_FOREIGN_KEY() calls 
-- *                             or
-- *       5. CREATE_FOREIGN_KEY()
-- *
-- *
-- *    NOTE
-- *       DISABLE_FOREIGN_KEY*() must be matched with ENABLE_FOREIGN_KEY*()
-- *       DROP_FOREIGN_KEY() must be matched with CREATE_FOREIGN_KEY()
-- *
-- *    WARNING:
-- *       Currently very basic defensive measures have been taken. A user should
-- *       provide proper data in the passed parameters. For example: truncating
-- *       tables that do not exist or dropping non-existant indexes will all
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
--     * Purpose    : Disable a foreign key references which point to the
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
--     * Procedure  : DISABLE_FOREIGN_KEY
--     * Purpose    : Disable a foreign key references which point to the
--     *              designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *    ForeignKey - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE DISABLE_FOREIGN_KEY (TableName IN VARCHAR2, TableOwner IN VARCHAR2, ForeignKey IN VARCHAR2);

--    /*****************************************************************************
--     * Procedure  : ENABLE_FOREIGN_KEY
--     * Purpose    : Enable all foreign key references which point to the
--     *              designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *    ForeignKey - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE ENABLE_FOREIGN_KEY (TableName IN VARCHAR2, TableOwner IN VARCHAR2, ForeignKey IN VARCHAR2);

--    /*****************************************************************************
--     * Procedure  : DROP_FOREIGN_KEY
--     * Purpose    : Drop a foreign key constraint defined for the designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *    ForeignKey - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE DROP_FOREIGN_KEY (TableName IN VARCHAR2, TableOwner IN VARCHAR2, ForeignKey IN VARCHAR2);

--    /*****************************************************************************
--     * Procedure  : ADD_FOREIGN_KEY
--     * Purpose    : Create a foreign key references which point to the
--     *              designated reference table for the designated table.
--     *
--     * Parameters :
--     *    TableName            - This is a mandatory field.
--     *    TableOwner           - This is a mandatory field.
--     *    ForeignKeyName       - This is a mandatory field.
--     *    ForeignKeyDefinition - This is a mandatory field.
--     *    ReferenceDefinition  - This is a mandatory field.
--     *    CascadeOnDeleteFlag  - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE ADD_FOREIGN_KEY (TableName IN VARCHAR2, TableOwner IN VARCHAR2, ForeignKeyName IN VARCHAR2, ForeignKeyDefinition IN VARCHAR2, ReferenceDefinition IN VARCHAR2, CascadeOnDeleteFlag IN NUMBER);

  PROCEDURE DROP_SECONDARY_INDEX (IndexOwner IN VARCHAR2, IndexName IN VARCHAR2);
  
--    /*****************************************************************************
--     * Procedure  : ADD_SECONDARY_INDEX
--     * Purpose    : Add a secondary index to the designated table.
--     *
--     * Parameters :
--     *    TableName     - This is a mandatory field.
--     *    TableOwner    - This is a mandatory field.
--     *    IndexName     - This is a mandatory field.
--     *    KeyDefinition - This is a mandatory field.
--     *    UniqueIndex   - This is a mandatory field.
--     *
--     * Usage      :
--     *     To create a unique index populate the UniqueIndex with 'UNIQUE'
--     *     otherwise 
--     *
--     *****************************************************************************/

  PROCEDURE ADD_SECONDARY_INDEX (TableName IN VARCHAR2, TableOwner IN VARCHAR2, IndexName IN VARCHAR2, KeyDefinition IN VARCHAR2, UniqueIndex IN VARCHAR2);
  
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
-- * Updated      : Bruce Knowles MZMOB-174 2017-06-08
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
-- *       1. DISABLE_FOREIGN_KEYS() or 1 or more DISABLE_FOREIGN_KEY() calls 
-- *                             or
-- *       1. DROP_FOREIGN_KEY()
-- *       2. TRUNCATE_TABLE()
-- *       3. Load new data into the Mediation Zone copy of the OCS tables
-- *       4. REBUILD_INDEX()
-- *       5. ENABLE_FOREIGN_KEYS() or 1 or more ENABLE_FOREIGN_KEY() calls 
-- *                             or
-- *       5. CREATE_FOREIGN_KEY()
-- *
-- *
-- *    NOTE
-- *       DISABLE_FOREIGN_KEY*() must be matched with ENABLE_FOREIGN_KEY*()
-- *       DROP_FOREIGN_KEY() must be matched with CREATE_FOREIGN_KEY()
-- *
-- *    WARNING:
-- *       Currently very basic defensive measures have been taken. A user should
-- *       provide proper data in the passed parameters. For example: truncating
-- *       tables that do not exist or dropping non-existant indexes will all
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
--     * Procedure  : DISABLE_FOREIGN_KEY
--     * Purpose    : Disable a foreign key references which point to the
--     *              designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *    ForeignKey - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE DISABLE_FOREIGN_KEY (TableName IN VARCHAR2, TableOwner IN VARCHAR2, ForeignKey IN VARCHAR2) AS 
    error_number NUMBER;
    error_message VARCHAR2(1500);
  BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TableOwner || '.' || TableName || ' DISABLE CONSTRAINT ' || ForeignKey;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message);
        RAISE_APPLICATION_ERROR(-20002, 'ERROR::' || error_number || ' -> ' || error_message);
  END;
  
--    /*****************************************************************************
--     * Procedure  : ENABLE_FOREIGN_KEY
--     * Purpose    : Enable all foreign key references which point to the
--     *              designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *    ForeignKey - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE ENABLE_FOREIGN_KEY (TableName IN VARCHAR2, TableOwner IN VARCHAR2, ForeignKey IN VARCHAR2) AS 
    error_number NUMBER;
    error_message VARCHAR2(1500);
  BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE ' || TableOwner || '.' || TableName || ' ENABLE CONSTRAINT ' || ForeignKey;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message);
        RAISE_APPLICATION_ERROR(-20003, 'ERROR::' || error_number || ' -> ' || error_message);
  END;
  
--    /*****************************************************************************
--     * Procedure  : DROP_FOREIGN_KEY
--     * Purpose    : Drop a foreign key constraint defined for the designated table 
--     *
--     * Parameters :
--     *    TableName  - This is a mandatory field.
--     *    TableOwner - This is a mandatory field.
--     *    ForeignKey - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE DROP_FOREIGN_KEY (TableName IN VARCHAR2, TableOwner IN VARCHAR2, ForeignKey IN VARCHAR2) AS
    error_number NUMBER;
    error_message VARCHAR2(1500);
  BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE ' || TableOwner || '.' || TableName || ' DROP CONSTRAINT ' || ForeignKey;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message);
        RAISE_APPLICATION_ERROR(-20004, 'ERROR::' || error_number || ' -> ' || error_message);
  END;
  

--    /*****************************************************************************
--     * Procedure  : ADD_FOREIGN_KEY
--     * Purpose    : Create a foreign key references which point to the
--     *              designated reference table for the designated table.
--     *
--     * Parameters :
--     *    TableName            - This is a mandatory field.
--     *    TableOwner           - This is a mandatory field.
--     *    ForeignKeyName       - This is a mandatory field.
--     *    ForeignKeyDefinition - This is a mandatory field.
--     *    ReferenceDefinition  - This is a mandatory field.
--     *    CascadeOnDeleteFlag  - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/
  PROCEDURE ADD_FOREIGN_KEY (TableName IN VARCHAR2, TableOwner IN VARCHAR2, ForeignKeyName IN VARCHAR2, ForeignKeyDefinition IN VARCHAR2, ReferenceDefinition IN VARCHAR2, CascadeOnDeleteFlag IN NUMBER) AS
    error_number  NUMBER;
    error_message VARCHAR2(1500);
    cascadeString VARCHAR2(20);
    
  BEGIN
    IF CascadeOnDeleteFlag <> 0 THEN
    	cascadeString := ' ON DELETE CASCADE';
    ELSE
    	cascadeString := '';
	END IF;
	    
   EXECUTE IMMEDIATE 'ALTER TABLE ' || TableOwner || '.' || TableName || ' ADD CONSTRAINT ' || ForeignKeyName || ' FOREIGN KEY ' || ForeignKeyDefinition || ' REFERENCES ' || ReferenceDefinition || cascadeString;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message);
        RAISE_APPLICATION_ERROR(-20005, 'ERROR::' || error_number || ' -> ' || error_message);
  END;

---    /*****************************************************************************
--     * Procedure  : DROP_SECONDARY_INDEX
--     * Purpose    : Drop a secondary index of the designated table.
--     *
--     * Parameters :
--     *    IndexOwner - This is a mandatory field.
--     *    IndexName  - This is a mandatory field.
--     *
--     * Usage      :
--     *
--     *****************************************************************************/

  PROCEDURE DROP_SECONDARY_INDEX (IndexOwner IN VARCHAR2, IndexName IN VARCHAR2) AS
    error_number NUMBER;
    error_message VARCHAR2(1500);
    cmd varchar2(350);
    
  BEGIN
    IF IndexName <> 'NO INDEXES' THEN
      cmd := 'DROP INDEX "' || IndexOwner || '"."' || IndexName || '"';
      EXECUTE IMMEDIATE cmd;
    END IF;

    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        
        -- Trap "SQL Error: ORA-01418: specified index does not exist" and ignore it
        IF REGEXP_COUNT(error_message, 'ORA-01418', 1, 'i') <= 0 THEN
            sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
            RAISE_APPLICATION_ERROR(-20006, 'ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
	    END IF;
  END;
  
--    /*****************************************************************************
--     * Procedure  : ADD_SECONDARY_INDEX
--     * Purpose    : ADD a secondary index of the designated table.
--     *
--     * Parameters :
--     *    TableName     - This is a mandatory field.
--     *    TableOwner    - This is a mandatory field.
--     *    IndexName     - This is a mandatory field.
--     *    KeyDefinition - This is a mandatory field.
--     *    UniqueIndex   - This is a mandatory field.
--     *
--     * Usage      :
--     *     To create a unique index populate the UniqueIndex with 'UNIQUE'
--     *     otherwise 
--     *
--     *****************************************************************************/

  PROCEDURE ADD_SECONDARY_INDEX (TableName IN VARCHAR2, TableOwner IN VARCHAR2, IndexName IN VARCHAR2, KeyDefinition IN VARCHAR2, UniqueIndex IN VARCHAR2) AS
    error_number NUMBER;
    error_message VARCHAR2(1500);
    cmd varchar2(350);
  
  BEGIN
    IF IndexName <> 'NO INDEXES' THEN
	  BEGIN
	    cmd := 'CREATE ' || UniqueIndex || ' INDEX ' || TableOwner || '.' || IndexName || ' ON ' || TableOwner || '.' || TableName || ' ' || KeyDefinition;
	    EXECUTE IMMEDIATE cmd;

	    EXCEPTION
	      WHEN OTHERS THEN
	        -- Trap "SQL Error: ORA-00955: name is already used by an existing object" and ignore it
	        IF REGEXP_COUNT(error_message, 'ORA-00955', 1, 'i') <= 0 THEN
		        error_number  := SQLCODE;
		        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;

		        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');

		        RAISE_APPLICATION_ERROR(-20007, 'ERROR::' || error_number || ' -> ' || error_message  || ' >>' || cmd || '<<');
		    END IF;
	  END;
	END IF;
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
    cmd varchar2(350);
    
  BEGIN
    IF PrimaryIndexName <> 'NO INDEXES' THEN
	    BEGIN
          cmd := 'ALTER TABLE "' || TableOwner || '"."' || TableName || '" DROP CONSTRAINT "' || PrimaryIndexName || '"';
          EXECUTE IMMEDIATE cmd;
      
		  EXCEPTION
		    WHEN OTHERS THEN
		      error_number  := SQLCODE;
		      error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;

		      -- Trap "SQL Error: ORA-02443: specified constraint does not exist" and ignore it
		      IF REGEXP_COUNT(error_message, 'ORA-02443', 1, 'i') <= 0 THEN
		          sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
		          RAISE_APPLICATION_ERROR(-20008, 'ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
			  END IF;
	    END;
	    
	    BEGIN
	      cmd := 'DROP INDEX "' || TableOwner || '"."' || PrimaryIndexName || '"';
	      EXECUTE IMMEDIATE cmd;
	      
		  EXCEPTION
		    WHEN OTHERS THEN
		      error_number  := SQLCODE;
		      error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;

		      -- Trap "SQL Error: ORA-01418: specified index does not exist" and ignore it
		      IF REGEXP_COUNT(error_message, 'ORA-01418', 1, 'i') <= 0 THEN
		          sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
		          RAISE_APPLICATION_ERROR(-20009, 'ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
			  END IF;
	    END;
    END IF;

    cmd := 'TRUNCATE TABLE "' || TableOwner || '"."' || TableName || '" DROP STORAGE';
    EXECUTE IMMEDIATE cmd;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;

        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
        RAISE_APPLICATION_ERROR(-20010, 'ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
  END;
  
--    /*****************************************************************************
--     * Procedure  : REBUILD_INDEX
--     * Purpose    : Rebuild the defined Primary Key Index for the supplied table.
--     *               It will also reconstruct the Primary Key Constraint. 
--     *
--     * Parameters :
--     *    TableName            - This is a mandatory field.
--     *    TableOwner           - This is a mandatory field.
--     *    PrimaryIndexName     - This is a mandatory field.
--     *    PrimaryKeyDefinition - This is a mandatory field.
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
    cmd varchar2(350);
    
  BEGIN
    IF PrimaryIndexName <> 'NO INDEXES' THEN
	  BEGIN
	    cmd := 'CREATE UNIQUE INDEX ' || TableOwner || '.' || PrimaryIndexName || ' ON ' || TableOwner || '.' || TableName || ' ' || PrimaryKeyDefinition;
	    EXECUTE IMMEDIATE cmd;

	    EXCEPTION
	      WHEN OTHERS THEN
	        -- Trap "SQL Error: ORA-00955: name is already used by an existing object" and ignore it
	        IF REGEXP_COUNT(error_message, 'ORA-00955', 1, 'i') <= 0 THEN
		        error_number  := SQLCODE;
		        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;

		        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');

		        RAISE_APPLICATION_ERROR(-20011, 'ERROR::' || error_number || ' -> ' || error_message  || ' >>' || cmd || '<<');
		    END IF;
	  END;
	  
	  BEGIN
	      cmd := 'ALTER TABLE ' || TableOwner || '.' || TableName || ' ADD CONSTRAINT ' || PrimaryIndexName || ' PRIMARY KEY ' || PrimaryKeyDefinition;
	      EXECUTE IMMEDIATE cmd;

	    EXCEPTION
	      WHEN OTHERS THEN
	        -- Trap SQL Error: ORA-02260: table can have only one primary key and ignore it
	        IF REGEXP_COUNT(error_message, 'ORA-02260', 1, 'i') <= 0 THEN
		        error_number  := SQLCODE;
		        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;

		        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');

		        RAISE_APPLICATION_ERROR(-20012, 'ERROR::' || error_number || ' -> ' || error_message  || ' >>' || cmd || '<<');
		    END IF;
	  END;
    END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
        RAISE_APPLICATION_ERROR(-20013, 'ERROR::' || error_number || ' -> ' || error_message  || ' >>' || cmd || '<<');
  END;

--    /*****************************************************************************
--     * Procedure  : ANALYZE_TABLE
--     * Purpose    : Analyze the designated table.
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
    cmd           varchar2(350);
    
  BEGIN
  	cmd := 'ANALYZE TABLE ' || TableOwner || '.' || TableName || ' ESTIMATE STATISTICS';
  	
  	EXECUTE IMMEDIATE cmd;

    EXCEPTION
      WHEN OTHERS THEN
        error_number  := SQLCODE;
        error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        
        sys.DBMS_OUTPUT.PUT_LINE('ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
        
        RAISE_APPLICATION_ERROR(-20014, 'ERROR::' || error_number || ' -> ' || error_message  || ' >>' || cmd || '<<');
  END;
END;
/
--
--END_PLSQL
