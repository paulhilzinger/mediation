-- Create the IGOR Tables and Indexes
--
-- MZMOB-75  Deployment for IGOR
-- MZMOB-259 Add Auditing Control Checks to IGOR processing
-- MZMOB-312 Create additional indexes
--

--/*********************************************************************************
-- *
-- * Drop existing IGOR tables
-- *
-- *********************************************************************************/
--begin
--	EXECUTE IMMEDIATE 'DROP TABLE   "MZ_MOB_DATA_OWNER"."BC_ACCT" CASCADE CONSTRAINTS';
--	EXCEPTION WHEN OTHERS THEN NULL;

--	EXECUTE IMMEDIATE 'DROP TABLE   "MZ_MOB_DATA_OWNER"."BC_OFFERING_INST" CASCADE CONSTRAINTS';
--	EXCEPTION WHEN OTHERS THEN NULL;

--	EXECUTE IMMEDIATE 'DROP TABLE   "MZ_MOB_DATA_OWNER"."BC_SUB_DEF_ACCT" CASCADE CONSTRAINTS';
--	EXCEPTION WHEN OTHERS THEN NULL;

--	EXECUTE IMMEDIATE 'DROP TABLE   "MZ_MOB_DATA_OWNER"."BC_SUB_IDEN" CASCADE CONSTRAINTS';
--	EXCEPTION WHEN OTHERS THEN NULL;

--	EXECUTE IMMEDIATE 'DROP TABLE   "MZ_MOB_DATA_OWNER"."BC_SUBSCRIBER" CASCADE CONSTRAINTS';
--	EXCEPTION WHEN OTHERS THEN NULL;

--	EXECUTE IMMEDIATE 'DROP TABLE   "MZ_MOB_DATA_OWNER"."PE_FREE_UNIT" CASCADE CONSTRAINTS';
--	EXCEPTION WHEN OTHERS THEN NULL;

--	EXECUTE IMMEDIATE 'DROP TABLE   "MZ_MOB_DATA_OWNER"."PE_ACCM" CASCADE CONSTRAINTS';
--	EXCEPTION WHEN OTHERS THEN NULL;

--	EXECUTE IMMEDIATE 'DROP TABLE   "MZ_MOB_DATA_OWNER"."IGOR_History" CASCADE CONSTRAINTS';
--	EXCEPTION WHEN OTHERS THEN NULL;
--end;


DROP TABLE BC_ACCT CASCADE CONSTRAINTS;
DROP TABLE BC_OFFERING_INST CASCADE CONSTRAINTS;
DROP TABLE BC_SUB_DEF_ACCT CASCADE CONSTRAINTS;
DROP TABLE BC_SUB_IDEN CASCADE CONSTRAINTS;
DROP TABLE BC_SUBSCRIBER CASCADE CONSTRAINTS;
DROP TABLE PE_FREE_UNIT CASCADE CONSTRAINTS;
-- DROP TABLE PE_ACCM CASCADE CONSTRAINTS;
DROP TABLE IGOR_History CASCADE CONSTRAINTS;

--/*********************************************************************************
-- *
-- * Create IGOR tables
-- *
-- *********************************************************************************/

