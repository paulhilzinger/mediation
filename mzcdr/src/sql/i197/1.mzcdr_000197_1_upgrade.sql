-- MED-229 - Add new filter reasons for filtering retail and business
--
INSERT INTO MZ_FILTER_REASONS (FILTER_REASON_ID, DESCRIPTION) VALUES (78, 'Not Retail CDR');

INSERT INTO MZ_FILTER_REASONS (FILTER_REASON_ID, DESCRIPTION) VALUES (79, 'Not Business CDR');


-- MED-229, MED-227, MED-230 - Add new global sequence number for all sky business osprey output
--
CREATE SEQUENCE OSPREY_OUTPUT_SEQ;