-- MZMOB-900. [Sky Business] All issues and observations related to Amdocs OCS
-- Issue 27 NRC - CDR_INPUT_OCS_NRC_AMDOCS table needs to be updated to include new field 'PRIMARY_OFFER_ID'

ALTER TABLE CDR_INPUT_OCS_NRC_AMDOCS
  ADD PRIMARY_OFFER_ID VARCHAR2(20 BYTE);
