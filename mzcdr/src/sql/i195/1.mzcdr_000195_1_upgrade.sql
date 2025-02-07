-- MED-210 - Add mobile MSRNs to the DN_ENHANCED_BU_LOOKUP view
--

-- Create a new business unit for Sky Mobile MSRN numbers
--
INSERT INTO BUSINESS_UNITS VALUES (14, 'SKYMRN');


-- Create the new MSRN table
--
CREATE TABLE DN_BU_LOOKUP_MOBILE_MSRN 
(
  DIRECTORY_NUMBER  VARCHAR2(40),
  UNIT_ID           NUMBER,
  START_DATE        DATE,
  SKCI_FLAG         NUMBER,
  CEASE_DATE        DATE,
  CKCI_FLAG         NUMBER
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


-- Recreate the DN_ENHANCED_BU_LOOKUP view
--
CREATE OR REPLACE VIEW DN_ENHANCED_BU_LOOKUP AS
SELECT DIRECTORY_NUMBER, UNIT_ID, START_DATE, SKCI_FLAG, CEASE_DATE, CKCI_FLAG
  FROM DN_BU_LOOKUP_FIXED
 UNION ALL
SELECT DIRECTORY_NUMBER, UNIT_ID, START_DATE, SKCI_FLAG, CEASE_DATE, CKCI_FLAG
  FROM DN_BU_LOOKUP_MOBILE
 UNION ALL
SELECT DIRECTORY_NUMBER, UNIT_ID, START_DATE, SKCI_FLAG, CEASE_DATE, CKCI_FLAG
  FROM DN_BU_LOOKUP_MOBILE_MSRN;
  

-- Create indexes on the new DN_BU_LOOKUP_MOBILE_MSRN table
--
CREATE UNIQUE INDEX DN_BU_LOOKUP_MOBILE_MSRN_PK ON DN_BU_LOOKUP_MOBILE_MSRN (DIRECTORY_NUMBER, UNIT_ID);
 
CREATE INDEX DN_BU_LOOKUP_MOBILE_MSRN_FK1 ON DN_BU_LOOKUP_MOBILE_MSRN (UNIT_ID);


-- Create constraints on the new DN_BU_LOOKUP_MOBILE_MSRN table
--
ALTER TABLE DN_BU_LOOKUP_MOBILE_MSRN ADD CONSTRAINT DN_BU_LOOKUP_MOBILE_MSRN_PK PRIMARY KEY (DIRECTORY_NUMBER, UNIT_ID);

ALTER TABLE DN_BU_LOOKUP_MOBILE_MSRN ADD CONSTRAINT DN_BU_LOOKUP_MOBILE_MSRN_FK1 FOREIGN KEY (UNIT_ID) REFERENCES BUSINESS_UNITS (UNIT_ID);


-- Add new entries into the MSRN table
--
--BEGIN_PLSQL
BEGIN
   FOR i IN 10000 .. 21999
   LOOP
      INSERT INTO DN_BU_LOOKUP_MOBILE_MSRN (DIRECTORY_NUMBER, UNIT_ID) VALUES ( '074882' || i, 14 );
   END LOOP;
END;
/
--END_PLSQL
