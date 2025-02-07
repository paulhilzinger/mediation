-- MZMOB-904. [UK, ROI] Add A_number and B_number indexing to CDR input table7

CREATE INDEX CDR_INPUT_IMS_NOKIA_IDX5 ON CDR_INPUT_IMS_NOKIA (A_NUMBER) LOCAL;
CREATE INDEX CDR_INPUT_IMS_NOKIA_IDX6 ON CDR_INPUT_IMS_NOKIA (B_NUMBER) LOCAL;