CREATE TABLE BC_ACCT
(
	ACCT_ID              NUMBER(20) NOT NULL,      -- Account ID 
	CUST_ID              NUMBER(20) NOT NULL,      -- Home Registration ID. 
	U_CUST_ID            NUMBER(20),
	TP_ACCT_KEY          VARCHAR2(64),             -- Third-Party Account ID. 1. External Type 1 or 12. 
	R_ACCT_ID            NUMBER(20),               -- Root Account ID. 
	P_ACCT_ID            NUMBER(20),               -- Parent Account ID. 
	ACCT_CODE            VARCHAR2(32) NOT NULL,    -- Account Code 
	ACCT_NAME            VARCHAR2(128),            -- Account Name 
	ACCT_TYPE            VARCHAR2(1),              -- Account Type 
	PAYMENT_TYPE         VARCHAR2(1),              -- Payment Mode. 
	ACCT_CLASS           VARCHAR2(1),              -- Account Category. 
	ACCT_PAYMENT_METHOD  VARCHAR2(1),              -- Account Payment Method. 
	BALANCE_POLICY       VARCHAR2(1),              -- Balance Use Policy 
	DUNNING_FLAG         VARCHAR2(1),              -- Dunning Flag. 
	LATE_PAYMENT_FLAG    VARCHAR2(1),              -- Late Fee Waiving Flag. 
	CURRENCY_ID          NUMBER(5) NOT NULL,       -- Account Currency ID. 
	CONTACT_ID           NUMBER(20),               -- Bill Contact Information. 
	BILL_LANG            VARCHAR2(8),              -- Bill Language 
	FREE_M               VARCHAR2(24),             -- Free Bill Medium 
	BE_ID                NUMBER(10),               -- Lowest-Level Home BE ID 
	BE_CODE              VARCHAR2(256),            -- Lowest-Level Home BE Code 
	REGION_ID            NUMBER(20),               -- Home Management Region ID 
	REGION_CODE          VARCHAR2(256),            -- Home Management Region Code 
	STATUS               VARCHAR2(1) NOT NULL,     -- Status 1. Idle 2. Active 3. Call Barring 4. Suspend 8. Pre-deactivation 9. Deactivated 
	STATUS_REASON        VARCHAR2(10),             -- Status Reason 
	STATUS_TIME          DATE NOT NULL,            -- Status Time. 
	EFF_DATE             DATE,                     -- Effective Time 
	EXP_DATE             DATE,                     -- Expiration Date 
	CREATE_OPER_ID       NUMBER(20),               -- Creation Operator ID 
	CREATE_DEPT_ID       NUMBER(20),               -- Creation Department ID 
	CREATE_TIME          DATE,                     -- Creation Time 
	MODIFY_OPER_ID       NUMBER(20),               -- Modification Operator ID 
	MODIFY_DEPT_ID       NUMBER(20),               -- Modification Department ID 
	MODIFY_TIME          DATE,                     -- Modification Time 
	TRANSACTION_ID       NUMBER(10),               -- Used by MZ 
	PERIOD_END_DATE      VARCHAR2(8) NOT NULL      -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date. 
);

CREATE TABLE BC_OFFERING_INST
(
	O_INST_ID           NUMBER(20) NOT NULL,     -- Offering Subscription Instance ID 
	CUST_ID             NUMBER(20) NOT NULL,     -- Owner Register Customer ID. This is a Foreign Key. 
	O_ID                NUMBER(20) NOT NULL,     -- Offering ID 
	PURCHASE_SEQ        VARCHAR2(64),            -- Purchase Sequence Number. 
	PRIMARY_FLAG        VARCHAR2(1) NOT NULL,    -- Primary Offering Flag 
	BUNDLE_FLAG         VARCHAR2(1) NOT NULL,    -- Offering Bundle Flag. 
	O_CLASS             VARCHAR2(1) NOT NULL,    -- Offering Class. 
	P_O_INST_ID         NUMBER(20),              -- Parent Offering Instance ID 
	R_GO_INST_ID        NUMBER(20),              -- Related Offering Subscription Instance ID (Group Member Type) 
	R_GROUP_ID          NUMBER(20),              -- Related Group ID. 
	OWNER_TYPE          VARCHAR2(1) NOT NULL,    -- The Owner Entity of Subscription. 
	OWNER_ID            NUMBER(20) NOT NULL,     -- Owner Entity ID of Subscription. 
	SALES_CHANNEL_TYPE  VARCHAR2(3),             -- Sales Channel Type 
	SALES_CHANNEL_ID    VARCHAR2(24),            -- Sales Channel ID 
	SALES_ID            NUMBER(20),              -- Sales ID 
	ACTIVE_MODE         VARCHAR2(1),             -- Activation Mode. 
	ACTIVE_LIMIT_TIME   DATE,                    -- Activation Limit Time. 
	O_ACTIVE_DATE       DATE,                    -- Offering Activation Date. 
	TRIAL_S_DATE        DATE,                    -- Begin Date of Trial Experience. 
	TRIAL_E_DATE        DATE,                    -- End Date of Trial Experience. 
	STATUS              VARCHAR2(1) NOT NULL,    -- Status. 
	STATUS_DETAIL       VARCHAR2(24),            -- Suspend Detail 
	STATUS_CHANGE_TIME  DATE,                    -- Status Change Time 
	EFF_DATE            DATE,                    -- Effective Date. 
	EXP_DATE            DATE,                    -- Expiration Date. 
	CREATE_OPER_ID      NUMBER(20),              -- Creator ID 
	CREATE_DEPT_ID      NUMBER(20),              -- Department of Creator. 
	CREATE_TIME         DATE,                    -- Creation Time. 
	MODIFY_OPER_ID      NUMBER(20),              -- Last Modification Operator ID. 
	MODIFY_DEPT_ID      NUMBER(20),              -- Department of Modification Operator. 
	MODIFY_TIME         DATE,                    -- Last Modification Time. 
	TRANSACTION_ID      NUMBER(10) NOT NULL,     -- Used by MZ 
	PERIOD_END_DATE     VARCHAR2(8) NOT NULL     -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date. 
);

