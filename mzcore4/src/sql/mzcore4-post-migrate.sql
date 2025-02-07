CALL dar_owner.dar_synonym_manager.drop_synonyms('MZ_OWNER', 'FALSE', 'TRUE', 'MZ_ADMIN');
CALL dar_owner.dar_synonym_manager.create_synonyms('MZ_OWNER', 'FALSE', 'TRUE', 'MZ_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ_OWNER', 'FALSE', 'TRUE', 'MZ_ADMIN', 'MZ_ADMIN', 'MZ_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ_OWNER', 'FALSE', 'TRUE', 'MZROLE', 'MZROLE', 'MZROLE');

