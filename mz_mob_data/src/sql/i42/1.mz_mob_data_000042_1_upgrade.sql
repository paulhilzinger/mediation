-- MZMOB-489. AMG. Enable requirements for free Sky Go data usage in UK and EU - Watch 2.0
-- Need to add a new UM filter reason for this requirement, there's an ask for being able to differentiate this filtered traffic in UM.
-- Insert a row into the MZ_FILTER_REASONS
--
INSERT INTO MZ_FILTER_REASONS (FILTER_REASON_ID, DESCRIPTION)
VALUES
(63, 'Not Required For Kenan Free Data Offer Sky Go Watch 2.0');