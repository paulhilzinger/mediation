-- Create tables
--
CREATE TABLE MZ_CONFIGURATION
(
  PARAMETER        VARCHAR2(32 BYTE),
  PARAMETER_VALUE  NUMBER(15)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE MZ_FILTER_REASONS
(
  FILTER_REASON_ID  NUMBER,
  DESCRIPTION       VARCHAR2(100 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE MZ_AUDIT_INPUT
(
  TXN_ID             NUMBER,
  WF_NAME            VARCHAR2(100 BYTE),
  FILE_NAME          VARCHAR2(100 BYTE),
  TIMESTAMP_COLL     DATE,
  FILE_SIZE          NUMBER(15),
  CDR_COUNT          NUMBER(15),
  FIRST_CDR_DATE     DATE,
  LAST_CDR_DATE      DATE,
  TOTAL_WSALE_PRICE  NUMBER(15),
  FILE_VALID_FLAG    NUMBER(15),
  TIMESTAMP_FWD      DATE,
  TOTAL_USAGE	     NUMBER(17,2),
  FILE_TIMESTAMP     DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE MZ_AUDIT_FILTERED
(
  TXN_ID             NUMBER,
  WF_NAME            VARCHAR2(100 BYTE),
  INPUT_FILE_NAME    VARCHAR2(100 BYTE),
  OUTPUT_ID          VARCHAR2(32 BYTE),
  CDR_COUNT          NUMBER(15),
  TOTAL_WSALE_PRICE  NUMBER(15),
  TIMESTAMP_FWD      DATE,
  TOTAL_USAGE        NUMBER(17,2),
  OUTPUT_FILE_NAME   VARCHAR2(100 BYTE),
  FILE_TIMESTAMP     DATE,
  FILTER_REASON_ID   NUMBER
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE MZ_AUDIT_OUTPUT
(
  TXN_ID             NUMBER,
  WF_NAME            VARCHAR2(100 BYTE),
  INPUT_FILE_NAME    VARCHAR2(100 BYTE),
  OUTPUT_ID          VARCHAR2(32 BYTE),
  CDR_COUNT          NUMBER(15),
  TOTAL_WSALE_PRICE  NUMBER(15),
  TIMESTAMP_FWD      DATE,
  TOTAL_USAGE        NUMBER(17,2),
  OUTPUT_FILE_NAME   VARCHAR2(100 BYTE),
  FILE_TIMESTAMP     DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE MZ_AUDIT_STATISTICS
(
  TXN_ID             NUMBER,
  WF_NAME            VARCHAR2(100 BYTE),
  INPUT_FILE_NAME    VARCHAR2(100 BYTE),
  TIMESTAMP_FWD      DATE,
  CDR_COUNT          NUMBER(15),
  TOTAL_WSALE_PRICE  NUMBER(15),
  TOTAL_USAGE        NUMBER(17,2),
  OUTPUT_FILE_NAME   VARCHAR2(100 BYTE),
  FILE_TIMESTAMP     DATE,
  STATISTICS         VARCHAR2(32 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE MZ_AUDIT_FEATURES 
( TXN_ID             NUMBER,
  WF_NAME            VARCHAR2(220 CHAR),
  INPUT_FILE_NAME    VARCHAR2(100 CHAR),
  TIMESTAMP_FWD      DATE,
  FEATURE_NAME       VARCHAR2(20 BYTE),
  CDR_COUNT          NUMBER,
  TOTAL_WSALE_PRICE  NUMBER,
  TOTAL_USAGE        NUMBER,
  OUTPUT_FILE_NAME   VARCHAR2(100 CHAR),
  FILE_TIMESTAMP     DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE BUSINESS_UNITS
( UNIT_ID   NUMBER            NOT NULL
, UNIT_NAME VARCHAR2(20 BYTE) NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE DN_BUSINESS_UNIT_LOOKUP 
( DIRECTORY_NUMBER VARCHAR2(40) NOT NULL,
  UNIT_ID NUMBER NOT NULL,
  START_DATE DATE 
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;
  

CREATE TABLE DN_FREEPHONE_PREFIX_CODES
( FREEPHONE_PREFIX_CODE  VARCHAR2(15) NOT NULL
, FREEPHONE_PREFIX_DESC  VARCHAR2(200) NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


-- Create Sequences
--
CREATE SEQUENCE KENAN_OUTPUT_SEQ
  MINVALUE 1 
  MAXVALUE 999999999999999999999999999 
  INCREMENT BY 1 
  START WITH 1 
  NOCACHE  
  NOORDER  
  NOCYCLE;
  

CREATE SEQUENCE IBS_OUTPUT_SEQ
  MINVALUE 1 
  MAXVALUE 999999999999999999999999999 
  INCREMENT BY 1 
  START WITH 1 
  NOCACHE  
  NOORDER  
  NOCYCLE;


CREATE SEQUENCE FRAUD_OUTPUT_SEQ
  MINVALUE 1 
  MAXVALUE 999999999999999999999999999 
  INCREMENT BY 1 
  START WITH 1 
  NOCACHE  
  NOORDER  
  NOCYCLE;
  
  
-- Create indexes
--
CREATE UNIQUE INDEX MZ_CONFIGURATION_PK
ON MZ_CONFIGURATION (PARAMETER);


CREATE INDEX IDX_MZ_AUD_IN_FN ON MZ_AUDIT_INPUT
(FILE_NAME)
LOGGING
NOPARALLEL;


CREATE INDEX IDX_MZ_AUD_OUT_OFN ON MZ_AUDIT_OUTPUT
(OUTPUT_FILE_NAME)
LOGGING
NOPARALLEL;


CREATE INDEX IDX_MZ_AUD_FLT_IFN ON MZ_AUDIT_FILTERED
(INPUT_FILE_NAME)
LOGGING
NOPARALLEL;


CREATE INDEX IDX_MZ_AUD_FEAT_IFN ON MZ_AUDIT_FEATURES
(INPUT_FILE_NAME)
LOGGING
NOPARALLEL;


CREATE INDEX IDX_MZ_AUD_STAT_IFN ON MZ_AUDIT_STATISTICS
(INPUT_FILE_NAME)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX MZ_FILTER_REASONS_PK ON MZ_FILTER_REASONS
(FILTER_REASON_ID);


CREATE UNIQUE INDEX BUSINESS_UNITS_PK ON BUSINESS_UNITS
(UNIT_ID);


CREATE UNIQUE INDEX DN_FREEPHONE_PREFIX_CODES_PK ON DN_FREEPHONE_PREFIX_CODES
(FREEPHONE_PREFIX_CODE);


CREATE UNIQUE INDEX DN_BUSINESS_UNIT_LOOKUP_PK ON DN_BUSINESS_UNIT_LOOKUP
(DIRECTORY_NUMBER);


CREATE INDEX DN_BUSINESS_UNIT_LOOKUP_FK1 ON DN_BUSINESS_UNIT_LOOKUP
(UNIT_ID);


-- Add contraints
--
ALTER TABLE MZ_CONFIGURATION
ADD CONSTRAINT MZ_CONFIGURATION_PK
PRIMARY KEY (PARAMETER);


ALTER TABLE MZ_FILTER_REASONS
ADD CONSTRAINT MZ_FILTER_REASONS_PK
PRIMARY KEY (FILTER_REASON_ID);


ALTER TABLE BUSINESS_UNITS
ADD CONSTRAINT BUSINESS_UNITS_PK
PRIMARY KEY (UNIT_ID);


ALTER TABLE DN_BUSINESS_UNIT_LOOKUP 
ADD CONSTRAINT DN_BUSINESS_UNIT_LOOKUP_PK 
PRIMARY KEY (DIRECTORY_NUMBER);


ALTER TABLE DN_BUSINESS_UNIT_LOOKUP
ADD (CONSTRAINT DN_BUSINESS_UNIT_LOOKUP_FK1 
FOREIGN KEY (UNIT_ID) REFERENCES BUSINESS_UNITS (UNIT_ID));

 
ALTER TABLE DN_FREEPHONE_PREFIX_CODES 
ADD CONSTRAINT DN_FREEPHONE_PREFIX_CODES_PK 
PRIMARY KEY (FREEPHONE_PREFIX_CODE);


-- Insert rows
--
-- INSERT FREEPHONE PREFIX CODES
--
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'0800', 'Freephone prefix'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'0500', 'Freephone prefix'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'100', 'Operator prefix'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'0808', 'Freephone prefix'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'1571', 'VoiceMail'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'17070', 'Line Test Number'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'1572', 'Voicemail'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'1577', 'Voicemail'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'1578', 'Voicemail'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'999', 'Emergency Services'); 
INSERT INTO DN_FREEPHONE_PREFIX_CODES ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'112', 'Emergency Services');


-- Insert Business Units
--
INSERT INTO BUSINESS_UNITS (UNIT_ID, UNIT_NAME) VALUES (1, 'SKYTLKMO');
