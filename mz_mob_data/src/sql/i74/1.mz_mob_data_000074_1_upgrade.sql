-- MZMOB-776. Issue 86 and 88.
-- Need to alter NCI, NID, LAST_NCI and LAST_NID datatype to VARCHAR2. 
-- Currently (trial period) these fields are populated with value of zero, i.e. no data.
-- Number fields must be set to null before changing datatype.


UPDATE cdr_input_ims_nokia
SET NCI = null,
    NID = null,
    LAST_NCI = null,
    LAST_NID = null;

ALTER TABLE cdr_input_ims_nokia
MODIFY NCI VARCHAR2(32 BYTE);

ALTER TABLE cdr_input_ims_nokia
MODIFY NID VARCHAR2(32 BYTE);

ALTER TABLE cdr_input_ims_nokia
MODIFY LAST_NCI VARCHAR2(32 BYTE);

ALTER TABLE cdr_input_ims_nokia
MODIFY LAST_NID VARCHAR2(32 BYTE);