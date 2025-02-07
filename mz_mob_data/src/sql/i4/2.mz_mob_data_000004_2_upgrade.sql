-- Dup batch check configuration for TAP - MZMOB-109
--
Insert into MZ_CONFIGURATION
   (PARAMETER, PARAMETER_VALUE)
 Values
   ('TAP_DUP_BATCH_CHECK', 1); 
