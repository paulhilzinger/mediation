-- MZMOB-886. Implement RoamSmart file processing for ROI
-- Creating the following ROI tables for ROI IR21 processing.
-- GSMA_IP_RANGES_ROI
-- GSMA_CC_NDC_MAP2TADIG_ROI
-- GSMA_MCC_MNC_MAP2TADIG_ROI

CREATE TABLE GSMA_IP_RANGES_ROI
(
	IP_START       NUMBER(15)             NOT NULL, -- Numeric equivalent of an IP version 4 address. Start of range. 
	IP_STOP        NUMBER(15)             NOT NULL, -- Numeric equivalent of an IP version 4 address. End of range 
	IP_ADDRESS     VARCHAR2(18)           NOT NULL, -- Keep this for information purposes. 
	TADIG          VARCHAR2(5)            NOT NULL, -- TADIG Code of the owning Mobile Network. 
	EFF_DATE       DATE DEFAULT SYSDATE   NOT NULL, -- Effective date.  
	MGT_CC         VARCHAR2(10)           NOT NULL, -- Mobile Global Title Country Code
	MGT_NC         VARCHAR2(10)           NOT NULL, -- Mobile Global Title Network Destination Code
	COUNTRY        VARCHAR2(80)           NOT NULL, -- Country of Network Operator with the assigned TADIG code
	RELATION_TYPE  NUMBER(3)    DEFAULT 1 NOT NULL, -- Roaming Partner Relation Type: Valid values: 1 = Sponsored Roaming (TELE2), 2 = Home Network (TUK), 3 = Roam Hubbing (Comfone), 4 = Unilateral
	INPUT_FILENAME VARCHAR2(50)           NOT NULL  -- This column is intended to reflect the source data set (file name) from which a particular row is created/updated. 
);

COMMENT ON COLUMN GSMA_IP_RANGES_ROI.IP_START       IS 'Numeric equivalent of an IP version 4 address. Start of range.';
COMMENT ON COLUMN GSMA_IP_RANGES_ROI.IP_STOP        IS 'Numeric equivalent of an IP version 4 address. End of range';
COMMENT ON COLUMN GSMA_IP_RANGES_ROI.IP_ADDRESS     IS 'Keep this for information purposes.';
COMMENT ON COLUMN GSMA_IP_RANGES_ROI.TADIG          IS 'TADIG Code of the owning Mobile Network.';
COMMENT ON COLUMN GSMA_IP_RANGES_ROI.EFF_DATE       IS 'Effective date. ';
COMMENT ON COLUMN GSMA_IP_RANGES_ROI.MGT_CC         IS 'Mobile Global Title Country Code';
COMMENT ON COLUMN GSMA_IP_RANGES_ROI.MGT_NC         IS 'Mobile Global Title Network Destination Code';
COMMENT ON COLUMN GSMA_IP_RANGES_ROI.COUNTRY        IS 'Country of Network Operator with the assigned TADIG code';
COMMENT ON COLUMN GSMA_GT_RANGES_ROI.RELATION_TYPE  IS 'Roaming Partner Relation Type: Valid values: 1 = Sponsored Roaming (TELE2), 2 = Home Network (TUK), 3 = Roam Hubbing (Comfone), 4 = Unilateral';
COMMENT ON COLUMN GSMA_IP_RANGES_ROI.INPUT_FILENAME IS 'This column is intended to reflect the source data set (file name) from which a particular row is created/updated.';

CREATE INDEX GSMA_IP_RANGES_ROI_IDX1 ON GSMA_IP_RANGES_ROI (IP_START DESC, IP_STOP ASC, EFF_DATE DESC);
CREATE INDEX GSMA_IP_RANGES_ROI_IDX2 ON GSMA_IP_RANGES_ROI (EFF_DATE DESC);
CREATE INDEX GSMA_IP_RANGES_ROI_IDX3 ON GSMA_IP_RANGES_ROI (TADIG ASC);
CREATE INDEX GSMA_IP_RANGES_ROI_IDX4 ON GSMA_IP_RANGES_ROI (TADIG ASC, IP_ADDRESS ASC, IP_START DESC, IP_STOP ASC, EFF_DATE DESC);

ALTER TABLE GSMA_IP_RANGES_ROI ADD CONSTRAINT GSMA_IP_RANGES_ROI_TADIG_FK 
	FOREIGN KEY (TADIG) REFERENCES GSMA_TADIG_ROI (TADIG);

ALTER TABLE GSMA_IP_RANGES_ROI ADD CONSTRAINT GSMA_IP_RANGES_ROI_RELATIONSHIP_FK
	FOREIGN KEY (RELATION_TYPE) REFERENCES GSMA_RELATIONSHIP (RELATIONID);

--

CREATE TABLE GSMA_CC_NDC_MAP2TADIG_ROI
(
	CC             VARCHAR2(10) NOT NULL,   -- Country code for E.164 formatted destination 
	NDC            VARCHAR2(20) NOT NULL,   -- Network Destination Code 
	TADIG          VARCHAR2(5)  NOT NULL,   -- This is the primary TADIG code assigned to a Mobile Operator by the GSMA. 
	INPUT_FILENAME VARCHAR2(50) NOT NULL    -- This column is intended to reflect the source data set (file name) from which a particular row is created/updated. 
);

