CALL dar_owner.dar_synonym_manager.drop_synonyms('MZ7_OWNER', 'FALSE', 'TRUE', 'MZ7_ADMIN');
CALL dar_owner.dar_synonym_manager.create_synonyms('MZ7_OWNER', 'FALSE', 'TRUE', 'MZ7_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ7_OWNER', 'FALSE', 'TRUE', 'MZ7_ADMIN', 'MZ7_ADMIN', 'MZ7_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ7_OWNER', 'FALSE', 'TRUE', 'MZ7_ROLE', 'MZ7_ROLE', 'MZ7_ROLE');