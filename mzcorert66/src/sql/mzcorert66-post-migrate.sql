CALL dar_owner.dar_synonym_manager.drop_synonyms('MZ_R66_OWNER', 'FALSE', 'TRUE', 'MZ_R66_USER');
CALL dar_owner.dar_synonym_manager.create_synonyms('MZ_R66_OWNER', 'FALSE', 'TRUE', 'MZ_R66_USER');
CALL dar_owner.dar_grant_manager.do_grants('MZ_R66_OWNER', 'FALSE', 'TRUE');