CREATE TABLE BC_SUB_DEF_ACCT
(
	SUB_ID           NUMBER(20),             -- OCS Internal Subscriber 
	PAYMENT_MODE     VARCHAR2(1),            -- 1. Postpaid 
	PRE_ACCT_ID      NUMBER(20),             -- Prepaid Account ID, Not Applicable for SKY 
	POST_ACCT_ID     NUMBER(20),             -- OCS Internal Account ID 
	DFT_ACCT_ID      NUMBER(20),             -- OCS Internal Account ID 
	EFF_DATE         DATE,                   -- Effective Date 
	EXP_DATE         DATE,                   -- Expiration Date 
	CREATE_OPER_ID   NUMBER(20),             -- Creation Operator ID 
	CREATE_DEPT_ID   NUMBER(20),             -- Creation Operator Department ID 
	CREATE_TIME      DATE,                   -- Record creation time. 
	MODIFY_OPER_ID   NUMBER(20),             -- Last Modify operator ID 
	MODIFY_DEPT_ID   NUMBER(20),             -- Last Modify Operator Department ID 
	MODIFY_TIME      DATE,                   -- Last modification time. 
	TRANSACTION_ID   NUMBER(10) NOT NULL,
	PERIOD_END_DATE  VARCHAR2(8) NOT NULL    -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date. 
);

CREATE TABLE BC_SUB_IDEN
(
	SUB_IDEN_ID      NUMBER(20) NOT NULL,      -- Subscriber identifier ID 
	SUB_ID           NUMBER(20) NOT NULL,      -- Subscriber ID This is a foreign key. 
	CUST_ID          NUMBER(20) NOT NULL,      -- Owner Register Customer ID 
	NETWORK_TYPE     VARCHAR2(1),              -- Network type 
	SUB_IDEN_TYPE    VARCHAR2(4) NOT NULL,     -- Identity Type. 1 = MSISDN 
	SUB_IDENTITY     VARCHAR2(64) NOT NULL,    -- Identity Number 8. MSISDN 
	PRIMARY_FLAG     VARCHAR2(1) NOT NULL,     -- Primary Identity Flag 
	EFF_DATE         DATE,                     -- Effective Date. 
	EXP_DATE         DATE,                     -- Expiration Date 
	CREATE_OPER_ID   NUMBER(20),               -- Creator ID 
	CREATE_DEPT_ID   NUMBER(20),               -- Department of Creator 
	CREATION_TIME    DATE,                     -- Creation Time 
	MODIFY_OPER_ID   NUMBER(20),               -- Last Modification Operator ID. 
	MODIFY_DEPT_ID   NUMBER(20),               -- Department of Modification Operator. 
	MODIFY_TIME      DATE,                     -- Last Modification Time. 
	TRANSACTION_ID   NUMBER(10),               -- Used by MZ 
	PERIOD_END_DATE  VARCHAR2(8) NOT NULL      -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date.  
);

