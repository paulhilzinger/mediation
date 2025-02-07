-- 2023-09-01.AMG.MZMOB-830. Nokia PGW IBS aggregation
-- Add a new UM filter reason for Nokia PGW IBS aggregation
--
INSERT INTO MZ_FILTER_REASONS (FILTER_REASON_ID, DESCRIPTION)
 VALUES
    (64, 'Aggregated Data CDR');
