-- MZMOB-448 - Create an index on the TRANSACTION_ID in the CDR_INPUT_TAP and CDR_INPUT_OCS_VOICE tables
--
CREATE INDEX CDR_INPUT_TAP_IDX4 ON CDR_INPUT_TAP (TRANSACTION_ID) LOCAL PARALLEL 16;

ALTER INDEX CDR_INPUT_TAP_IDX4 NOPARALLEL;


-- CDR_INPUT_OCS_VOICE
--
CREATE INDEX CDR_INPUT_OCS_VOICE_IDX5 ON CDR_INPUT_OCS_VOICE (TRANSACTION_ID) LOCAL PARALLEL 16;

ALTER INDEX CDR_INPUT_OCS_VOICE_IDX5 NOPARALLEL;
