--MZMOB-604 - Need to widen GT fields. Before that, need to make a copy of the tables, so we don't lose data

---- Recreate the table with the original function indices and constraints but this time with wider GT fields. This means renaming table, indexes and constraints with "*_OLD"
---- to keep the same names.

----First GT_NODE
RENAME GSMA_GT_NODE TO GSMA_GT_NODE_OLD;

CREATE TABLE GSMA_GT_NODE
(
	GT_START       VARCHAR2(30),                  -- This column identifies the start of a Global Title Range of Network Nodes owned by a network. 
	GT_STOP        VARCHAR2(30),                  -- This column identifies the end of a Global Title Range of Network Nodes owned by a network. 
	IP_START       NUMBER(15),                    -- Numeric equivalent of an IP version 4 address. Start of range. 
	IP_STOP        NUMBER(15),                    -- Numeric equivalent of an IP version 4 address. End of range 
	IP_ADDRESS     VARCHAR2(18),                  -- Keep this for information purposes. 
	TADIG          VARCHAR2(5)          NOT NULL, -- TADIG Code identifier of the owning network 
	EFF_DATE       DATE DEFAULT SYSDATE NOT NULL, -- Date the Roaming agreement is deemed to become effective. Note that this could have been inferred from the date when notification of the TADIG code is included in the data received from RoamSmart for the first time. i.e there is margin for error. 
	LOCATION       VARCHAR2(80),                  -- Supplemental location supplied by some operators (optional). 
	NODE_TYPE      VARCHAR2(30),                  -- Type of Node for this global title. 
	MOD_TADIG      VARCHAR2(5),                   -- Alternative TADIG Code. Initial intention is to use this to override the Channel Island TADIG codes with a unique value to identify which island is visited. 
	MGT_CC         VARCHAR2(10)         NOT NULL, -- Mobile Global Title Country Code 
	MGT_NC         VARCHAR2(10)         NOT NULL, -- Mobile Global Title Network Destination Code 
	COUNTRY        VARCHAR2(80)         NOT NULL, -- Country of Network Operator with the assigned TADIG code 
	RELATION_TYPE  NUMBER(3) DEFAULT 1  NOT NULL, -- Roaming Partner Relation Type: Valid values: 1 = Sponsored Roaming (TELE2), 2 = Home Network (TUK), 3 = Roam Hubbing (Comfone), 4 = Unilateral
	GT_RANGE_START VARCHAR2(30),                  -- This column identifies the start of a Global Title Range of Network Nodes owned by a network. (No Padding)
	GT_RANGE_STOP  VARCHAR2(30),                  -- This column identifies the end of a Global Title Range of Network Nodes owned by a network. (No Padding)
	INPUT_FILENAME VARCHAR2(50)         NOT NULL  -- This column is intended to reflect the source data set (file name) from which a particular row is created/updated. 
);

COMMENT ON TABLE GSMA_GT_NODE IS 'This table stores the IP address and Global Title and network node type details published in the IR.21 document that may be interacted by a third party network.';
COMMENT ON COLUMN GSMA_GT_NODE.GT_START       IS 'This column identifies the start of a Global Title Range of Network Nodes owned by a network.';
COMMENT ON COLUMN GSMA_GT_NODE.GT_STOP        IS 'This column identifies the end of a Global Title Range of Network Nodes owned by a network.';
COMMENT ON COLUMN GSMA_GT_NODE.IP_START       IS 'Numeric equivalent of an IP version 4 address. Start of range.';
COMMENT ON COLUMN GSMA_GT_NODE.IP_STOP        IS 'Numeric equivalent of an IP version 4 address. End of range'; 
COMMENT ON COLUMN GSMA_GT_NODE.IP_ADDRESS     IS 'Keep this for information purposes.';
COMMENT ON COLUMN GSMA_GT_NODE.TADIG          IS 'TADIG Code identifier of the owning network';
COMMENT ON COLUMN GSMA_GT_NODE.LOCATION       IS 'Supplemental location supplied by some operators (optional).';
COMMENT ON COLUMN GSMA_GT_NODE.NODE_TYPE      IS 'Type of Node for this global title.';
COMMENT ON COLUMN GSMA_GT_NODE.MOD_TADIG      IS 'Alternative TADIG Code. Initial intention is to use this to override the Channel Island TADIG codes with a unique value to identify which island is visited.';
COMMENT ON COLUMN GSMA_GT_NODE.MGT_CC         IS 'Mobile Global Title Country Code';
COMMENT ON COLUMN GSMA_GT_NODE.MGT_NC         IS 'Mobile Global Title Network Destination Code';
COMMENT ON COLUMN GSMA_GT_NODE.COUNTRY        IS 'Country of Network Operator with the assigned TADIG code';
COMMENT ON COLUMN GSMA_GT_NODE.EFF_DATE       IS 'Date from which this row is effective.';
COMMENT ON COLUMN GSMA_GT_NODE.RELATION_TYPE  IS 'Roaming Partner Relation Type: Valid values: 1 = Sponsored Roaming (TELE2), 2 = Home Network (TUK), 3 = Roam Hubbing (Comfone), 4 = Unilateral';
COMMENT ON COLUMN GSMA_GT_NODE.INPUT_FILENAME IS 'This column is intended to reflect the source data set (file name) from which a particular row is created/updated.';