CREATE TABLE BC_SUBSCRIBER
(
	SUB_ID              NUMBER(20) NOT NULL,     -- Subscriber ID 
	CUST_ID             NUMBER(20) NOT NULL,     -- Owner Register Customer ID This is a Foreign Key 
	U_CUST_ID           NUMBER(20) NOT NULL,     -- Actual User Customer ID 
	TP_SUB_KEY          VARCHAR2(64),            -- Third Party Subscription Key 10. External Subscription Key 
	SUB_CLASS           VARCHAR2(1) NOT NULL,    -- Subscriber Classification 
	NETWORK_TYPE        VARCHAR2(1),
	SUB_PWD             VARCHAR2(68),            -- Password of Subscriber 
	FIRST_SET_PWD_FLAG  VARCHAR2(1),             -- First Set Password Flag 
	SUB_P_LANG          VARCHAR2(8),             -- Subscriber Phonic Language Code 
	SUB_W_LANG          VARCHAR2(8),             -- Subscriber Written Language 
	SUB_LEVEL           VARCHAR2(1),             -- Subscriber Level 
	DUNNING_FLAG        VARCHAR2(1),             -- Dunning Flag 
	REGION_ID           NUMBER(20),              -- Business Region ID 
	REGION_CODE         VARCHAR2(256),           -- Business Region Code 
	BE_ID               NUMBER(10),              -- Business Entity ID 
	BE_CODE             VARCHAR2(256),           -- Business Entity Code 
	SALES_CHANNEL_TYPE  VARCHAR2(3),             -- Sales Channel Type 
	SALES_CHANNEL_ID    NUMBER(20),              -- Sales Channel ID 
	SALES_ID            NUMBER(20),              -- Sales ID 
	STATUS              VARCHAR2(1) NOT NULL,    -- Subscriber Status 
	STATUS_DETAIL       VARCHAR2(24),            -- Status Detail 
	STATUS_DATE         DATE,                    -- Status Change Time 
	EFF_DATE            DATE,                    -- Effective Data 
	EXP_DATE            DATE,                    -- Expiration Date 
	ACTIVE_LIMIT        DATE,                    -- Latest Activation Time 
	ACTIVE_TIME         DATE,                    -- Actual Activation Time 
	CREATE_OPER_ID      NUMBER(20),              -- Creator ID 
	CREATE_DEPT_ID      NUMBER(20),              -- Department of Creator 
	CREATE_TIME         DATE,                    -- Creation Time 
	MODIFY_OPER_ID      NUMBER(20),              -- Last Modification Operator ID 
	MODIFY_DEPT_ID      NUMBER(20),              -- Department of Modification Operator 
	MODIFY_TIME         DATE,                    -- Last Modification Time 
	TRANSACTION_ID      NUMBER(10),              -- Used by MZ 
	PERIOD_END_DATE     VARCHAR2(8) NOT NULL     -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date.  
);

