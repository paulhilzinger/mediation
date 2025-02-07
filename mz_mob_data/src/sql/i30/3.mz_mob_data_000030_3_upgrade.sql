-- MZMOB-392 - Ensure ALL corporate OCS CDRs are suppressed from the Kenan retail feeds
-- 

INSERT INTO OCS_MAIN_OFFERING_ID_LOOKUP (MAIN_OFFERING_ID, UNIT_ID) VALUES (
'100000001', 12);

INSERT INTO OCS_MAIN_OFFERING_ID_LOOKUP (MAIN_OFFERING_ID, UNIT_ID) VALUES (
'300000011', 15);

-- a new filter reason need to be added in the MZ_FILTER_REASONS table, to filter mobile corporate usage from kenan feed

INSERT INTO MZ_FILTER_REASONS ( FILTER_REASON_ID,
DESCRIPTION ) VALUES (
60,  'Mobile Corporate Usage');