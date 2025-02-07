-- MZMOB-518 - Updating Sky SMSC SMSoLTE GT lookup table [amg]
-- As the old BLLON (DR) GT address for SMSoWiFi is going to be used for the BLLON (DR) GT address for SMSoLTE, 
-- We have to implement with the old SMSoLTE addresses for the moment.

 
-- Updating SKY SMSC LTE GT NUMBERS FOR BLLON (DR)
--
update MZ_MOB_DATA_OWNER.SKY_SMSC_LTE_GT set GT = '447488200024' where GT = '447488200001';
