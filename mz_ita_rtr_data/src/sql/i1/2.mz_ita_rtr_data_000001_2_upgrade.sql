-- CREATE COMBINED RADIUS TABLE
--
CREATE TABLE CUMULATIVE_RADIUS
(
  TRANSACTION_ID	  NUMBER NOT NULL,
  RTR_TYPE                VARCHAR2(50 BYTE),
  USERNAME                VARCHAR2(50 BYTE),
  UNIQSESS                VARCHAR2(16 BYTE),
  SESSIONAGE              NUMBER(10),
  UPDATETIME              VARCHAR2(26),
  IN_OCTETS               NUMBER(22),
  OUT_OCTETS              NUMBER(22),
  ALL_STATES              NUMBER(2),
  NAS_TX_SPEED            NUMBER(10),
  NAS_RX_SPEED            NUMBER(10),
  CONNECT_INFO            VARCHAR2(50 BYTE),
  DISCONNECT_CAUSE        VARCHAR2(50 BYTE),
  CLASS                   VARCHAR2(250 BYTE),
  CLIENT_IP               VARCHAR2(50 BYTE),
  PSID                    VARCHAR2(50 BYTE),
  ACCT_SESSION_ID         VARCHAR2(50 BYTE),
  START_TIME              VARCHAR2(26),
  V6PREFIX                NUMBER(10),
  V6IP                    VARCHAR2(50),
  MAPT_IPV4ADDR           VARCHAR2(50 BYTE),
  MAPT_IPV6PREFIX         VARCHAR2(50 BYTE),
  MAPT_PSID_OFFSET        NUMBER(10),
  MAPT_PSID_LEN           NUMBER(10),
  MAPT_PSID               NUMBER(10),
  SDSI                    VARCHAR2(50),
  PROCESSED_TIME          VARCHAR2(26),
  START_STOP_UPDATED_TIME VARCHAR2(26)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


-- CREATE INDEX ON CUMULATIVE_RADIUS TABLE
--
CREATE INDEX CUMULATIVE_RADIUS_IDX1
  ON CUMULATIVE_RADIUS (UNIQSESS, SDSI);


-- CDR_INPUT_RTR
--
CREATE TABLE CDR_INPUT_RTR
(
  TRANSACTION_ID        NUMBER(22),
  CREATED_DATE          DATE DEFAULT SYSDATE NOT NULL,
  INPUT_FILENAME        VARCHAR2(80 BYTE),  
  RTR_TYPE              VARCHAR2(50 BYTE),
  USERNAME              VARCHAR2(50 BYTE),
  UNIQSESS              VARCHAR2(16 BYTE),
  SESSIONAGE            NUMBER(10),
  UPDATETIME            NUMBER(10),
  IN_OCTETS             NUMBER(22),
  IN_GIGA_OCTETS        NUMBER(22),
  OUT_OCTETS            NUMBER(22),
  OUT_GIGA_OCTETS       NUMBER(22),
  ALL_STATES            NUMBER(2),
  NAS_TX_SPEED          NUMBER(10),
  NAS_RX_SPEED          NUMBER(10),
  CONNECT_INFO          VARCHAR2(50 BYTE),
  DISCONNECT_CAUSE      VARCHAR2(50 BYTE),
  CLASS                 VARCHAR2(250 BYTE),
  IN_PACKETS            NUMBER(10),
  OUT_PACKETS           NUMBER(10),
  NAS_IP                VARCHAR2(40 BYTE),
  NAS_PORT              VARCHAR2(50 BYTE),
  CLIENT_IP             VARCHAR2(50 BYTE),
  PSID                  VARCHAR2(50 BYTE),
  ACCT_SESSION_ID       VARCHAR2(50 BYTE),
  MULTISESS             VARCHAR2(50 BYTE),
  START_TIME            NUMBER(10),
  V6PREFIX              NUMBER(10),
  V6IPHIGH64            NUMBER(22),
  V6IPLOW64             NUMBER(22),
  MAPT_IPV4ADDR         VARCHAR2(50 BYTE),
  MAPT_IPV6PREFIX       VARCHAR2(50 BYTE),
  MAPT_PSID_OFFSET	NUMBER(10),
  MAPT_PSID_LEN         NUMBER(10),
  MAPT_PSID             NUMBER(10)
)
  SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE MZ_ITA_CDR_DATA
partition by range(CREATED_DATE)
(
  PARTITION PMAXVALUE  VALUES LESS THAN (MAXVALUE) TABLESPACE  MZ_ITA_CDR_DATA
);
