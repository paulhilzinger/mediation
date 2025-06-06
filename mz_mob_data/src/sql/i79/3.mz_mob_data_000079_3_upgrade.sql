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


-- add new parameters in mz_configuration

INSERT INTO mz_configuration(PARAMETER, PARAMETER_VALUE) VALUES ('AOCS_BU_LOOKUP_FORCE_UPDATE', '0');
INSERT INTO mz_configuration(PARAMETER, PARAMETER_VALUE) VALUES ('AOCS_BU_LOOKUP_POST_MIGRATE', '0');
