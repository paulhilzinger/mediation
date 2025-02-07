-- MZMOB-392 - Ensure ALL corporate OCS CDRs are suppressed from the Kenan retail feeds
-- a new unit_id for Corporate Mobile needs to be added into the BUSINESS_UNITS table
--
INSERT INTO BUSINESS_UNITS ( UNIT_ID,
UNIT_NAME ) VALUES (
15, 'SKYCMO');
  
