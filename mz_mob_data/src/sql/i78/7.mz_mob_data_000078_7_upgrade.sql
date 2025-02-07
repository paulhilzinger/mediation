-- 2023-10-31.AMG.MZMOB-806. [MMSC Sinch] No NODE and PATH for some IBS records & Submit/Status Type Aggregation
-- Add a new UM filter reason for Sinch MMSC IBS aggregation
--
INSERT INTO MZ_FILTER_REASONS (FILTER_REASON_ID, DESCRIPTION)
 VALUES
    (65, 'Aggregated MMSC CDR');
