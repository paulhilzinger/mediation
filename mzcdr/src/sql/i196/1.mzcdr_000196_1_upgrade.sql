-- MED-221 - Add ANI and POS_IN_FILE to the IMS input table
--
ALTER TABLE CDR_INPUT_IMS
  ADD ACCESS_NETWORK_INFORMATION VARCHAR2(200);

ALTER TABLE CDR_INPUT_IMS
  ADD POS_IN_FILE NUMBER;

-- MED-233 - Add new business unit for corporate mobile
--
INSERT INTO BUSINESS_UNITS VALUES (15, 'SKYCMO');
