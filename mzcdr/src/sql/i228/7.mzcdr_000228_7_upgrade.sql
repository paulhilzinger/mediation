-- MZMOB-852. Use the A-OCS ISR daily extract file to update mobile BU DNs in the fixed line DB.

-- Table for loading ISR_Resources extracts

CREATE TABLE AOCS_ISR_RESOURCES
(
	RESOURCE_VALUE	 NUMBER(20) NOT NULL,	   -- Msisdn or Imsi
	RESOURCE_TYPE	 NUMBER(2)	NOT NULL, 	   -- 29 = Msisdn, 30 = IMSI
	EFFECTIVE_DATE	 DATE,					   
	EXPIRATION_DATE	 DATE,					   
	SUBSCRIBER_ID	 NUMBER(20) NOT NULL,
	PAYMENT_CATEGORY VARCHAR2(256),
	CUSTOMER_ID		 NUMBER(20) NOT NULL,
	BILL_CYCLE		 NUMBER(2),
	PERIOD_END_DATE  DATE NOT NULL,			-- DateTime of file. Use to grab the latest entry in the event of duplicate files sent by AOCS.
	TRANSACTION_ID	 NUMBER(10) 
);


CREATE UNIQUE INDEX AOCS_ISR_RESOURCES_PK   ON AOCS_ISR_RESOURCES (RESOURCE_VALUE, RESOURCE_TYPE, EFFECTIVE_DATE, TRANSACTION_ID);

-- Table for copying over BC_SUB_IDEN table from MZ_MOB_DATA_OWNER

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

CREATE UNIQUE INDEX BC_SUB_IDEN_PK   ON BC_SUB_IDEN (SUB_IDEN_ID, PERIOD_END_DATE);
CREATE        INDEX BC_SUB_IDEN_IDX1 ON BC_SUB_IDEN (SUB_ID ASC);
CREATE        INDEX BC_SUB_IDEN_IDX2 ON BC_SUB_IDEN (CUST_ID ASC);
CREATE        INDEX BC_SUB_IDEN_IDX3 ON BC_SUB_IDEN (PRIMARY_FLAG ASC);