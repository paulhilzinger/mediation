-- Create a new business unit for NowTV
--
INSERT INTO MZ_CDR_OWNER.BUSINESS_UNITS VALUES (9, 'NOWTV');

-- Create a new business unit for Thunder
--
INSERT INTO MZ_CDR_OWNER.BUSINESS_UNITS VALUES (10, 'THUNDR');

-- Create a new business unit for the Contact Centre
INSERT INTO MZ_CDR_OWNER.BUSINESS_UNITS VALUES (11, 'CONTCT');

-- SQL to adjust a primary key constraint in the MZ_CDR_OWNER.DN_ENHANCED_BU_LOOKUP table - MZO-519
--
-- Drop the existing primary key
--
ALTER TABLE MZ_CDR_OWNER.DN_ENHANCED_BU_LOOKUP DROP PRIMARY KEY;


-- Drop the existing primary key unique index
--
DROP INDEX MZ_CDR_OWNER.DN_ENHANCED_BU_LOOKUP_PK;


-- Add new index that uses the directory number and unit id for the primary key
--
CREATE UNIQUE INDEX MZ_CDR_OWNER.DN_ENHANCED_BU_LOOKUP_PK 
  ON MZ_CDR_OWNER.DN_ENHANCED_BU_LOOKUP (DIRECTORY_NUMBER, UNIT_ID);


-- Add the new primary key using both DIRECTORY_NUMBER and UNIT_ID
--
ALTER TABLE MZ_CDR_OWNER.DN_ENHANCED_BU_LOOKUP ADD CONSTRAINT DN_ENHANCED_BU_LOOKUP_PK
  PRIMARY KEY  (DIRECTORY_NUMBER, UNIT_ID) 
  USING INDEX MZ_CDR_OWNER.DN_ENHANCED_BU_LOOKUP_PK;