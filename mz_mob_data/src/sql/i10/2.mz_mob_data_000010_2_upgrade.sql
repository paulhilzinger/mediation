-- INSERTING NEW FILTER REASON FOR MZMOB-254
-- Mediation Aborts if Chargecode is incorrectly structured
--
INSERT INTO MZ_FILTER_REASONS ( FILTER_REASON_ID,
DESCRIPTION ) VALUES (56, 'Invalid ChargeCodeInfo');
