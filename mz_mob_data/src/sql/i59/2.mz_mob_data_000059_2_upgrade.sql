-- Amdocs SMS - Widening SMS_ID to 32

ALTER table MZ_MOB_DATA_OWNER.CDR_INPUT_OCS_SMS_AMDOCS modify SMS_ID VARCHAR2(32);