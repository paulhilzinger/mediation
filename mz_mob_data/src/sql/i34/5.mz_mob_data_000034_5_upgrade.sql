-- INSERTING THE RECORDS INTO  OCS_SPECIAL_NUMBER_LOOKUP
--  MZMOB-433. Non-Camel calls that enter OCS TAPIN are shown with the incorrect chargecode in the despatch CDRs and Kenan billing suffers 
 	INSERT INTO OCS_SPECIAL_NUMBER_LOOKUP ( SPECIAL_NUMBER, DESCRIPTION)  VALUES ('44759', 'Voicemail');
