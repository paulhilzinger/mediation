-- CT. MZMOB-826 - Widen ORIG_NP field in the DB to two characters
-- Widening below columns to 2.

ALTER TABLE MZ_MOB_DATA_OWNER.CDR_INPUT_SMSC_SINCH
MODIFY (
	ORIG_NP                       VARCHAR(2),
	DEST_NP                       VARCHAR(2),
	DIALLED_DEST_NP               VARCHAR(2),
	DIALLED_OR_DEST_NP            VARCHAR(2),
	MODIFIED_ORIG_NP              VARCHAR(2),
	MODIFIED_ORIG_NP_OR_ORIG_NP   VARCHAR(2),
	MODIFIED_ORIG_NP_OR_ORIG_TON  VARCHAR(2)
);
