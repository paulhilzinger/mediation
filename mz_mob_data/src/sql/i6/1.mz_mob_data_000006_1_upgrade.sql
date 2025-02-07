-- MZMOB-75 Deployment for IGOR
--

-- Create IGOR tables
--
CREATE TABLE BC_ACCT
(
	ACCT_ID              NUMBER(20) NOT NULL,    -- Account ID 
	CUST_ID              NUMBER(20) NOT NULL,    -- Home Registration ID. 
	U_CUST_ID            NUMBER(20),
	TP_ACCT_KEY          VARCHAR2(64),  -- Third-Party Account ID. 1. External Type 1 or 12. 
	R_ACCT_ID            NUMBER(20),    -- Root Account ID. 
	P_ACCT_ID            NUMBER(20),    -- Parent Account ID. 
	ACCT_CODE            VARCHAR2(32) NOT NULL,    -- Account Code 
	ACCT_NAME            VARCHAR2(128),    -- Account Name 
	ACCT_TYPE            VARCHAR2(1),    -- Account Type 
	PAYMENT_TYPE         VARCHAR2(1),    -- Payment Mode. 
	ACCT_CLASS           VARCHAR2(1),    -- Account Category. 
	ACCT_PAYMENT_METHOD  VARCHAR2(1),    -- Account Payment Method. 
	BALANCE_POLICY       VARCHAR2(1),    -- Balance Use Policy 
	DUNNING_FLAG         VARCHAR2(1),    -- Dunning Flag. 
	LATE_PAYMENT_FLAG    VARCHAR2(1),    -- Late Fee Waiving Flag. 
	CURRENCY_ID          NUMBER(5) NOT NULL,    -- Account Currency ID. 
	CONTACT_ID           NUMBER(20),    -- Bill Contact Information. 
	BILL_LANG            VARCHAR2(8),    -- Bill Language 
	FREE_M               VARCHAR2(24),    -- Free Bill Medium 
	BE_ID                NUMBER(10),    -- Lowest-Level Home BE ID 
	BE_CODE              VARCHAR2(256),    -- Lowest-Level Home BE Code 
	REGION_ID            NUMBER(20),    -- Home Management Region ID 
	REGION_CODE          VARCHAR2(256),    -- Home Management Region Code 
	STATUS               VARCHAR2(1) NOT NULL,    -- Status 1. Idle 2. Active 3. Call Barring 4. Suspend 8. Pre-deactivation 9. Deactivated 
	STATUS_REASON        VARCHAR2(10),    -- Status Reason 
	STATUS_TIME          DATE NOT NULL,    -- Status Time. 
	EFF_DATE             DATE,    -- Effective Time 
	EXP_DATE             DATE,    -- Expiration Date 
	CREATE_OPER_ID       NUMBER(20),    -- Creation Operator ID 
	CREATE_DEPT_ID       NUMBER(20),    -- Creation Department ID 
	CREATE_TIME          DATE,    -- Creation Time 
	MODIFY_OPER_ID       NUMBER(20),    -- Modification Operator ID 
	MODIFY_DEPT_ID       NUMBER(20),    -- Modification Department ID 
	MODIFY_TIME          DATE,    -- Modification Time 
	TRANSACTION_ID       NUMBER(10),    -- Used by MZ 
	PERIOD_END_DATE      VARCHAR2(8) NOT NULL    -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date. 
);

