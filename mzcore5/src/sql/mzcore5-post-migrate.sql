CALL dar_owner.dar_synonym_manager.drop_synonyms('MZ5_OWNER', 'FALSE', 'TRUE', 'MZ5_ADMIN');
CALL dar_owner.dar_synonym_manager.create_synonyms('MZ5_OWNER', 'FALSE', 'TRUE', 'MZ5_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ5_OWNER', 'FALSE', 'TRUE', 'MZ5_ADMIN', 'MZ5_ADMIN', 'MZ5_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ5_OWNER', 'FALSE', 'TRUE', 'MZ5_ROLE', 'MZ5_ROLE', 'MZ5_ROLE');
CALL dar_owner.dar_grant_manager.do_grants('MZ5_OWNER', 'FALSE', 'TRUE', 'MZ5_READONLY', 'MZ5_READONLY', 'MZ5_READONLY');
