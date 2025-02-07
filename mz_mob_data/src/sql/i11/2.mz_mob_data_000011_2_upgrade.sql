-- MZMOB-259 Add Auditing Control Checks to IGOR processing
-- Author: B Knowles 
-- Date: 1st December 2016

-- Create IGOR_History table
--

-- DROP TABLE IGOR_History CASCADE CONSTRAINTS; 2016-12-02. commented out due to error ruuning dbincl.pl [amg]
CREATE TABLE IGOR_History
(
	PERIOD_END_DATE    VARCHAR2(8) NOT NULL,    -- This is the Period End Date of the fiscal period that had just ended at the time the row was exported from the OCS platform. 
	CHECKPOINT_NUMBER  NUMBER(3) DEFAULT 0 NOT NULL,    -- This column provides a simple indicator of the checkpoint set that this row belongs to. Valid values are in the range 1 to 999. 
	PROCESS_TIME       DATE NOT NULL,    -- This is the timestamp that the row was inserted. 
	FILE_NAME          VARCHAR2(256) NOT NULL,    -- This is the name of the file that this data references. 
	ROW_COUNT          NUMBER(8) DEFAULT 0 NOT NULL, -- Number of records in the file.
	WORKFLOW_NAME      VARCHAR2(80) NOT NULL     
);

COMMENT ON TABLE IGOR_History IS 'This table will be used to store checkpoint information detailing files processed, record counts, processing date, period end date and workflow name that inserted the data';
COMMENT ON COLUMN IGOR_History.PERIOD_END_DATE    IS 'This is the Period End Date of the fiscal period that had just ended at the time the row was exported from the OCS platform.';
COMMENT ON COLUMN IGOR_History.CHECKPOINT_NUMBER  IS 'This column provides a simple indicator of the checkpoint set that this row belongs to. Valid values are in the range 1 to 999.';
COMMENT ON COLUMN IGOR_History.PROCESS_TIME       IS 'This is the timestamp that the row was inserted.';
COMMENT ON COLUMN IGOR_History.FILE_NAME          IS 'This is the name of the file that this data references.';
COMMENT ON COLUMN IGOR_History.WORKFLOW_NAME      IS 'Number of records in the file.';

CREATE INDEX IGOR_History_INDEX ON IGOR_History (PERIOD_END_DATE ASC, CHECKPOINT_NUMBER ASC);

CREATE INDEX FILENAME_INDEX ON IGOR_History (FILE_NAME ASC);

CREATE INDEX PERIOD_END_INDEX ON IGOR_History (PERIOD_END_DATE ASC);
