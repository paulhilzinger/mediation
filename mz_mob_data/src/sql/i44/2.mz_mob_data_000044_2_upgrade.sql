-- MZMOB-518 - Updating Sky SMSC SMSoLTE GT lookup table [amg]
-- As the old MIMNC and ENGLO GT addresses for SMSoWiFi are going to be used for the new MIMNC and ENGLO GT addresses for SMSoLTE, 
-- We have to implement with the old SMSoLTE addresses for the moment.

 
-- Updating SKY SMSC LTE GT NUMBERS FOR MIMNC AND ENGLO
--
update MZ_MOB_DATA_OWNER.SKY_SMSC_LTE_GT set GT = '447488200025' where GT = '447488200007';
update MZ_MOB_DATA_OWNER.SKY_SMSC_LTE_GT set GT = '447488200026' where GT = '447488200011';

