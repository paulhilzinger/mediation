-- MZMOB-392 - Ensure ALL corporate OCS CDRs are suppressed from the Kenan retail feeds
-- a new filter reason need to be added in the MZ_FILTER_REASONS table, to filter invalid main offering id

INSERT INTO MZ_FILTER_REASONS ( FILTER_REASON_ID,
DESCRIPTION ) VALUES (
61, 'Invalid Main Offering ID');