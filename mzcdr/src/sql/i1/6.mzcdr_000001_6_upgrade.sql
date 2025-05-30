CREATE TABLE DN_BUSINESS_UNIT_LOOKUP 
( DIRECTORY_NUMBER VARCHAR2(40) NOT NULL,
  UNIT_ID NUMBER NOT NULL,
  START_DATE DATE );

CREATE UNIQUE INDEX DN_BUSINESS_UNIT_LOOKUP_PK ON DN_BUSINESS_UNIT_LOOKUP (DIRECTORY_NUMBER);

ALTER TABLE DN_BUSINESS_UNIT_LOOKUP 
ADD CONSTRAINT DN_BUSINESS_UNIT_LOOKUP_PK PRIMARY KEY (DIRECTORY_NUMBER);

CREATE INDEX DN_BUSINESS_UNIT_LOOKUP_FK1 ON DN_BUSINESS_UNIT_LOOKUP(UNIT_ID);

ALTER TABLE DN_BUSINESS_UNIT_LOOKUP
ADD (CONSTRAINT DN_BUSINESS_UNIT_LOOKUP_FK1 FOREIGN KEY (UNIT_ID) REFERENCES BUSINESS_UNITS (UNIT_ID));

--Create database link in MZN to NST
--
-- MED-515 - Edited to use the LT1NST DB link for enabling clean builds in DV
--           Removed all links as DBA needs to create these manually
--
--
--CREATE DATABASE LINK SNS_PENFOLD_DB_LINK
--CONNECT TO penfold_user IDENTIFIED BY enwit7yu
--USING 'NITRONST.IS.UK.EASYNET.NET';
--
--CREATE DATABASE LINK SNS_PENFOLD_DB_LINK.SNS.SKY.COM 
--CONNECT TO NSTREAM_MZN_USER IDENTIFIED BY XXX USING 'LT1NST.SNS.SKY.COM';

INSERT INTO BUSINESS_UNITS(UNIT_ID,UNIT_NAME)
VALUES (4,'STB');
