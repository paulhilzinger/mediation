-- Upgrade script 1 for MZ5.0FR3 to MZ5.1 FR0. MZO-420
--

CREATE TABLE WF_QUEUE_STAT
(
    HOST_STAT_ID      NUMBER(9)     NOT NULL,
    CLIENT_NAME	      VARCHAR2(64)  NOT NULL,
    WF_NAME	      VARCHAR2(128) NOT NULL,
    ROUTE_NAME        VARCHAR(128)  NOT NULL,
    ROUTED_UDR_AVR    NUMERIC(19)   NOT NULL,
    ROUTED_UDR_MIN    NUMERIC(19)   NOT NULL,
    ROUTED_UDR_MAX    NUMERIC(19)   NOT NULL,
    QUEUE_SIZE        NUMERIC(19)   NOT NULL,
    UDR_ON_QUEUE_AVR  NUMERIC(19)   NOT NULL,
    UDR_ON_QUEUE_MIN  NUMERIC(19)   NOT NULL,
    UDR_ON_QUEUE_MAX  NUMERIC(19)   NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX WF_QUEUE_STAT_HOSTID_IDX ON WF_QUEUE_STAT
(HOST_STAT_ID)
LOGGING
NOPARALLEL;

CREATE INDEX WF_QUEUE_STAT_NAME_IDX ON WF_QUEUE_STAT
(WF_NAME)
LOGGING
NOPARALLEL;

ALTER TABLE WF_QUEUE_STAT ADD (
   CONSTRAINT FK_WF_QUEUE_STAT_HOST_ID
  FOREIGN KEY (HOST_STAT_ID)   
  REFERENCES HOST_STAT(ID) 
     ON DELETE CASCADE);

-- Upgrade script 2 for MZ5.0FR3 to MZ5.1 FR0. MZO-420
--
CREATE SYNONYM MZ5_ADMIN.WF_QUEUE_STAT FOR MZ5_OWNER.WF_QUEUE_STAT;
CREATE SYNONYM MZ_SUPPORT_USER.WF_QUEUE_STAT FOR MZ5_OWNER.WF_QUEUE_STAT;


-- Upgrade script 3 for MZ5.0FR3 to MZ5.1 FR0. MZO-420
--
GRANT SELECT, UPDATE, INSERT, DELETE ON WF_QUEUE_STAT TO MZ5_ROLE;
GRANT SELECT, UPDATE, INSERT, DELETE ON WF_QUEUE_STAT TO MZ5_ADMIN;
GRANT SELECT, UPDATE, INSERT, DELETE ON WF_QUEUE_STAT TO MZ5_READONLY;


-- Upgrade script 4 for MZ5.0FR3 to MZ5.1 FR0. MZO-420
--

ALTER TABLE DEFAULT_DUPBATCH RENAME CONSTRAINT PK_DEFAULT_DUPBATCH TO PK_DEFAULT_DUPBATCH_OLD;
ALTER TABLE DEFAULT_DUPBATCH RENAME TO DEFAULT_DUPBATCH_OLD;


CREATE TABLE DEFAULT_DUPBATCH (
       ID 	    NUMBER         NOT NULL,
       TXN 	    NUMBER         NOT NULL,
       TIMESTAMP    DATE           NOT NULL,
       CRC          NUMBER         NOT NULL,
       LOGGED_MIMS  VARCHAR2(4000) NULL,
       TXN_SAFE     NUMBER(1) DEFAULT 0 NOT NULL,
       PROFILE 	    VARCHAR2(64)   NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

ALTER TABLE DEFAULT_DUPBATCH ADD (
   CONSTRAINT PK_DEFAULT_DUPBATCH_ID
  PRIMARY KEY
  (ID));


-- Sequence and Auto increment trigger.
--
CREATE SEQUENCE DEFAULT_DUPBATCH_SEQ
   START WITH 1
   INCREMENT BY 1
   NOMAXVALUE;


--BEGIN_PLSQL
CREATE OR REPLACE TRIGGER DEFAULT_DUPBATCH_TRIGGER
       BEFORE INSERT ON DEFAULT_DUPBATCH
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW       
DECLARE ind Integer;
   BEGIN
        SELECT DEFAULT_DUPBATCH_SEQ.NEXTVAL INTO ind FROM DUAL;
        :NEW.id := ind;
   END;
/
--END_PLSQL


INSERT INTO DEFAULT_DUPBATCH
     ( TXN,
       TIMESTAMP,
       CRC,
       LOGGED_MIMS,
       TXN_SAFE,
       PROFILE ) 
       SELECT ID AS TXN,
              TIMESTAMP,
              CRC,
              LOGGED_MIMS,
              TXN_SAFE,
              PROFILE
       FROM DEFAULT_DUPBATCH_OLD;


-- Remove the old table
--
ALTER TABLE DEFAULT_DUPBATCH_OLD DROP CONSTRAINT PK_DEFAULT_DUPBATCH_OLD;
DROP TABLE DEFAULT_DUPBATCH_OLD;

--
CREATE INDEX DEFAULT_DUPBATCH_TIME_IDX ON DEFAULT_DUPBATCH
(PROFILE, TIMESTAMP)
LOGGING
NOPARALLEL;

CREATE INDEX DEFAULT_DUPBATCH_CRC_IDX ON DEFAULT_DUPBATCH
(CRC)
LOGGING
NOPARALLEL;

--
GRANT SELECT, UPDATE, INSERT, DELETE ON DEFAULT_DUPBATCH TO MZ5_ROLE;

GRANT SELECT, UPDATE, INSERT, DELETE ON DEFAULT_DUPBATCH TO MZ5_ADMIN;

GRANT SELECT, UPDATE, INSERT, DELETE ON DEFAULT_DUPBATCH TO MZ5_READONLY;
