-- MZMOB-470 Refactor MZ code written for MZMOB-441 to use a DB table to populate values for mapping [amg]
-- creating table OCS_PLM_MAPPING 
CREATE TABLE OCS_PLM_MAPPING 
(
  OCS_VALUE  VARCHAR2(64)  NOT NULL,
  OUTPUT_VALUE  VARCHAR2(64) NOT NULL
)
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

-- INSERTING THE RECORDS INTO  OCS_PLM_MAPPING
--  MZMOB-470 Refactor MZ code written for MZMOB-441 to use a DB table to populate values for mapping
		
    INSERT INTO OCS_PLM_MAPPING ( OCS_VALUE, OUTPUT_VALUE)  VALUES ('Martinique', 'French West Indies');
	INSERT INTO OCS_PLM_MAPPING ( OCS_VALUE, OUTPUT_VALUE)  VALUES ('Reunion', 'French Territories in the Indian Ocean');
	INSERT INTO OCS_PLM_MAPPING ( OCS_VALUE, OUTPUT_VALUE)  VALUES ('Guadeloupe', 'French West Indies');
	