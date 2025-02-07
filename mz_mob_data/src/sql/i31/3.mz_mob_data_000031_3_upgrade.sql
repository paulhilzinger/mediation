-- MZMOB-416 - Adding the OCS GPRS RAT TYPE field in the DB as request by the DW team - [amg]
--
ALTER TABLE CDR_INPUT_OCS_GPRS
  ADD RAT_TYPE NUMBER(10);