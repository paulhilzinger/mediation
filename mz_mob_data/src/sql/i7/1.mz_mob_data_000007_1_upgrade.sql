-- MZMOB-153 ADD RATING_GROUP TO THE OCS TABLES
--
ALTER TABLE CDR_INPUT_OCS_GPRS
  ADD RATING_GROUP VARCHAR2(20);


-- MZMOB-107 ADD CEASE_DATE to the DN_BUSINESS_UNIT_LOOKUP TABLE
--
ALTER TABLE DN_BUSINESS_UNIT_LOOKUP
  ADD CEASE_DATE DATE;