CREATE TABLE PE_FREE_UNIT
(
	FREE_UNIT_ID              NUMBER(20) NOT NULL,
	CUST_ID                   NUMBER(20) NOT NULL,
	FREE_UNIT_OWNER_TYPE      VARCHAR2(1),             -- S= Subscriber 
	FREE_UNIT_OWNER_ID        NUMBER(20),              -- 10. SUB_ID (OCS internal key) 
	FREE_UNIT_ADD_OWNER_TYPE  VARCHAR2(1),
	FREE_UNIT_ADD_OWNER_ID    NUMBER(20),
	FREE_UNIT_TYPE_ID         NUMBER(20) NOT NULL,     -- This is a Foreign Key 
	RENEWAL_POLICY_ID         NUMBER(20) NOT NULL,
	RENEWAL_FLAG              VARCHAR2(1),
	ORIGIN_TYPE               VARCHAR2(1) NOT NULL,
	ORIGIN_ID                 NUMBER(20) NOT NULL,
	INITIAL_TYPE              VARCHAR2(1) NOT NULL,    -- 1 = Offering 
	INITIAL_ID                NUMBER(20) NOT NULL,     -- 4. Offering Id 
	INITIAL_FREE_UNIT_ID      NUMBER(20),              -- This is a Foreign Key 
	INIT_BALANCE              NUMBER(20),              -- 5. Initial Allowance 
	RESERVE_AMOUNT            NUMBER(20),
	CURRENT_BALANCE           NUMBER(20) NOT NULL,     -- 6. Remaining 
	POLICY_CYCLE_ID           NUMBER(20) NOT NULL,     -- Rollover Cycle ID 
	EXP_DATE                  DATE,                    -- Expiration Time 3. Bill period end date 
	EFF_DATE                  DATE,                    -- Date offering effective 
	PAY_OFFERING_METHOD       VARCHAR2(1),
	PRE_BC_AMOUNT             NUMBER(20),              -- Balance in last Bill Cycle 
	CREATE_DATE               DATE,                    -- Creation Time 
	TRANSACTION_ID            NUMBER(10),              -- Used by MZ 
	PERIOD_END_DATE           VARCHAR2(8) NOT NULL     -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date. 
);

CREATE TABLE  "MZ_MOB_DATA_OWNER"."PE_ACCM"
(
	"ACCM_ID"         NUMBER(20) NOT NULL,           -- ID of the accumulator Not useful outside of OCS
	"CUST_ID"         NUMBER(20) NOT NULL,           -- OCS ID of Customer who owns the accumulator.
	"ACCM_OWNER_ID"   NUMBER(20) NOT NULL,           -- OCS ID of Subscriber who owns the accumulator.  This field can be used by Mediation to join the row with entries in other extract tables such as BC_SUBSCRIBER (Sky Mobile - IGOR feed)  By doing so it will be possible to determine the BSS Subscriber Key, BSS Account Key and the MSISDN
	"ACCM_TYPE_ID"    NUMBER(20) NOT NULL,           -- Accumulator type.  This indicates which of the types of accumulators this row is for. It is a number indicating which of the following accumulator types the row is for.
	"BALANCE"         NUMBER(20) DEFAULT 0 NOT NULL, -- Units  E,g, If SMS accumulator it will be a count of the number of SMS events If voice duration accumulator it will be in seconds  Note that each call will have been rounded to the nearest minute. For example a call of 4 minutes 20 will be rounded to 5 minutes. The accumulator will be increased by 300 (5 minutes X 60 seconds)
	"BEGIN_DATE"      DATE NOT NULL,                 -- Start of bill cycle where the accumulator is counting usage for.  Timestamp in format YYYYMMDDHHMMSS. The time will be in UTC and not UK local time This means that during British Summer time if the bill cycle ends 00:00:00 14/05/2020 the value will be 20200513230000 Outside of British Summer Time the time part will be midnight because local time is in sync with UTC This matches the times that are currently processed in IGOR extract for example EFF_DATE and EXP_DATE in the PE_FREE_UNIT table. They are also in UTC.
	"END_DATE"        DATE NOT NULL,                 -- End of bill cycle where the accumulator is counting usage for.  Timestamp in format YYYYMMDDHHMMSS. The time will be in UTC and not UK local time This means that during British Summer time if the bill cycle ends 00:00:00 14/05/2020 the value will be 20200513230000 Outside of British Summer Time the time part will be midnight because local time is in sync with UTC This matches the times that are currently processed in IGOR extract for example EFF_DATE and EXP_DATE in the PE_FREE_UNIT table. They are also in UTC.
	"TRANSACTION_ID"  NUMBER(10) NOT NULL,           -- Used by MZ.
	"PERIOD_END_DATE" VARCHAR2(8) NOT NULL           -- Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date.
);

