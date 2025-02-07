CALL dar_owner.dar_synonym_manager.drop_synonyms('MZ_ITA_RTR_OWNER', 'FALSE', 'TRUE', 'MZ_ITA_RTR_ADMIN');
CALL dar_owner.dar_synonym_manager.create_synonyms('MZ_ITA_RTR_OWNER', 'FALSE', 'TRUE', 'MZ_ITA_RTR_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ_ITA_RTR_OWNER', 'FALSE', 'TRUE', 'MZ_ITA_RTR_ADMIN', 'MZ_ITA_RTR_ADMIN', 'MZ_ITA_RTR_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ_ITA_RTR_OWNER', 'FALSE', 'TRUE', 'MZ_ITA_RTR_ROLE', 'MZ_ITA_RTR_ROLE', 'MZ_ITA_RTR_ROLE');