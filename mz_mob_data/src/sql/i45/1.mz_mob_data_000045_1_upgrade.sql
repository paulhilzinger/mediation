-- MZMOB-505 - Add column for VoLTE with SRVCC
--
ALTER TABLE CDR_INPUT_IMS
  ADD INITIAL_ICID VARCHAR2(128);