-- Rename original indexes
ALTER INDEX GSMA_GT_NODE_IDX1 RENAME TO GSMA_GT_NODE_IDX1_OLD;
ALTER INDEX GSMA_GT_NODE_IDX2 RENAME TO GSMA_GT_NODE_IDX2_OLD;
ALTER INDEX GSMA_GT_NODE_IDX3 RENAME TO GSMA_GT_NODE_IDX3_OLD;
ALTER INDEX GSMA_GT_NODE_IDX4 RENAME TO GSMA_GT_NODE_IDX4_OLD;
ALTER INDEX GSMA_GT_NODE_IDX5 RENAME TO GSMA_GT_NODE_IDX5_OLD;
ALTER INDEX GSMA_GT_NODE_IDX6 RENAME TO GSMA_GT_NODE_IDX6_OLD;

--Create same indexes for GT_NODE
CREATE INDEX GSMA_GT_NODE_IDX1 ON GSMA_GT_NODE (GT_START DESC, GT_STOP ASC, EFF_DATE DESC);
CREATE INDEX GSMA_GT_NODE_IDX2 ON GSMA_GT_NODE (IP_START DESC, IP_STOP ASC, EFF_DATE DESC);
CREATE INDEX GSMA_GT_NODE_IDX3 ON GSMA_GT_NODE (EFF_DATE DESC);
CREATE INDEX GSMA_GT_NODE_IDX4 ON GSMA_GT_NODE (TADIG ASC);
CREATE INDEX GSMA_GT_NODE_IDX5 ON GSMA_GT_NODE (TADIG ASC, GT_START DESC, GT_STOP ASC, IP_START DESC, IP_STOP ASC, IP_ADDRESS ASC, LOCATION ASC, NODE_TYPE ASC, MOD_TADIG ASC, EFF_DATE DESC);
CREATE INDEX GSMA_GT_NODE_IDX6 ON GSMA_GT_NODE (GT_RANGE_START DESC, GT_RANGE_STOP ASC, EFF_DATE DESC);

--rename original contraints
ALTER TABLE GSMA_GT_NODE_OLD RENAME CONSTRAINT GSMA_GT_NODE_GSMA_TADIG_FK TO GSMA_GT_NODE_GSMA_TADIG_FK_OLD;
ALTER TABLE GSMA_GT_NODE_OLD RENAME CONSTRAINT GSMA_GT_NODE_RELATIONSHIP_FK TO GSMA_GT_NODE_RELATION_FK_OLD;

--create the same constraints for GT_NODE
ALTER TABLE GSMA_GT_NODE ADD CONSTRAINT GSMA_GT_NODE_GSMA_TADIG_FK
	FOREIGN KEY (TADIG) REFERENCES GSMA_TADIG (TADIG);

ALTER TABLE GSMA_GT_NODE ADD CONSTRAINT GSMA_GT_NODE_RELATIONSHIP_FK
	FOREIGN KEY (RELATION_TYPE) REFERENCES GSMA_RELATIONSHIP (RELATIONID);

---- Do the same for GT_RANGES

---- Rename table
rename GSMA_GT_RANGES TO GSMA_GT_RANGES_OLD;

CREATE TABLE GSMA_GT_RANGES
(
	GT_START       VARCHAR2(30)           NOT NULL, -- This column identifies the start of a Global Title Range of Network Nodes owned by a network.
	GT_STOP        VARCHAR2(30)           NOT NULL, -- This column identifies the end of a Global Title Range of Network Nodes owned by a network.
	TADIG          VARCHAR2(5)            NOT NULL, -- TADIG Code identifier of the owning network
	EFF_DATE       DATE DEFAULT SYSDATE   NOT NULL, -- Effective date.
	MGT_CC         VARCHAR2(10)           NOT NULL, -- Mobile Global Title Country Code
	MGT_NC         VARCHAR2(10)           NOT NULL, -- Mobile Global Title Network Destination Code
	COUNTRY        VARCHAR2(80)           NOT NULL, -- Country of Network Operator with the assigned TADIG code
	RELATION_TYPE  NUMBER(3)    DEFAULT 1 NOT NULL, -- Roaming Partner Relation Type: Valid values: 1 = Sponsored Roaming (TELE2), 2 = Home Network (TUK), 3 = Roam Hubbing (Comfone), 4 = Unilateral
	INPUT_FILENAME VARCHAR2(50)           NOT NULL  -- This column is intended to reflect the source data set (file name) from which a particular row is created/updated.
);

