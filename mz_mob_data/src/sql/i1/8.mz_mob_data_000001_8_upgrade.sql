CREATE TABLE CDR_INPUT_TAP
(
  TRANSACTION_ID      NUMBER	NOT NULL,
  CREATED_DATE        DATE	DEFAULT	sysdate               NOT NULL,
  INPUT_FILENAME      VARCHAR2(50),
  SOURCE_TADIG        VARCHAR2(10),
  CALL_EVENT_TYPE     VARCHAR2(5),
  CHARGEABLE_IMSI     VARCHAR2(30),
  CHARGEABLE_MSISDN   VARCHAR2(30),
  CHARGEABLE_IMEI     VARCHAR2(30),
  CALLED_NUMBER       VARCHAR2(30),
  DIALLED_DIGITS      VARCHAR2(30),
  CALLING_NUMBER      VARCHAR2(30),
  THIRD_PTY_NUMBER    VARCHAR2(30),
  SMS_NUMBER          VARCHAR2(30),
  A_NUMBER            VARCHAR2(30),
  B_NUMBER            VARCHAR2(30),
  START_TIME          VARCHAR2(30),
  DURATION            VARCHAR2(30),
  CAUSE_FOR_TERM      VARCHAR2(30),
  CALL_REFERENCE      VARCHAR2(30),
  REC_ENT_TYPE        VARCHAR2(30),
  REC_ENT_ID          VARCHAR2(30),
  LAC                 VARCHAR2(30),
  CI                  VARCHAR2(30),
  CHARGE              VARCHAR2(30),
  SERVICE_CODE        VARCHAR2(30),
  CAMEL_SERVICE_KEY   VARCHAR2(30),
  CAMEL_DESTINATION   VARCHAR2(30),
  SS_CODE             VARCHAR2(30),
  SS_ACTION           VARCHAR2(30),
  SS_PARAMS           VARCHAR2(30),
  CHARGED_PTY_STATUS  VARCHAR2(30),
  NON_CHARGED_NUMBER  VARCHAR2(30),
  ORIG_NETWORK        VARCHAR2(30),
  DEST_NETWORK        VARCHAR2(30),
  PDP_ADDRESS         VARCHAR2(30),
  APN_NI              VARCHAR2(30),
  APN_OI              VARCHAR2(30),
  CHARGING_ID         VARCHAR2(30),
  DATA_VOL_IN         VARCHAR2(30),
  DATA_VOL_OUT        VARCHAR2(30)
)
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX CDR_INPUT_TAP_IDX1 ON CDR_INPUT_TAP(A_NUMBER);

CREATE INDEX CDR_INPUT_TAP_IDX2 ON CDR_INPUT_TAP(B_NUMBER);