COMMENT ON COLUMN GSMA_CC_NDC_MAP2TADIG_ROI.CC             IS 'Country code for E.164 formatted destination.';
COMMENT ON COLUMN GSMA_CC_NDC_MAP2TADIG_ROI.NDC            IS 'Network Destination Code.';
COMMENT ON COLUMN GSMA_CC_NDC_MAP2TADIG_ROI.TADIG          IS 'This is the primary TADIG code assigned to a Mobile Operator by the GSMA.';
COMMENT ON COLUMN GSMA_CC_NDC_MAP2TADIG_ROI.INPUT_FILENAME IS 'This column is intended to reflect the source data set (file name) from which a particular row is created/updated.';


CREATE INDEX GSMA_CC_NDC_MAP2TADIG_ROI_IDX1 ON GSMA_CC_NDC_MAP2TADIG_ROI (CC ASC, NDC ASC);
CREATE INDEX GSMA_CC_NDC_MAP2TADIG_ROI_IDX2 ON GSMA_CC_NDC_MAP2TADIG_ROI (TADIG ASC);
CREATE INDEX GSMA_CC_NDC_MAP2TADIG_ROI_IDX3 ON GSMA_CC_NDC_MAP2TADIG_ROI (CC ASC, NDC ASC, TADIG ASC);

ALTER TABLE GSMA_CC_NDC_MAP2TADIG_ROI ADD CONSTRAINT GSMA_CC_NDC_MAP2TADIG_ROI_TADIG_FK 
	FOREIGN KEY (TADIG) REFERENCES GSMA_TADIG_ROI (TADIG);
	
--

CREATE TABLE GSMA_MCC_MNC_MAP2TADIG_ROI
(
	MCC             VARCHAR2(3)          NOT NULL,   -- Mobile Country Code. 
	MNC             VARCHAR2(3)          NOT NULL,   -- Mobile Network Code. 
	TADIG           VARCHAR2(5)          NOT NULL,   -- TADIG Code of the owning Mobile Network. 
	COUNTRY         VARCHAR2(80)         NOT NULL,   -- Country of Network Operator with the assigned TADIG code 
	EFF_DATE        DATE DEFAULT SYSDATE NOT NULL,   -- Effective date of this entry. 
	INPUT_FILENAME  VARCHAR2(50)         NOT NULL    -- This column is intended to reflect the source data set (file name) from which a particular row is created/updated. 
);

COMMENT ON COLUMN GSMA_MCC_MNC_MAP2TADIG_ROI.MCC             IS 'Mobile Country Code.';
COMMENT ON COLUMN GSMA_MCC_MNC_MAP2TADIG_ROI.MNC             IS 'Mobile Network Code.';
COMMENT ON COLUMN GSMA_MCC_MNC_MAP2TADIG_ROI.TADIG           IS 'TADIG Code of the owning Mobile Network.';
COMMENT ON COLUMN GSMA_MCC_MNC_MAP2TADIG_ROI.COUNTRY         IS 'Country of Network Operator with the assigned TADIG code';
COMMENT ON COLUMN GSMA_MCC_MNC_MAP2TADIG_ROI.EFF_DATE        IS 'Effective date of this entry.';
COMMENT ON COLUMN GSMA_MCC_MNC_MAP2TADIG_ROI.INPUT_FILENAME  IS 'This column is intended to reflect the source data set (file name) from which a particular row is created/updated.';

CREATE INDEX GSMA_MCC_MNC_MAP2TADIG_ROI_IDX1 ON GSMA_MCC_MNC_MAP2TADIG_ROI (MCC ASC, MNC ASC);
CREATE INDEX GSMA_MCC_MNC_MAP2TADIG_ROI_IDX2 ON GSMA_MCC_MNC_MAP2TADIG_ROI (TADIG ASC);
CREATE INDEX GSMA_MCC_MNC_MAP2TADIG_ROI_IDX3 ON GSMA_MCC_MNC_MAP2TADIG_ROI (MCC ASC, MNC ASC, TADIG ASC);

ALTER TABLE GSMA_MCC_MNC_MAP2TADIG_ROI ADD CONSTRAINT GSMA_MCCMNC_MAP2TADIG_ROI_TADIG_FK
	FOREIGN KEY (TADIG) REFERENCES GSMA_TADIG_ROI (TADIG);


-- Dropping existing ROI table constraints that references GSMA_TADIG and recreating same constraints but this time referencing GSMA_TADIG_ROI
ALTER TABLE GSMA_GT_NODE_ROI DROP CONSTRAINT GSMA_GT_NODE_ROI_GSMA_TADIG_FK; 

ALTER TABLE GSMA_GT_NODE_ROI ADD CONSTRAINT GSMA_GT_NODE_ROI_GSMA_TADIG_FK 
	FOREIGN KEY (TADIG) REFERENCES GSMA_TADIG_ROI (TADIG);

ALTER TABLE GSMA_GT_RANGES_ROI DROP CONSTRAINT GSMA_GT_RANGES_ROI_TADIG_FK;

ALTER TABLE GSMA_GT_RANGES_ROI ADD CONSTRAINT GSMA_GT_RANGES_ROI_GSMA_TADIG_FK 
	FOREIGN KEY (TADIG) REFERENCES GSMA_TADIG_ROI (TADIG);