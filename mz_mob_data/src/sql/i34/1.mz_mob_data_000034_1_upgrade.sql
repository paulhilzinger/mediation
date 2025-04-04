-- MZMOB-433. Non-Camel calls that enter OCS TAPIN are shown with the incorrect chargecode in the despatch CDRs and Kenan billing suffers [amg]
-- creating table OCS_SPECIAL_NUMBER_LOOKUP
CREATE TABLE OCS_SPECIAL_NUMBER_LOOKUP
(
  SPECIAL_NUMBER VARCHAR2(64)  NOT NULL,
 DESCRIPTION VARCHAR2(100)
)
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

-- INSERTING THE RECORDS INTO  OCS_SPECIAL_NUMBER_LOOKUP
--  MZMOB-433. Non-Camel calls that enter OCS TAPIN are shown with the incorrect chargecode in the despatch CDRs and Kenan billing suffers 
    INSERT INTO OCS_SPECIAL_NUMBER_LOOKUP ( SPECIAL_NUMBER, DESCRIPTION)  VALUES ('441312783778', 'Sky Contact Centres');
	INSERT INTO OCS_SPECIAL_NUMBER_LOOKUP ( SPECIAL_NUMBER, DESCRIPTION)  VALUES ('44150', 'Sky Contact Centres');
	INSERT INTO OCS_SPECIAL_NUMBER_LOOKUP ( SPECIAL_NUMBER, DESCRIPTION)  VALUES ('443442414141', 'Sky Contact Centres');
	INSERT INTO OCS_SPECIAL_NUMBER_LOOKUP ( SPECIAL_NUMBER, DESCRIPTION)  VALUES ('447488222000', 'Voicemail');
	