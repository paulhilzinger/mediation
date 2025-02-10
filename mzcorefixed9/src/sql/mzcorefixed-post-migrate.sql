CALL dar_owner.dar_synonym_manager.drop_synonyms('MZ_FIXED_OWNER', 'FALSE', 'TRUE', 'MZ_FIXED_ADMIN');
CALL dar_owner.dar_synonym_manager.create_synonyms('MZ_FIXED_OWNER', 'FALSE', 'TRUE', 'MZ_FIXED_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ_FIXED_OWNER', 'FALSE', 'TRUE', 'MZ_FIXED_ADMIN', 'MZ_FIXED_ADMIN', 'MZ_FIXED_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ_FIXED_OWNER', 'FALSE', 'TRUE', 'MZROLE', 'MZROLE', 'MZROLE');