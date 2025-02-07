-- MZMOB-802. ROI Tadig lookup table for IMS Nokia

CREATE TABLE GSMA_TADIG_ROI
(
	TADIG          VARCHAR2(5)            NOT NULL, -- This is the primary TADIG code assigned to a Mobile Operator by the GSMA. 
	MCC            VARCHAR2(3)            NOT NULL, -- The Mobile Country Code. 
	MNC            VARCHAR2(3)            NOT NULL, -- Mobile Network Code 
	MGT_CC         VARCHAR2(10)           NOT NULL, -- Mobile Global Title Country Code 
	MGT_NC         VARCHAR2(10)           NOT NULL, -- Mobile Global Title Network Destination Code 
	EFF_DATE       DATE DEFAULT SYSDATE   NOT NULL, -- Date the Roaming agreement is deemed to become effective. Note that this could have been inferred from the date when notification of the TADIG code is included in the data received from RoamSmart for the first time. i.e there is margin for error.
	OPERATOR_NAME  VARCHAR2(80)           NOT NULL, -- Network Operator Name
	COUNTRY        VARCHAR2(80)           NOT NULL, -- Country of Network Operator with the assigned TADIG code 
	RELATION_TYPE  NUMBER(3)    DEFAULT 1 NOT NULL, -- Roaming Partner Relation Type: Valid values: 1 = Sponsored Roaming (TELE2), 2 = Home Network (TUK), 3 = Roam Hubbing (Comfone), 4 = Unilateral
	INPUT_FILENAME VARCHAR2(50)           NOT NULL  -- This column is intended to reflect the source data set (file name) from which a particular row is created/updated. 
);

COMMENT ON TABLE GSMA_TADIG_ROI IS 'This table stores the static information of a Mobile operator.';
COMMENT ON COLUMN GSMA_TADIG_ROI.TADIG          IS 'This is the primary TADIG code assigned to a Mobile Operator by the GSMA.';
COMMENT ON COLUMN GSMA_TADIG_ROI.MCC            IS 'The Mobile Country Code.';
COMMENT ON COLUMN GSMA_TADIG_ROI.MNC            IS 'Mobile Network Code.';
COMMENT ON COLUMN GSMA_TADIG_ROI.MGT_CC         IS 'Mobile Global Title Country Code.';
COMMENT ON COLUMN GSMA_TADIG_ROI.MGT_NC         IS 'Mobile Global Title Network Destination Code.';
COMMENT ON COLUMN GSMA_TADIG_ROI.EFF_DATE       IS 'Date the Roaming agreement is deemed to become effective. Note that this could have been inferred from the date when notification of the TADIG code is included in the data received from RoamSmart for the first time. i.e there is margin for error.';
COMMENT ON COLUMN GSMA_TADIG_ROI.OPERATOR_NAME  IS 'Network Operator Name.';
COMMENT ON COLUMN GSMA_TADIG_ROI.COUNTRY        IS 'Country of Network Operator with the assigned TADIG code.';
COMMENT ON COLUMN GSMA_TADIG_ROI.RELATION_TYPE  IS 'Roaming Partner Relation Type: Valid values: 1 = Sponsored Roaming (TELE2), 2 = Home Network (TUK), 3 = Roam Hubbing (Comfone), 4 = Unilateral';
COMMENT ON COLUMN GSMA_TADIG_ROI.INPUT_FILENAME IS 'This column is intended to reflect the source data set (file name) from which a particular row is created/updated.';

CREATE INDEX GSMA_TADIG_ROI_IDX1 ON GSMA_TADIG_ROI (MCC ASC, MNC ASC);
CREATE INDEX GSMA_TADIG_ROI_IDX2 ON GSMA_TADIG_ROI (MGT_CC ASC, MGT_NC ASC);
CREATE INDEX GSMA_TADIG_ROI_IDX3 ON GSMA_TADIG_ROI (INPUT_FILENAME ASC);
CREATE INDEX GSMA_TADIG_ROI_IDX4 ON GSMA_TADIG_ROI (EFF_DATE DESC);
CREATE INDEX GSMA_TADIG_ROI_IDX5 ON GSMA_TADIG_ROI (MGT_CC ASC);
CREATE INDEX GSMA_TADIG_ROI_IDX6 ON GSMA_TADIG_ROI (COUNTRY ASC);

ALTER TABLE GSMA_TADIG_ROI ADD CONSTRAINT GSMA_TADIG_ROI_PK 
	PRIMARY KEY (TADIG) USING INDEX;