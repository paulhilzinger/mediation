-- MZMOB-455 - Create an index on the TRANSACTION_ID in the CDR_INPUT_IMS table
--
CREATE INDEX CDR_INPUT_IMS_IDX4 ON CDR_INPUT_IMS (TRANSACTION_ID) LOCAL PARALLEL 16;

ALTER INDEX CDR_INPUT_IMS_IDX4 NOPARALLEL;


-- MZMOB-455 - Create an index on the TRANSACTION_ID in the CDR_INPUT_OCS_GPRS table
--
CREATE INDEX CDR_INPUT_OCS_GPRS_IDX3 ON CDR_INPUT_OCS_GPRS (TRANSACTION_ID) LOCAL PARALLEL 16;

ALTER INDEX CDR_INPUT_OCS_GPRS_IDX3 NOPARALLEL;


-- MZMOB-455 - Create an index on the TRANSACTION_ID in the CDR_INPUT_OCS_SMS table
--
CREATE INDEX CDR_INPUT_OCS_SMS_IDX4 ON CDR_INPUT_OCS_SMS (TRANSACTION_ID) LOCAL PARALLEL 16;

ALTER INDEX CDR_INPUT_OCS_SMS_IDX4 NOPARALLEL;