-- MZMOB-433. Non-Camel calls that enter OCS TAPIN are shown with the incorrect chargecode in the despatch CDRs and Kenan billing suffers.Adding a new field into the table [amg]
-- Customer Services: The OCS Charge Code ID will need to be modified to “3008131100117” for “Sky Contact Centers” call.
-- Voice Mail: The OCS Charge Code ID will need to be modified to “3007131100141” for “Voicemail” call. 

ALTER TABLE OCS_SPECIAL_NUMBER_LOOKUP
ADD OCS_CHARGE_CODE_ID VARCHAR2(30 BYTE);

-- MZMOB-433. Non-Camel calls that enter OCS TAPIN are shown with the incorrect chargecode in the despatch CDRs and Kenan billing suffers [amg]
-- Customer Services: The OCS Charge Code ID will need to be modified to “3008131100117” for “Sky Contact Centers” call. 
-- Voice Mail: The OCS Charge Code ID will need to be modified to “3007131100141” for “Voicemail” call. 
  
UPDATE OCS_SPECIAL_NUMBER_LOOKUP set OCS_CHARGE_CODE_ID = '3008131100117' where DESCRIPTION = 'Sky Contact Centres';
UPDATE OCS_SPECIAL_NUMBER_LOOKUP set OCS_CHARGE_CODE_ID = '3007131100141' where DESCRIPTION = 'Voicemail';