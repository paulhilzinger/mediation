-- MZMOB-193 BK 2016-10-10 - Replacing multiple control variables with a single variables
-- that is used to control duplicate checking
delete from MZ_CONFIGURATION
  where PARAMETER like 'DUP_BATCH_CHECK_BC_%'
     or PARAMETER like 'DUP_BATCH_CHECK_PE_%';
