CREATE TABLE CDR_INPUT_SMSC
(
  TRANSACTION_ID                NUMBER NOT NULL,
  CREATED_DATE                  DATE DEFAULT sysdate NOT NULL,
  INPUT_FILENAME                VARCHAR2(80),
  TIME_SERIAL_NUMBER            VARCHAR2(20),
  SM_ID                         VARCHAR2(15),
  ORIGINAL_ADDRESS              VARCHAR2(30),
  TON_OF_ORIG_ADDR              VARCHAR2(5),
  NPI_OF_ORIG_ADDR              VARCHAR2(5),
  PROPERTIES_OF_ORIG_ADDR       VARCHAR2(5),
  DESTINATION_DELIVERY_ADDRESS  VARCHAR2(30),
  TON_OF_DEST_ADDR              VARCHAR2(5),
  NPI_OF_DEST_ADDR              VARCHAR2(5),
  PROPERTIES_OF_DEST_ADDR       VARCHAR2(5),
  ORG_SUBMISSION_TIME           VARCHAR2(30),
  FINAL_TIME                    VARCHAR2(30),
  PRIORITY_LEVEL                VARCHAR2(5),
  SM_LENGTH                     VARCHAR2(20),
  SRR                           VARCHAR2(5),
  PID                           VARCHAR2(5),
  DCS                           VARCHAR2(5),
  SMSTATUS                      VARCHAR2(5),
  ERROR_CODE                    VARCHAR2(5),
  TYPE_OF_THE_SM                VARCHAR2(15),
  UDHI                          VARCHAR2(5),
  MR                            VARCHAR2(10),
  RN                            VARCHAR2(10),
  MN                            VARCHAR2(5),
  SN                            VARCHAR2(5),
  MOMSCADDR                     VARCHAR2(30),
  MTMSCADDR                     VARCHAR2(30),
  LASTERR                       VARCHAR2(5),
  ORGIMSI                       VARCHAR2(30),
  DESTIMSI                      VARCHAR2(30),
  ORIGINAL_DELIVERY_ADDRESS     VARCHAR2(30),
  TON_OF_ORIG_DEST              VARCHAR2(5),
  NPI_OF_ORIG_DEST              VARCHAR2(5),
  MESSAGETYPE                   VARCHAR2(5),
  BILLTYPE                      VARCHAR2(5),
  BILLINGIDENTIFICATION         VARCHAR2(50),
  SERVINGCELLID                 VARCHAR2(20),
  SERVINGMSCID                  VARCHAR2(20),
  IMEIADDR                      VARCHAR2(20),
  MSGREFERENCENUMBER            VARCHAR2(10),
  TOTALSEGMENT                  VARCHAR2(5),
  SEGMENTSEQUENCE               VARCHAR2(5),
  LOCUSSMSTATUS                 VARCHAR2(15),
  SERIAL_NUMBER                 VARCHAR2(15),
  IFROAMING                     VARCHAR2(5),
  TRANSACTIONID                 VARCHAR2(20)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX CDR_INPUT_SMSC_IDX1 ON CDR_INPUT_SMSC(ORIGINAL_ADDRESS);

CREATE INDEX CDR_INPUT_SMSC_IDX2 ON CDR_INPUT_SMSC(DESTINATION_DELIVERY_ADDRESS);

CREATE TABLE CDR_INPUT_MMSC
(
  TRANSACTION_ID              NUMBER NOT NULL,
  CREATED_DATE                DATE	DEFAULT sysdate	NOT NULL,
  INPUT_FILENAME              VARCHAR2(80),
  MM_SERIAL_NUMBER            VARCHAR2(30),
  CHARGED_USER_NUMBER         VARCHAR2(30),
  IMSI                        VARCHAR2(20),
  CHARGED_USER_TYPE           VARCHAR2(5),
  ORIGINATING_PARTY_ADDRESS   VARCHAR2(30),
  TERMINATING_PARTY_ADDRESS   VARCHAR2(50),
  FORWARD_MSISDN_NUMBER       VARCHAR2(30),
  CDR_TYPE                    VARCHAR2(5),
  INFORMATION_TYPE            VARCHAR2(5),
  APPLICATIONTYPE             VARCHAR2(5),
  FORWARD_AND_COPY_TYPE       VARCHAR2(5),
  CHARGING_TYPE               VARCHAR2(15),
  INFORMATION_FEE             VARCHAR2(15),
  MM_SIZE                     VARCHAR2(15),
  STORAGE_DURATION            VARCHAR2(15),
  BEARER_MODE                 VARCHAR2(5),
  MOBILE_PHONE_IP_ADDRESS     VARCHAR2(30),
  MM_SEND_STATUS              VARCHAR2(5),
  ORIGINATING_MMSC_ID         VARCHAR2(10),
  TERMINATING_MMSC_ID         VARCHAR2(10),
  VASP_ID                     VARCHAR2(30),
  VAS_ID                      VARCHAR2(10),
  SERVICE_CODE                VARCHAR2(30),
  AREA_CODE_ACCESSED_BY_USER  VARCHAR2(15),
  RECEIVE_TIME                VARCHAR2(20),
  SEND_TIME                   VARCHAR2(20),
  EARLIEST_SEND_TIME          VARCHAR2(20),
  MM_CONTENT_TYPE             VARCHAR2(10),
  MESSAGE_CLASS               VARCHAR2(5),
  MM_PRIORITY                 VARCHAR2(5),
  REPORT_REQUEST              VARCHAR2(5),
  SENDER_VISIBILITY           VARCHAR2(5),
  SECURITY_LEVEL              VARCHAR2(5),
  CONTENT_ADAPTATION          VARCHAR2(5)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX CDR_INPUT_MMSC_IDX1 ON CDR_INPUT_MMSC(ORIGINATING_PARTY_ADDRESS);

CREATE INDEX CDR_INPUT_MMSC_IDX2 ON CDR_INPUT_MMSC(TERMINATING_PARTY_ADDRESS);

CREATE TABLE CDR_INPUT_IMS
(
  TRANSACTION_ID                NUMBER	NOT NULL,
  CREATED_DATE                  DATE	DEFAULT sysdate	NOT NULL,
  INPUT_FILENAME                VARCHAR2(80),  
  RECORD_TYPE                   NUMBER,
  NODE_ADDRESS                  VARCHAR2(128),
  CALLING_PARTY                 VARCHAR2(128),
  CALLED_PARTY                  VARCHAR2(128),
  CHARGED_PARTY                 VARCHAR2(128),
  DIALLED_PARTY                 VARCHAR2(128),
  A_NUMBER                      VARCHAR2(30),
  B_NUMBER                      VARCHAR2(30),
  DELIVERY_START                TIMESTAMP(6),
  DELIVERY_END                  TIMESTAMP(6),
  DURATION                      NUMBER(22),
  ACCOUNTING_REC_TYPE           NUMBER,
  ROLE_OF_NODE                  NUMBER,
  SERVICE_IDENTIFIER            NUMBER,
  CAUSE_FOR_RECORD_CLOSING      NUMBER,
  LOCAL_REC_SEQ_NUMBER          VARCHAR2(10),
  RECORD_SEQ_NUMBER             NUMBER,
  SESSION_ID                    VARCHAR2(128),
  IMS_CHARGING_ID               VARCHAR2(128),
  INCOMP_CDR_IND_ACRLOST_START  VARCHAR2(1),
  INCOMP_CDR_IND_ACRLOST_INTRM  NUMBER,
  INCOMP_CDR_IND_ACRLOST_STOP   VARCHAR2(1),
  SIP_METHOD                    VARCHAR2(30),
  SRVC_REASON_RTN_CODE          VARCHAR2(10),
  INCOMING_TRUNK_GRP_ID         VARCHAR2(30),
  OUTGOING_TRUNK_GRP_ID         VARCHAR2(30),
  ACCESS_NETWORK_INFORMATION    VARCHAR2(200),
  ACCESS_TYPE_OR_CLASS          VARCHAR2(30),
  MCC                           VARCHAR2(5),
  MNC                           VARCHAR2(5),
  LAC                           NUMBER,
  CI                            NUMBER,
  SAC                           NUMBER,
  TAC                           NUMBER,
  UCI                           NUMBER,
  ECI                           NUMBER,
  MAC                           VARCHAR2(15)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX CDR_INPUT_IMS_IDX1 ON CDR_INPUT_IMS(A_NUMBER);

CREATE INDEX CDR_INPUT_IMS_IDX2 ON CDR_INPUT_IMS(B_NUMBER);