CREATE TABLE BC_OFFERING_INST
(
	O_INST_ID           NUMBER(20) NOT NULL,    -- Offering Subscription Instance ID 
	CUST_ID             NUMBER(20) NOT NULL,    -- Owner Register Customer ID. This is a Foreign Key. 
	O_ID                NUMBER(20) NOT NULL,    -- Offering ID 
	PURCHASE_SEQ        VARCHAR2(64),    -- Purchase Sequence Number. 
	PRIMARY_FLAG        VARCHAR2(1) NOT NULL,    -- Primary Offering Flag 
	BUNDLE_FLAG         VARCHAR2(1) NOT NULL,    -- Offering Bundle Flag. 
	O_CLASS             VARCHAR2(1) NOT NULL,    -- Offering Class. 
	P_O_INST_ID         NUMBER(20),    -- Parent Offering Instance ID 
	R_GO_INST_ID        NUMBER(20),    -- Related Offering Subscription Instance ID (Group Member Type) 
	R_GROUP_ID          NUMBER(20),    -- Related Group ID. 
	OWNER_TYPE          VARCHAR2(1) NOT NULL,    -- The Owner Entity of Subscription. 
	OWNER_ID            NUMBER(20) NOT NULL,    -- Owner Entity ID of Subscription. 
	SALES_CHANNEL_TYPE  VARCHAR2(3),    -- Sales Channel Type 
	SALES_CHANNEL_ID    VARCHAR2(24),    -- Sales Channel ID 
	SALES_ID            NUMBER(20),    -- Sales ID 
	ACTIVE_MODE         VARCHAR2(1),    -- Activation Mode. 
	ACTIVE_LIMIT_TIME   DATE,    -- Activation Limit Time. 
	O_ACTIVE_DATE       DATE,    -- Offering Activation Date. 
	TRIAL_S_DATE        DATE,    -- Begin Date of Trial Experience. 
	TRIAL_E_DATE        DATE,    -- End Date of Trial Experience. 
	STATUS              VARCHAR2(1) NOT NULL,    -- Status. 
	STATUS_DETAIL       VARCHAR2(24),    -- Suspend Detail 
	STATUS_CHANGE_TIME  DATE,    -- Status Change Time 
	EFF_DATE            DATE,    -- Effective Date. 
	EXP_DATE            DATE,    -- Expiration Date. 
	CREATE_OPER_ID      NUMBER(20),    -- Creator ID 
	CREATE_DEPT_ID      NUMBER(20),    -- Department of Creator. 
	CREATE_TIME         DATE,    -- Creation Time. 
	MODIFY_OPER_ID      NUMBER(20),    -- Last Modification Operator ID. 
	MODIFY_DEPT_ID      NUMBER(20),    -- Department of Modification Operator. 
	MODIFY_TIME         DATE,    -- Last Modification Time. 
	TRANSACTION_ID      NUMBER(10) NOT NULL,    -- Used by MZ 
	PERIOD_END_DATE     VARCHAR2(8) NOT NULL    -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date. 
);

CREATE TABLE BC_SUB_DEF_ACCT
(
	SUB_ID           NUMBER(20),    -- OCS Internal Subscriber 
	PAYMENT_MODE     VARCHAR2(1),    -- 1. Postpaid 
	PRE_ACCT_ID      NUMBER(20),    -- Prepaid Account ID, Not Applicable for SKY 
	POST_ACCT_ID     NUMBER(20),    -- OCS Internal Account ID 
	DFT_ACCT_ID      NUMBER(20),    -- OCS Internal Account ID 
	EFF_DATE         DATE,    -- Effective Date 
	EXP_DATE         DATE,    -- Expiration Date 
	CREATE_OPER_ID   NUMBER(20),    -- Creation Operator ID 
	CREATE_DEPT_ID   NUMBER(20),    -- Creation Operator Department ID 
	CREATE_TIME      DATE,    -- Record creation time. 
	MODIFY_OPER_ID   NUMBER(20),    -- Last Modify operator ID 
	MODIFY_DEPT_ID   NUMBER(20),    -- Last Modify Operator Department ID 
	MODIFY_TIME      DATE,    -- Last modification time. 
	TRANSACTION_ID   NUMBER(10) NOT NULL,
	PERIOD_END_DATE  VARCHAR2(8) NOT NULL    -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date. 
);