CREATE TABLE IGOR_History
(
	PERIOD_END_DATE    VARCHAR2(8) NOT NULL,            -- This is the Period End Date of the fiscal period that had just ended at the time the row was exported from the OCS platform. 
	CHECKPOINT_NUMBER  NUMBER(3) DEFAULT 0 NOT NULL,    -- This column provides a simple indicator of the checkpoint set that this row belongs to. Valid values are in the range 1 to 999. 
	PROCESS_TIME       DATE NOT NULL,                   -- This is the timestamp that the row was inserted. 
	FILE_NAME          VARCHAR2(256) NOT NULL,          -- This is the name of the file that this data references. 
	ROW_COUNT          NUMBER(8) DEFAULT 0 NOT NULL,    -- Number of records in the file.
	WORKFLOW_NAME      VARCHAR2(80) NOT NULL     
);

--/*********************************************************************************
-- *
-- * Create Comments, Sequences and Triggers for Autonumber Columns
-- *
-- *********************************************************************************/

COMMENT ON TABLE IGOR_History IS 'This table will be used to store checkpoint information detailing files processed, record counts, processing date, period end date and workflow name that inserted the data';
COMMENT ON COLUMN IGOR_History.PERIOD_END_DATE    IS 'This is the Period End Date of the fiscal period that had just ended at the time the row was exported from the OCS platform.';
COMMENT ON COLUMN IGOR_History.CHECKPOINT_NUMBER  IS 'This column provides a simple indicator of the checkpoint set that this row belongs to. Valid values are in the range 1 to 999.';
COMMENT ON COLUMN IGOR_History.PROCESS_TIME       IS 'This is the timestamp that the row was inserted.';
COMMENT ON COLUMN IGOR_History.FILE_NAME          IS 'This is the name of the file that this data references.';
COMMENT ON COLUMN IGOR_History.WORKFLOW_NAME      IS 'Number of records in the file.';

COMMENT ON COLUMN  "MZ_MOB_DATA_OWNER"."PE_ACCM"."ACCM_ID" IS 'ID of the accumulator. 
Not useful outside of OCS';

COMMENT ON COLUMN  "MZ_MOB_DATA_OWNER"."PE_ACCM"."CUST_ID" IS 'OCS ID of Customer who owns the accumulator';

COMMENT ON COLUMN  "MZ_MOB_DATA_OWNER"."PE_ACCM"."ACCM_OWNER_ID" IS 'OCS ID of Subscriber who owns the accumulator

This field can be used by Mediation to join the row with entries in other extract tables such as BC_SUBSCRIBER (Sky Mobile - IGOR feed)

By doing so it will be possible to determine the BSS Subscriber Key, BSS Account Key and the MSISDN';

COMMENT ON COLUMN  "MZ_MOB_DATA_OWNER"."PE_ACCM"."ACCM_TYPE_ID" IS 'Accumulator type.

This indicates which of the types of accumulators this row is for.
It is a number indicating which of the following accumulator types the row is for.';

COMMENT ON COLUMN  "MZ_MOB_DATA_OWNER"."PE_ACCM"."BALANCE" IS 'Units

E,g,
If SMS accumulator it will be a count of the number of SMS events
If voice duration accumulator it will be in seconds

Note that each call will have been rounded to the nearest minute.
For example a call of 4 minutes 20 will be rounded to 5 minutes. The accumulator will be increased by 300 (5 minutes X 60 seconds)';

COMMENT ON COLUMN  "MZ_MOB_DATA_OWNER"."PE_ACCM"."BEGIN_DATE" IS 'Start of bill cycle where the accumulator is counting usage for.

Timestamp in format YYYYMMDDHHMMSS
The time will be in UTC and not UK local time
This means that during British Summer time if the bill cycle ends 00:00:00
14/05/2020 the value will be 20200513230000
Outside of British Summer Time the time part will be midnight because local
time is in sync with UTC
This matches the times that are currently processed in IGOR extract for example
EFF_DATE and EXP_DATE in the PE_FREE_UNIT table. They are also in UTC.';

COMMENT ON COLUMN  "MZ_MOB_DATA_OWNER"."PE_ACCM"."END_DATE" IS 'End of bill cycle where the accumulator is counting usage for.

