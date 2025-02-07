CREATE TABLE CDR_OUTPUT_KENAN_GPRS
(
  TRANSACTION_ID      	NUMBER	NOT NULL,
  CREATED_DATE        	DATE	DEFAULT	sysdate               NOT NULL,
  INPUT_FILENAME      	VARCHAR2(100),
  RECORD_TYPE	      	VARCHAR2(10),
  TYPE_ID_USG         	VARCHAR2(10),
  TRANS_DT            	VARCHAR2(20),
  POINT_ORIGIN        	VARCHAR2(30),
  PRIMARY_UNITS       	VARCHAR2(30),
  PROVIDER_ID         	VARCHAR2(10),
  EXT_TRACKING_ID     	VARCHAR2(40),
  AMOUNT              	VARCHAR2(20),
  UNITS_CURRENCY_CODE 	VARCHAR2(10),
  VISIT_COUNTRY_CODE	VARCHAR2(60),
  OCS_CHARGE_CODE_ID	VARCHAR2(30),
  EXTERNAL_ID		VARCHAR2(80),
  EXTERNAL_ID_TYPE	VARCHAR2(10),
  CUSTOMER_TAG		VARCHAR2(30)
)
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX CDR_OUTPUT_KENAN_GPRS_IDX1 ON CDR_OUTPUT_KENAN_GPRS(POINT_ORIGIN);

