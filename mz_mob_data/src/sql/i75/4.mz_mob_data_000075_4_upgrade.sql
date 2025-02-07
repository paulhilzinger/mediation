-- MZMOB-790. Nokia IMS Mediation Functions for Ireland Mobile
-- Creating main input table. Based on current UK Nokia IMS implementation

CREATE TABLE MZ_MOB_DATA_OWNER.CDR_INPUT_IMS_NOKIA_ROI
( 
TRANSACTION_ID                NUMBER NOT NULL,
CREATED_DATE                  DATE DEFAULT sysdate NOT NULL,
INPUT_FILENAME                VARCHAR2(80 BYTE),
RECORD_TYPE                   NUMBER,
NODE_ADDRESS                  VARCHAR2(128 BYTE),
CALLING_PARTY                 VARCHAR2(128 BYTE),
CALLED_PARTY                  VARCHAR2(128 BYTE),
SUBR_MSISDN                   VARCHAR2(32 BYTE),
SUBR_IMSI                     VARCHAR2(32 BYTE),
SUBR_SIP_URI                  VARCHAR2(200 BYTE),
SUBR_SIP_NAI                  VARCHAR2(64 BYTE),
REQUESTED_PARTY               VARCHAR2(128 BYTE),
A_NUMBER                      VARCHAR2(30 BYTE),
B_NUMBER                      VARCHAR2(30 BYTE),
DELIVERY_START                TIMESTAMP(6),
DELIVERY_END                  TIMESTAMP(6),
DURATION                      NUMBER(22),
RECORD_OPENING_TIME           TIMESTAMP(6),
RECORD_CLOSURE_TIME           TIMESTAMP(6),
ACCOUNTING_REC_TYPE           NUMBER,
ROLE_OF_NODE                  NUMBER,
IMS_COMM_SERVICE_ID           VARCHAR2(30 BYTE),   -- To stay
SERVICE_CONTEXT_ID            VARCHAR2(30 BYTE),   -- To stay
CAUSE_FOR_RECORD_CLOSING      NUMBER,
LOCAL_REC_SEQ_NUMBER          VARCHAR2(10 BYTE),
RECORD_SEQ_NUMBER             NUMBER,
SESSION_ID                    VARCHAR2(128 BYTE),
IMS_CHARGING_ID               VARCHAR2(256 BYTE),
INCOMP_CDR_IND_ACRLOST_START  VARCHAR2(1 BYTE),
INCOMP_CDR_IND_ACRLOST_INTRM  NUMBER,
INCOMP_CDR_IND_ACRLOST_STOP   VARCHAR2(1 BYTE),
SIP_METHOD                    VARCHAR2(30 BYTE),
SRVC_REASON_RTN_CODE          VARCHAR2(10 BYTE),
INCOMING_TRUNK_ID             VARCHAR2(30 BYTE),
OUTGOING_TRUNK_ID             VARCHAR2(30 BYTE),
INCOMING_TRUNK_NAME           VARCHAR2(50 BYTE),
OUTGOING_TRUNK_NAME           VARCHAR2(50 BYTE),
ACCESS_NETWORK_INFORMATION    VARCHAR2(200 BYTE),
ACCESS_TYPE_OR_CLASS          VARCHAR2(30 BYTE),
MCC                           VARCHAR2(5 BYTE),
MNC                           VARCHAR2(5 BYTE),
LAC                           NUMBER,
CI                            NUMBER,
SAC                           NUMBER,
TAC                           NUMBER,
UCI                           NUMBER,
ECI                           NUMBER,
NCI                           VARCHAR2(32 BYTE),
NID                           VARCHAR2(32 BYTE),
RAT                           NUMBER,
LAST_ANI_CHANGE               VARCHAR2(200 BYTE),
LAST_ACCESS_TYPE_OR_CLASS     VARCHAR2(30 BYTE),
LAST_MCC                      VARCHAR2(5 BYTE),
LAST_MNC                      VARCHAR2(5 BYTE),
LAST_LAC                      NUMBER,
LAST_CI                       NUMBER,
LAST_SAC                      NUMBER,
LAST_TAC                      NUMBER,
LAST_UCI                      NUMBER,
LAST_ECI                      NUMBER,
LAST_NCI                      VARCHAR2(32 BYTE),
LAST_NID                      VARCHAR2(32 BYTE),
LAST_RAT                      NUMBER,
LAST_ACCESS_CHANGE_TIME       TIMESTAMP(6),
MAC                           VARCHAR2(16 BYTE),
EQUIP_IMEISV                  VARCHAR2(32 BYTE),
EQUIP_MAC                     VARCHAR2(16 BYTE),
EQUIP_EU164                   VARCHAR2(32 BYTE),
EQUIP_MOD_EU164               VARCHAR2(32 BYTE),
OPTIONAL_NUMBER               VARCHAR2(40 BYTE),
POS_IN_FILE                   NUMBER,
ANI_UE_TIMEZONE               VARCHAR2(20 BYTE),
MSC_NUMBER                    VARCHAR2(128 BYTE),
VLR_NUMBER                    VARCHAR2(128 BYTE),
DELIVERY_START_FRACTION       NUMBER,
DELIVERY_END_FRACTION         NUMBER,
MMT_SERVICE_TYPE1             NUMBER,
MMT_SERVICE_MODE1             NUMBER,
MMT_ASSOC_PARTY_ADDRESS1      VARCHAR2(128 BYTE),
MMT_SERVICE_TYPE2             NUMBER,
MMT_SERVICE_MODE2             NUMBER,
MMT_ASSOC_PARTY_ADDRESS2      VARCHAR2(128 BYTE),
MMT_SERVICE_TYPE3             NUMBER,
MMT_SERVICE_MODE3             NUMBER,
MMT_ASSOC_PARTY_ADDRESS3      VARCHAR2(128 BYTE),
MMT_SERVICE_TYPE4             NUMBER,
MMT_SERVICE_MODE4             NUMBER,
MMT_ASSOC_PARTY_ADDRESS4      VARCHAR2(128 BYTE),
MMT_SERVICE_TYPE5             NUMBER,
MMT_SERVICE_MODE5             NUMBER,
MMT_ASSOC_PARTY_ADDRESS5      VARCHAR2(128 BYTE),
MMT_SERVICE_TYPE6             NUMBER,
MMT_SERVICE_MODE6             NUMBER,
MMT_ASSOC_PARTY_ADDRESS6      VARCHAR2(128 BYTE),
MMT_SERVICE_TYPE7             NUMBER,
MMT_SERVICE_MODE7             NUMBER,
MMT_ASSOC_PARTY_ADDRESS7      VARCHAR2(128 BYTE),
MMT_SERVICE_TYPE8             NUMBER,
MMT_SERVICE_MODE8             NUMBER,
MMT_ASSOC_PARTY_ADDRESS8      VARCHAR2(128 BYTE),
MMT_SERVICE_TYPE9             NUMBER,
MMT_SERVICE_MODE9             NUMBER,
MMT_ASSOC_PARTY_ADDRESS9      VARCHAR2(128 BYTE),
MMT_SERVICE_TYPE10            NUMBER,
MMT_SERVICE_MODE10            NUMBER,
MMT_ASSOC_PARTY_ADDRESS10     VARCHAR2(128 BYTE),
RELATED_ICID                  VARCHAR2(128 BYTE),
REASON_HEADER                 VARCHAR2(200 BYTE),
VISITED_NETWORK_ID            VARCHAR2(128 BYTE),
ACCESS_TRANSFER_TYPE          VARCHAR2(3 BYTE),
CALLED_ASSERTED_ID            VARCHAR2(128 BYTE),
GGSN_ADDR                     VARCHAR2(128 BYTE),
ULI_ORIGINAL 		      VARCHAR2(64 BYTE),
ULI_PREFIX 		      VARCHAR2(3 BYTE),
ULI_MCC_MNC 		      VARCHAR2(6 BYTE),
ULI_AREA_CODE 		      VARCHAR2(32 BYTE),
ULI_CELL_ID 		      VARCHAR2(32 BYTE)
)
SEGMENT CREATION IMMEDIATE                                                            
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING                    
  TABLESPACE MZ_MOB_CDR_DATA                                                          
partition by range(CREATED_DATE)                                                      
(                                                                                     
  PARTITION PMAXVALUE  VALUES LESS THAN (MAXVALUE) TABLESPACE  MZ_MOB_CDR_DATA);      
                                                                                      
CREATE INDEX CDR_INPUT_IMS_NOKIA_ROI_IDX1 ON CDR_INPUT_IMS_NOKIA_ROI (CALLING_PARTY) LOCAL;          
                                                                                      
CREATE INDEX CDR_INPUT_IMS_NOKIA_ROI_IDX2 ON CDR_INPUT_IMS_NOKIA_ROI (CALLED_PARTY) LOCAL;         
                                                                                      
CREATE INDEX CDR_INPUT_IMS_NOKIA_ROI_IDX3 ON CDR_INPUT_IMS_NOKIA_ROI (CREATED_DATE) LOCAL;  
                                                                                      
CREATE INDEX CDR_INPUT_IMS_NOKIA_ROI_IDX4 ON CDR_INPUT_IMS_NOKIA_ROI (TRANSACTION_ID) LOCAL;