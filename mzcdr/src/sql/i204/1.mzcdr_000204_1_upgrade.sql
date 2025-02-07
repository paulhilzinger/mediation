-- MED-268, MED-269 - Add new filter reasons for filtering non Sky Business - SkyBIZ
--
INSERT INTO MZ_FILTER_REASONS (FILTER_REASON_ID, DESCRIPTION) VALUES (80, 'Not Sky Business CDR');


-- MED-268, MED-269, MED-270 - Add new global sequence number for all Sky Business - SkyBIZ - output
--
CREATE SEQUENCE SKYBIZ_OUTPUT_SEQ;