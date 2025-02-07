
-- 2024-03-11.AMG. MZMOB-915.[Sky Business] All issues and observations related to N-IMS. Issue 12 : Data length of IMS_COMM_SERVICE_ID column
ALTER TABLE MZ_MOB_DATA_OWNER.CDR_INPUT_IMS_NOKIA
MODIFY (
	IMS_COMM_SERVICE_ID	VARCHAR2(256)
);