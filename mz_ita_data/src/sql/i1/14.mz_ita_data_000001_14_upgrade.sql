-- MZITA-79 - Adding in extra fields for supplementary services in the CDR_INPUT_IMS table
--
ALTER TABLE CDR_INPUT_IMS 
ADD
(
  SS_ASSOCIATED_NUMBER_4        VARCHAR2(128),
  SS_SERVICE_MODE_4             NUMBER,
  SS_SERVICE_TYPE_4             NUMBER,
  SS_SERVICE_ACTION_4           NUMBER,
  SS_START_DATE_AND_TIME_4      TIMESTAMP(6),
  SS_END_DATE_AND_TIME_4        TIMESTAMP(6),
  SS_SERVICE_ID_4               VARCHAR2(64),
  SS_ASSOCIATED_NUMBER_5        VARCHAR2(128),
  SS_SERVICE_MODE_5             NUMBER,
  SS_SERVICE_TYPE_5             NUMBER,
  SS_SERVICE_ACTION_5           NUMBER,
  SS_START_DATE_AND_TIME_5      TIMESTAMP(6),
  SS_END_DATE_AND_TIME_5        TIMESTAMP(6),
  SS_SERVICE_ID_5               VARCHAR2(64)
);
