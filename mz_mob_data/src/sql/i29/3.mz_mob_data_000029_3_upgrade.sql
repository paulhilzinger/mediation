-- MZMOB-389 - Add OrgAccount and DestAccount fields to the SMSC input table
--
ALTER TABLE CDR_INPUT_SMSC
  ADD ORG_ACCOUNT VARCHAR2(30);

ALTER TABLE CDR_INPUT_SMSC
  ADD DEST_ACCOUNT VARCHAR2(30);