COMMENT ON TABLE GSMA_GT_RANGES IS 'This table stores the Global Title Range information of a Mobile Networks network nodes.';
COMMENT ON COLUMN GSMA_GT_RANGES.GT_START       IS 'This column identifies the start of a Global Title Range of Network Nodes owned by a network.';
COMMENT ON COLUMN GSMA_GT_RANGES.GT_STOP        IS 'This column identifies the end of a Global Title Range of Network Nodes owned by a network.';
COMMENT ON COLUMN GSMA_GT_RANGES.TADIG          IS 'TADIG Code identifier of the owning network';
COMMENT ON COLUMN GSMA_GT_RANGES.EFF_DATE       IS 'Effective date. ';
COMMENT ON COLUMN GSMA_GT_RANGES.MGT_CC         IS 'Mobile Global Title Country Code';
COMMENT ON COLUMN GSMA_GT_RANGES.MGT_NC         IS 'Mobile Global Title Network Destination Code';
COMMENT ON COLUMN GSMA_GT_RANGES.COUNTRY        IS 'Country of Network Operator with the assigned TADIG code';
COMMENT ON COLUMN GSMA_GT_RANGES.RELATION_TYPE  IS 'Roaming Partner Relation Type: Valid values: 1 = Sponsored Roaming (TELE2), 2 = Home Network (TUK), 3 = Roam Hubbing (Comfone), 4 = Unilateral';
COMMENT ON COLUMN GSMA_GT_RANGES.INPUT_FILENAME IS 'This column is intended to reflect the source data set (file name) from which a particular row is created/updated.';

---- Rename original indexes for GT_RANGES
ALTER INDEX GSMA_GT_RANGES_IDX1 RENAME TO GSMA_GT_RANGES_IDX1_OLD;
ALTER INDEX GSMA_GT_RANGES_IDX2 RENAME TO GSMA_GT_RANGES_IDX2_OLD;
ALTER INDEX GSMA_GT_RANGES_IDX3 RENAME TO GSMA_GT_RANGES_IDX3_OLD;
ALTER INDEX GSMA_GT_RANGES_IDX4 RENAME TO GSMA_GT_RANGES_IDX4_OLD;

---- create same indexes for GT_RANGES
CREATE INDEX GSMA_GT_RANGES_IDX1 ON GSMA_GT_RANGES (GT_START DESC, GT_STOP ASC, EFF_DATE DESC);
CREATE INDEX GSMA_GT_RANGES_IDX2 ON GSMA_GT_RANGES (EFF_DATE DESC);
CREATE INDEX GSMA_GT_RANGES_IDX3 ON GSMA_GT_RANGES (TADIG ASC);
CREATE INDEX GSMA_GT_RANGES_IDX4 ON GSMA_GT_RANGES (TADIG ASC, GT_START DESC, GT_STOP ASC, EFF_DATE DESC);

---- rename original contraints for GT_RANGES
ALTER TABLE GSMA_GT_RANGES_OLD RENAME CONSTRAINT GSMA_GT_RANGES_TADIG_FK TO GSMA_GT_RANGES_TADIG_FK_OLD;
ALTER TABLE GSMA_GT_RANGES_OLD RENAME CONSTRAINT GSMA_GT_RANGES_RELATIONSHIP_FK TO GSMA_GT_RANGES_RELATION_FK_OLD;

---- create same contraints for GT_RANGES
ALTER TABLE GSMA_GT_RANGES ADD CONSTRAINT GSMA_GT_RANGES_TADIG_FK 
	FOREIGN KEY (TADIG) REFERENCES GSMA_TADIG (TADIG);

ALTER TABLE GSMA_GT_RANGES ADD CONSTRAINT GSMA_GT_RANGES_RELATIONSHIP_FK
	FOREIGN KEY (RELATION_TYPE) REFERENCES GSMA_RELATIONSHIP (RELATIONID);

---- Finally copy the data over to the newly created tables.
INSERT /*+ append */ INTO GSMA_GT_NODE (SELECT * FROM GSMA_GT_NODE_OLD);
INSERT /*+ append */ INTO GSMA_GT_RANGES (SELECT * FROM GSMA_GT_RANGES_OLD);

