-- MZMOB-774 . Comfone DCH Mediation Functions for Ireland Mobile
-- DN_FREEPHONE_PREFIX_CODES_TAP_ROI 
-- Freephone Filtering. New filtering scenarios added as part of CRR-355


CREATE TABLE MZ_MOB_DATA_OWNER.DN_FREEPHONE_PREFIX_CODES_TAP_ROI (
	FREEPHONE_PREFIX_CODE VARCHAR(20),
	FREEPHONE_PREFIX_DESC VARCHAR(100)
	);
	
INSERT INTO MZ_MOB_DATA_OWNER.DN_FREEPHONE_PREFIX_CODES_TAP_ROI (FREEPHONE_PREFIX_CODE, FREEPHONE_PREFIX_DESC) VALUES ('3531800', 'Freephone Prefix');
INSERT INTO MZ_MOB_DATA_OWNER.DN_FREEPHONE_PREFIX_CODES_TAP_ROI (FREEPHONE_PREFIX_CODE, FREEPHONE_PREFIX_DESC) VALUES ('00800', 'International Freephone Prefix');
INSERT INTO MZ_MOB_DATA_OWNER.DN_FREEPHONE_PREFIX_CODES_TAP_ROI (FREEPHONE_PREFIX_CODE, FREEPHONE_PREFIX_DESC) VALUES ('116000', 'Hotlines for Missing Children');
INSERT INTO MZ_MOB_DATA_OWNER.DN_FREEPHONE_PREFIX_CODES_TAP_ROI (FREEPHONE_PREFIX_CODE, FREEPHONE_PREFIX_DESC) VALUES ('116006', 'Helpline for Victims of Crime');
INSERT INTO MZ_MOB_DATA_OWNER.DN_FREEPHONE_PREFIX_CODES_TAP_ROI (FREEPHONE_PREFIX_CODE, FREEPHONE_PREFIX_DESC) VALUES ('116111', 'Child Helplines');
INSERT INTO MZ_MOB_DATA_OWNER.DN_FREEPHONE_PREFIX_CODES_TAP_ROI (FREEPHONE_PREFIX_CODE, FREEPHONE_PREFIX_DESC) VALUES ('116117', 'Non-Emergency Medical on Call Service');
INSERT INTO MZ_MOB_DATA_OWNER.DN_FREEPHONE_PREFIX_CODES_TAP_ROI (FREEPHONE_PREFIX_CODE, FREEPHONE_PREFIX_DESC) VALUES ('116123', 'Emotional Support Helplines ');
