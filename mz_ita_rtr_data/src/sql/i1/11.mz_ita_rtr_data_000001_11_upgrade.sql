-- MZITA-254 - Refactor RTR - Add table for performance statistics
--
CREATE TABLE MZ_ITA_RTR_DATA_OWNER.MZ_AUDIT_PROCESSING (
   FILE_ID NUMBER,
   FILENAME VARCHAR2(80),
   FILE_TS NUMBER,
   FEED_ID VARCHAR2(4),
   PROCESS_START_TIME DATE,
   PROCESS_END_TIME DATE,
   INPUT_REC_COUNT NUMBER,
   UPDATETIME_FIRST NUMBER,
   UPDATETIME_LAST NUMBER,
   OUT_DL_REC_COUNT NUMBER,
   OUT_DR_REC_COUNT NUMBER,
   OUT_LI_REC_COUNT NUMBER,
   OUT_TRIGGER_REC_COUNT NUMBER,
   EC_NAME VARCHAR2(20),
   WF_NAME VARCHAR2(60),
   TXN_ID NUMBER
);
