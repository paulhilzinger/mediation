-- Create Broadsoft BW input table
--
CREATE TABLE CDR_INPUT_BW
(
  RECORD_ID                                 VARCHAR2(72),
  RECORD_ID_SYS_ID                          VARCHAR2(32),
  RECORD_ID_EVENT_COUNT                     VARCHAR2(10),
  RECORD_ID_DATE                            VARCHAR2(18),
  RECORD_ID_TIME_ZONE                       VARCHAR2(10),
  CREATED_DATE                              DATE	DEFAULT sysdate	NOT NULL,
  SERVICE_PROVIDER                          VARCHAR2(30), 
  RECORD_TYPE                               VARCHAR2(13),
  GROUP_NUMBER                              VARCHAR2(16),
  DIRECTION                                 VARCHAR2(11),
  CALLING_PRES_IND                          VARCHAR2(20),
  CALLING_NUMBER                            VARCHAR2(161),
  CALLED_NUMBER                             VARCHAR2(161),
  USER_NUMBER                               VARCHAR2(16),
  A_NUMBER                                  VARCHAR2(161),
  B_NUMBER                                  VARCHAR2(161),
  C_NUMBER                                  VARCHAR2(16),
  START_TIME                                VARCHAR2(18),
  USER_TIME_ZONE                            VARCHAR2(8),
  ANSWER_INDICATOR                          VARCHAR2(19),
  ANSWER_TIME                               VARCHAR2(18),
  RELEASE_TIME                              VARCHAR2(18),
  TERMINATION_CAUSE                         VARCHAR2(3),
  NETWORK_TYPE                              VARCHAR2(4),
  CARRIER_ID_CODE                           VARCHAR2(4),
  DIALED_DIGITS                             VARCHAR2(161),
  CALL_CATEGORY                             VARCHAR2(8),
  NETWORK_CALL_TYPE                         VARCHAR2(4),
  NETWORK_TRANSLATED_NUMBER                 VARCHAR2(161),
  NETWORK_TRANSLATED_GROUP                  VARCHAR2(32),
  RELEASING_PARTY                           VARCHAR2(6),
  CHARGE_IND                                VARCHAR2(1),
  TYPE_OF_NETWORK                           VARCHAR2(7),
  LOCAL_CALL_ID                             VARCHAR2(40),
  REMOTE_CALL_ID                            VARCHAR2(40),
  USER_ID                                   VARCHAR2(161),
  OTHER_PARTY_NAME                          VARCHAR2(80),
  OTHER_PARTY_NAME_PRES_IND                 VARCHAR2(20),  
  CLID_PERMITTED                            VARCHAR2(3),
  Q850_CAUSE                                VARCHAR2(3),
  DIALED_DIGITS_CTX                         VARCHAR2(161),
  CALLED_NUMBER_CTX                         VARCHAR2(161),
  NETWORK_TRANSLATED_NUMBER_CTX             VARCHAR2(161),
  CALLING_NUMBER_CTX                        VARCHAR2(161),
  RECEIVED_CALLING_NUMBER                   VARCHAR2(161),
  AS_CALL_TYPE                              VARCHAR2(11),
  NAME_PERMITTED                            VARCHAR2(3),
  DIALABLE_CALLING_NUMBER                   VARCHAR2(22),
  CALLING_PRES_NUMBER                       VARCHAR2(161),
  CALLING_PRES_NUMBER_CTX                   VARCHAR2(161),
  CALLING_ASSERTED_NUMBER                   VARCHAR2(161),
  CALLING_ASSERTED_NUMBER_CTX               VARCHAR2(161),
  RESELLER                                  VARCHAR2(36),
  REDIRECTING_NUMBER                        VARCHAR2(161),
  ROUTE                                     VARCHAR2(86),
  NETWORK_CALL_ID                           VARCHAR2(161),
  FIELD_CODEC                               VARCHAR2(30),
  FAILOVER_CORRELATION_ID                   VARCHAR2(161),
  KEY_IP                                    VARCHAR2(100),
  CREATOR                                   VARCHAR2(100),
  ORIGINATOR_NETWORK                        VARCHAR2(100),
  TERMINATOR_NETWORK                        VARCHAR2(100)
)
-- Partition table based on created date
--
SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE MZ_CDR_DATA  
PARTITION BY RANGE(CREATED_DATE)
(
  PARTITION PMAXVALUE VALUES LESS THAN (MAXVALUE) TABLESPACE  MZ_CDR_DATA);

-- Create Indexes
--
CREATE INDEX CDR_INPUT_BW_IDX1 ON CDR_INPUT_BW(RECORD_ID) LOCAL;

CREATE INDEX CDR_INPUT_BW_IDX2 ON CDR_INPUT_BW(RECORD_ID_SYS_ID) LOCAL;

CREATE INDEX CDR_INPUT_BW_IDX3 ON CDR_INPUT_BW(START_TIME) LOCAL;

CREATE INDEX CDR_INPUT_BW_IDX4 ON CDR_INPUT_BW(CALLING_NUMBER) LOCAL;

CREATE INDEX CDR_INPUT_BW_IDX5 ON CDR_INPUT_BW(CALLED_NUMBER) LOCAL;

-- Create Configuration Constants
--
INSERT INTO MZ_CONFIGURATION VALUES ('BW_DUP_BATCH_CHECK', 1);

INSERT INTO MZ_CONFIGURATION VALUES ('BW_DUP_UDR_CHECK', 1);

INSERT INTO MZ_CONFIGURATION VALUES ('BW_VERSION', 225);

INSERT INTO MZ_CONFIGURATION VALUES ('BW_CDR_MAX_FIELDS_FAILOVER', 50);

INSERT INTO MZ_CONFIGURATION VALUES ('BW_CDR_MAX_FIELDS_BASIC', 455);