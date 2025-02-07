-- MZITA-242 - Update the BICS row into the SKYIT_IBS_OLO table
--
UPDATE SKYIT_IBS_OLO 
   SET OLO = 'BIC'
 WHERE OLO = 'BICS';