Timestamp in format YYYYMMDDHHMMSS
The time will be in UTC and not UK local time
This means that during British Summer time if the bill cycle ends 00:00:00
14/05/2020 the value will be 20200513230000
Outside of British Summer Time the time part will be midnight because local
time is in sync with UTC
This matches the times that are currently processed in IGOR extract for example
EFF_DATE and EXP_DATE in the PE_FREE_UNIT table. They are also in UTC.';

COMMENT ON COLUMN  "MZ_MOB_DATA_OWNER"."PE_ACCM"."PERIOD_END_DATE" IS 'Save the Period End Date here. Use this to segregate multiple days loaded in a single pass. Also use this to constrain traffic such that the relevant EFF_DATE precedes this date and the EXP_DATE is >= this date.';

--/*********************************************************************************
-- *
-- * Create Primary Keys, Indexes, Uniques, Checks, Triggers
-- *
-- *********************************************************************************/

CREATE UNIQUE INDEX BC_ACCT_PK   ON BC_ACCT (ACCT_ID, PERIOD_END_DATE);
CREATE        INDEX BC_ACCT_IDX1 ON BC_ACCT (ACCT_ID ASC);
CREATE        INDEX BC_ACCT_IDX2 ON BC_ACCT (CUST_ID ASC);

CREATE UNIQUE INDEX BC_OFFERING_INST_PK ON BC_OFFERING_INST (O_INST_ID, PERIOD_END_DATE);

CREATE UNIQUE INDEX BC_SUB_IDEN_PK   ON BC_SUB_IDEN (SUB_IDEN_ID, PERIOD_END_DATE);
CREATE        INDEX BC_SUB_IDEN_IDX1 ON BC_SUB_IDEN (SUB_ID ASC);
CREATE        INDEX BC_SUB_IDEN_IDX2 ON BC_SUB_IDEN (CUST_ID ASC);
CREATE        INDEX BC_SUB_IDEN_IDX3 ON BC_SUB_IDEN (PRIMARY_FLAG ASC);

CREATE        INDEX BC_SUB_DEF_ACCT_IDX1 ON BC_SUB_DEF_ACCT (DFT_ACCT_ID ASC);
CREATE        INDEX BC_SUB_DEF_ACCT_IDX2 ON BC_SUB_DEF_ACCT (SUB_ID ASC);

CREATE UNIQUE INDEX BC_SUBSCRIBER_PK   ON BC_SUBSCRIBER (SUB_ID, PERIOD_END_DATE);
CREATE        INDEX BC_SUBSCRIBER_IDX1 ON BC_SUBSCRIBER (SUB_ID ASC);
CREATE        INDEX BC_SUBSCRIBER_IDX2 ON BC_SUBSCRIBER (CUST_ID ASC);

CREATE UNIQUE INDEX PE_FREE_UNIT_PK   ON PE_FREE_UNIT (FREE_UNIT_ID, PERIOD_END_DATE);
CREATE        INDEX PE_FREE_UNIT_IDX1 ON PE_FREE_UNIT (FREE_UNIT_OWNER_ID ASC);
CREATE        INDEX PE_FREE_UNIT_IDX2 ON PE_FREE_UNIT (CUST_ID ASC);

ALTER TABLE  "MZ_MOB_DATA_OWNER"."PE_ACCM" 
 ADD CONSTRAINT "PE_ACCM_PK"
	PRIMARY KEY ("PERIOD_END_DATE","CUST_ID","ACCM_OWNER_ID","ACCM_TYPE_ID", "BEGIN_DATE", "END_DATE") 
 USING INDEX;

CREATE        INDEX PE_ACCM_IDX1       ON PE_ACCM (PERIOD_END_DATE ASC, CUST_ID ASC, ACCM_OWNER_ID ASC, ACCM_TYPE_ID ASC);

CREATE        INDEX IGOR_History_INDEX ON IGOR_History (PERIOD_END_DATE ASC, CHECKPOINT_NUMBER ASC);
CREATE        INDEX FILENAME_INDEX     ON IGOR_History (FILE_NAME ASC);
CREATE        INDEX PERIOD_END_INDEX   ON IGOR_History (PERIOD_END_DATE ASC);

