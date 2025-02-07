CALL dar_owner.dar_synonym_manager.drop_synonyms('MZ_ITA_RTR_DATA_OWNER', 'FALSE', 'TRUE');
CALL dar_owner.dar_synonym_manager.create_synonyms('MZ_ITA_RTR_DATA_OWNER', 'FALSE', 'TRUE');
CALL dar_owner.dar_grant_manager.do_grants('MZ_ITA_RTR_DATA_OWNER', 'FALSE', 'TRUE');
