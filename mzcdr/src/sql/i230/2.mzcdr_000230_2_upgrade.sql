-- MED-613. Improve performance of AOCS BU Build Function - Fixedline DB changes

-- Taken from i17 - 2.mz_mob_data_000017_2_upgrade

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

--BEGIN_PLSQL

CREATE OR REPLACE PROCEDURE TRUNCATE_TABLE_FL (TableName IN VARCHAR2, TableOwner IN VARCHAR2, PrimaryIndexName IN VARCHAR2) AS 
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
		          RAISE_APPLICATION_ERROR(-20004, 'ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
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
		          RAISE_APPLICATION_ERROR(-20005, 'ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
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

        RAISE_APPLICATION_ERROR(-20006, 'ERROR::' || error_number || ' -> ' || error_message || ' >>' || cmd || '<<');
  END;
  

--END_PLSQL
