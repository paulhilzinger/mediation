-- INSERTING THE OFFERING ID'S FOR RoW ROAMING PASS 
--  MZMOB-342. Process OCS MON files to enable the roaming daily pass requirement
    INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14537', 'Roaming Charge For Australia (inc. Christmas Island)','Australia/Canberra');
	INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14538', 'Roaming Charge For New Zealand','Pacific/Auckland');
	INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14539', 'Roaming Charge For South Africa','Africa/Johannesburg');
	INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14540', 'Roaming Charge For Canada','Canada/Eastern');
	INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14541', 'Roaming Charge For USA','America/New_York');
	INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14542', 'Roaming Charge For Thailand','Asia/Bangkok');
	INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14543', 'Roaming Charge For Turkey','Turkey');
	INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14544', 'Roaming Charge For Switzerland','Europe/Zurich');
	INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14545', 'Roaming Charge For UAE','Asia/Dubai');
	INSERT INTO OCS_MON_OFFERING_LOOKUP ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES ('14546', 'Roaming Charge For Qatar','Asia/Qatar');
    INSERT INTO OCS_MON_OFFERING_LOOKUP  ( OFFERING_ID, DESCRIPTION, TIMEZONE) VALUES  ('14547', 'Roaming Charge For Hong Kong','Asia/Hong_Kong');
	
-- INSERTING New Filter Reason record
	
	INSERT INTO MZ_FILTER_REASONS (FILTER_REASON_ID, DESCRIPTION) values (58,'Invalid Obj ID');
