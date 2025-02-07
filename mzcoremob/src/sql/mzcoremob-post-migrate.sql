CALL dar_owner.dar_synonym_manager.drop_synonyms('MZ_MOB_OWNER', 'FALSE', 'TRUE', 'MZ_MOB_ADMIN');
CALL dar_owner.dar_synonym_manager.create_synonyms('MZ_MOB_OWNER', 'FALSE', 'TRUE', 'MZ_MOB_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ_MOB_OWNER', 'FALSE', 'TRUE', 'MZ_MOB_ADMIN', 'MZ_MOB_ADMIN', 'MZ_MOB_ADMIN');
CALL dar_owner.dar_grant_manager.do_grants('MZ_MOB_OWNER', 'FALSE', 'TRUE', 'MZ_MOB_ROLE', 'MZ_MOB_ROLE', 'MZ_MOB_ROLE');