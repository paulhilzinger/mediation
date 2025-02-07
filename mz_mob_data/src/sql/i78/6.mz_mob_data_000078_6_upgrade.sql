-- MZMOB-806. [MMSC Sinch] No NODE and PATH for some IBS records & Submit/Status Type Aggregation

-- Insert configurable Session Timeout (in hours) for MMSC SInch Aggregation to IBS.
--
insert into MZ_CONFIGURATION(PARAMETER, PARAMETER_VALUE) values  ('MMSC_AGGR_TIMEOUT_HR', 168);