CREATE TABLE BC_SUB_IDEN
(
	SUB_IDEN_ID      NUMBER(20) NOT NULL,    -- Subscriber identifier ID 
	SUB_ID           NUMBER(20) NOT NULL,    -- Subscriber ID This is a foreign key. 
	CUST_ID          NUMBER(20) NOT NULL,    -- Owner Register Customer ID 
	NETWORK_TYPE     VARCHAR2(1),    -- Network type 
	SUB_IDEN_TYPE    VARCHAR2(4) NOT NULL,    -- Identity Type. 1 = MSISDN 
	SUB_IDENTITY     VARCHAR2(64) NOT NULL,    -- Identity Number 8. MSISDN 
	PRIMARY_FLAG     VARCHAR2(1) NOT NULL,    -- Primary Identity Flag 
	EFF_DATE         DATE,    -- Effective Date. 
	EXP_DATE         DATE,    -- Expiration Date 
	CREATE_OPER_ID   NUMBER(20),    -- Creator ID 
	CREATE_DEPT_ID   NUMBER(20),    -- Department of Creator 
	CREATION_TIME    DATE,    -- Creation Time 
	MODIFY_OPER_ID   NUMBER(20),    -- Last Modification Operator ID. 
	MODIFY_DEPT_ID   NUMBER(20),    -- Department of Modification Operator. 
	MODIFY_TIME      DATE,    -- Last Modification Time. 
	TRANSACTION_ID   NUMBER(10),    -- Used by MZ 
	PERIOD_END_DATE  VARCHAR2(8) NOT NULL    -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date.  
);

CREATE TABLE BC_SUBSCRIBER
(
	SUB_ID              NUMBER(20) NOT NULL,    -- Subscriber ID 
	CUST_ID             NUMBER(20) NOT NULL,    -- Owner Register Customer ID This is a Foreign Key 
	U_CUST_ID           NUMBER(20) NOT NULL,    -- Actual User Customer ID 
	TP_SUB_KEY          VARCHAR2(64),    -- Third Party Subscription Key 10. External Subscription Key 
	SUB_CLASS           VARCHAR2(1) NOT NULL,    -- Subscriber Classification 
	NETWORK_TYPE        VARCHAR2(1),
	SUB_PWD             VARCHAR2(68),    -- Password of Subscriber 
	FIRST_SET_PWD_FLAG  VARCHAR2(1),    -- First Set Password Flag 
	SUB_P_LANG          VARCHAR2(8),    -- Subscriber Phonic Language Code 
	SUB_W_LANG          VARCHAR2(8),    -- Subscriber Written Language 
	SUB_LEVEL           VARCHAR2(1),    -- Subscriber Level 
	DUNNING_FLAG        VARCHAR2(1),    -- Dunning Flag 
	REGION_ID           NUMBER(20),    -- Business Region ID 
	REGION_CODE         VARCHAR2(256),    -- Business Region Code 
	BE_ID               NUMBER(10),    -- Business Entity ID 
	BE_CODE             VARCHAR2(256),    -- Business Entity Code 
	SALES_CHANNEL_TYPE  VARCHAR2(3),    -- Sales Channel Type 
	SALES_CHANNEL_ID    NUMBER(20),    -- Sales Channel ID 
	SALES_ID            NUMBER(20),    -- Sales ID 
	STATUS              VARCHAR2(1) NOT NULL,    -- Subscriber Status 
	STATUS_DETAIL       VARCHAR2(24),    -- Status Detail 
	STATUS_DATE         DATE,    -- Status Change Time 
	EFF_DATE            DATE,    -- Effective Data 
	EXP_DATE            DATE,    -- Expiration Date 
	ACTIVE_LIMIT        DATE,    -- Latest Activation Time 
	ACTIVE_TIME         DATE,    -- Actual Activation Time 
	CREATE_OPER_ID      NUMBER(20),    -- Creator ID 
	CREATE_DEPT_ID      NUMBER(20),    -- Department of Creator 
	CREATE_TIME         DATE,    -- Creation Time 
	MODIFY_OPER_ID      NUMBER(20),    -- Last Modification Operator ID 
	MODIFY_DEPT_ID      NUMBER(20),    -- Department of Modification Operator 
	MODIFY_TIME         DATE,    -- Last Modification Time 
	TRANSACTION_ID      NUMBER(10),    -- Used by MZ 
	PERIOD_END_DATE     VARCHAR2(8) NOT NULL    -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date.  
);

CREATE TABLE PE_FREE_UNIT
(
	FREE_UNIT_ID              NUMBER(20) NOT NULL,
	CUST_ID                   NUMBER(20) NOT NULL,
	FREE_UNIT_OWNER_TYPE      VARCHAR2(1),    -- S= Subscriber 
	FREE_UNIT_OWNER_ID        NUMBER(20),    -- 10. SUB_ID (OCS internal key) 
	FREE_UNIT_ADD_OWNER_TYPE  VARCHAR2(1),
	FREE_UNIT_ADD_OWNER_ID    NUMBER(20),
	FREE_UNIT_TYPE_ID         NUMBER(20) NOT NULL,    -- This is a Foreign Key 
	RENEWAL_POLICY_ID         NUMBER(20) NOT NULL,
	RENEWAL_FLAG              VARCHAR2(1),
	ORIGIN_TYPE               VARCHAR2(1) NOT NULL,
	ORIGIN_ID                 NUMBER(20) NOT NULL,
	INITIAL_TYPE              VARCHAR2(1) NOT NULL,    -- 1 = Offering 
	INITIAL_ID                NUMBER(20) NOT NULL,    -- 4. Offering Id 
	INITIAL_FREE_UNIT_ID      NUMBER(20),    -- This is a Foreign Key 
	INIT_BALANCE              NUMBER(20),    -- 5. Initial Allowance 
	RESERVE_AMOUNT            NUMBER(20),
	CURRENT_BALANCE           NUMBER(20) NOT NULL,    -- 6. Remaining 
	POLICY_CYCLE_ID           NUMBER(20) NOT NULL,    -- Rollover Cycle ID 
	EXP_DATE                  DATE,    -- Expiration Time 3. Bill period end date 
	EFF_DATE                  DATE,    -- Date offering effective 
	PAY_OFFERING_METHOD       VARCHAR2(1),
	PRE_BC_AMOUNT             NUMBER(20),    -- Balance in last Bill Cycle 
	CREATE_DATE               DATE,    -- Creation Time 
	TRANSACTION_ID            NUMBER(10),    -- Used by MZ 
	PERIOD_END_DATE           VARCHAR2(8) NOT NULL    -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date. 
);


-- Create Indexes
--
CREATE UNIQUE INDEX BC_ACCT_PK ON BC_ACCT (ACCT_ID, PERIOD_END_DATE);

CREATE UNIQUE INDEX BC_OFFERING_INST_PK ON BC_OFFERING_INST (O_INST_ID, PERIOD_END_DATE);

CREATE UNIQUE INDEX BC_SUB_IDEN_PK ON BC_SUB_IDEN (SUB_IDEN_ID, PERIOD_END_DATE);

CREATE UNIQUE INDEX BC_SUBSCRIBER_PK ON BC_SUBSCRIBER (SUB_ID, PERIOD_END_DATE);

CREATE UNIQUE INDEX PE_FREE_UNIT_PK ON PE_FREE_UNIT (FREE_UNIT_ID, PERIOD_END_DATE);


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
END;
/
--
--END_PLSQL


-- Insert MZ duplicate configuration for IGOR
--
INSERT INTO MZ_MOB_DATA_OWNER.MZ_CONFIGURATION (PARAMETER,PARAMETER_VALUE) values ('DUP_BATCH_CHECK_BC_OFFERING_INST', 1);

INSERT INTO MZ_MOB_DATA_OWNER.MZ_CONFIGURATION (PARAMETER,PARAMETER_VALUE) values ('DUP_BATCH_CHECK_BC_SUBSCRIBER', 1);

INSERT INTO MZ_MOB_DATA_OWNER.MZ_CONFIGURATION (PARAMETER,PARAMETER_VALUE) values ('DUP_BATCH_CHECK_BC_SUB_IDEN', 1);

INSERT INTO MZ_MOB_DATA_OWNER.MZ_CONFIGURATION (PARAMETER,PARAMETER_VALUE) values ('DUP_BATCH_CHECK_BC_SUB_DEF_ACCT', 1);

INSERT INTO MZ_MOB_DATA_OWNER.MZ_CONFIGURATION (PARAMETER,PARAMETER_VALUE) values ('DUP_BATCH_CHECK_BC_ACCT', 1);

INSERT INTO MZ_MOB_DATA_OWNER.MZ_CONFIGURATION (PARAMETER,PARAMETER_VALUE) values ('DUP_BATCH_CHECK_PE_FREE_UNIT', 1);
