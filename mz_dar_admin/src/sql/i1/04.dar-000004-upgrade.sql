----------------------------------------
-- Company : Easynet UK
-- Project : dar
-- Author  : Lucy Jeffs
-- Version : Upgrade Delta 000001
----------------------------------------

--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE dar_owner.dar_synonym_manager
AUTHID CURRENT_USER
AS
/********************************************************************************
   NAME:       dar_synonym_manager
   TYPE:       PL/SQL Package Body
   PURPOSE:    Drops and creates synonyms for Netstream schemas

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------
   1.0        06/12/2006  LEJ              Initial Version.
   1.3        03/05/2007  LEJ              Change parameter type to varchar2
   1.4        25/06/2007  LEJ              Add synonym_user parameter
*********************************************************************************/

PROCEDURE create_synonyms
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_synonym_user IN varchar2 default NULL
  );

PROCEDURE drop_synonyms
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_synonym_user IN varchar2 default NULL
  );

PROCEDURE create_all_nstr_synonyms
  (
   p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  );

PROCEDURE drop_all_nstr_synonyms
  (
   p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  );

PROCEDURE synonym_engine
  (
   p_schema_name IN varchar2
  ,p_type IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_synonym_user IN varchar2 default NULL
  );

END dar_synonym_manager;
/
--END_PLSQL

--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE BODY dar_owner.dar_synonym_manager
AS
/********************************************************************************
   NAME:       dar_synonym_manager
   TYPE:       PL/SQL Package Body
   PURPOSE:    Grants permissions for Netstream schemas to appropriate roles

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------
   1.0        06/12/2006  LEJ              Initial Version.                                             
   1.1        12/03/2006  LEJ              Improved vetting of executing user
   1.3        03/05/2007  LEJ              Change parameter type to varchar2
   1.4        25/06/2007  LEJ              Add synonym_user parameter
*********************************************************************************/

  PROCEDURE create_synonyms
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_synonym_user IN varchar2 default NULL
  )
  IS
  BEGIN
    dar_synonym_manager.synonym_engine(p_schema_name, 'CREATE', p_show_sql, p_exec_sql, p_synonym_user);
  END create_synonyms;

  PROCEDURE drop_synonyms
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_synonym_user IN varchar2 default NULL
  )
  IS
  BEGIN
    dar_synonym_manager.synonym_engine(p_schema_name, 'DROP', p_show_sql, p_exec_sql, p_synonym_user);
  END drop_synonyms;

  PROCEDURE synonym_engine
  (
   p_schema_name IN varchar2
  ,p_type        IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_synonym_user IN varchar2 default NULL
  )
  IS

  ------------------------------------------------------------------
  -- Local variables for identifying schema name
  ------------------------------------------------------------------
  l_schema    VARCHAR2(30)   := UPPER(NVL(p_schema_name , USER));
  --  use l_suffix_length to strip the _OWNER from the schema name
  l_suffix_length NUMBER     := 6;
  l_main_user VARCHAR2(30)   := SUBSTR(l_schema, 1, LENGTH( l_schema ) - l_suffix_length);
  l_synonym_user VARCHAR2(30):= UPPER(NVL(p_synonym_user, l_main_user||'_USER'));
  l_statement VARCHAR2(500);
  l_err_code  NUMBER;
  l_err_msg   VARCHAR2(200);

  CURSOR c_gen_synonyms
  IS 
    SELECT object_name
    FROM   all_objects 
    WHERE  object_type IN ( 'TABLE', 'VIEW', 'SEQUENCE' )
    AND    owner = l_schema
    AND    object_name NOT LIKE 'BIN%'
    AND    object_name NOT LIKE '%$%';

BEGIN
  -- First make sure the executor is a valid one
  IF USER NOT IN ('SYS','SYSTEM', 'XCOM_XTNS', p_schema_name)
  THEN 

    RAISE_APPLICATION_ERROR ( -20010, 'User '||USER||' not permitted to execute this procedure for schema '|| p_schema_name);

  END IF;

  IF p_type = 'CREATE'
  THEN
    -- Create Synonyms.
    FOR r_gen_synonyms IN c_gen_synonyms
    LOOP
      BEGIN

        l_statement := 'CREATE SYNONYM '||l_synonym_user||'.'||r_gen_synonyms.object_name ||' FOR '||l_schema||'.'||r_gen_synonyms.object_name ;

        IF p_show_sql = 'TRUE'
        THEN
          DBMS_OUTPUT.PUT_LINE ( l_statement );
        END IF;

        IF p_exec_sql = 'TRUE'
        THEN
          EXECUTE IMMEDIATE ( l_statement );
        END IF;

      EXCEPTION

        WHEN OTHERS
        THEN
        l_err_code := SQLCODE;
        l_err_msg := substr(SQLERRM, 1, 200);
        IF l_err_code IN ( -1434, -955)
        THEN
          NULL;
        ELSE
          RAISE;
        END IF;

      END;
  
    END LOOP;

  ELSIF p_type = 'DROP'
  THEN
    -- Drop Synonyms.
    FOR r_gen_synonyms IN c_gen_synonyms
    LOOP

      BEGIN

        l_statement := 'DROP SYNONYM '||l_synonym_user||'.'||r_gen_synonyms.object_name ;

        IF p_show_sql = 'TRUE'
        THEN
          DBMS_OUTPUT.PUT_LINE ( l_statement );
        END IF;

        IF p_exec_sql = 'TRUE'
        THEN
          EXECUTE IMMEDIATE ( l_statement );
        END IF;

      EXCEPTION

        WHEN OTHERS
        THEN
          l_err_code := SQLCODE;
        IF l_err_code IN ( -1434, -955)
        THEN
          NULL;
        ELSE
          DBMS_OUTPUT.PUT_LINE('Error code ' || l_err_code );
        END IF;

      END;
  
    END LOOP;

  END IF;

  
  END synonym_engine;

  PROCEDURE create_all_nstr_synonyms
  (
   p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  )
  IS
  ------------------------------------------------------------------
  -- Local variables 
  ------------------------------------------------------------------
  TYPE l_schema_list IS TABLE OF VARCHAR2(30);
  l_schemas l_schema_list;
  BEGIN
    l_schemas := l_schema_list ('HECTOR_OWNER', 'LLUSPLUS_OWNER', 
                          'PENFOLD_OWNER', 'SWISH_OWNER', 'XENA_OWNER',
                          'MEDIATION_OWNER', 'BTBILL_OWNER');

    FOR i IN l_schemas.FIRST..l_schemas.LAST
    LOOP
      dar_synonym_manager.create_synonyms(l_schemas(i), p_show_sql, p_exec_sql);
    END LOOP;

  END create_all_nstr_synonyms;

  PROCEDURE drop_all_nstr_synonyms
  (
   p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  )
  IS
  ------------------------------------------------------------------
  -- Local variables
  ------------------------------------------------------------------
  TYPE l_schema_list IS TABLE OF VARCHAR2(30);
  l_schemas l_schema_list;
  BEGIN
    l_schemas := l_schema_list ('HECTOR_OWNER', 'LLUSPLUS_OWNER', 
                          'PENFOLD_OWNER', 'SWISH_OWNER', 'XENA_OWNER',
                          'MEDIATION_OWNER', 'BTBILL_OWNER');
    FOR i IN l_schemas.FIRST..l_schemas.LAST
    LOOP
      dar_synonym_manager.drop_synonyms(l_schemas(i), p_show_sql, p_exec_sql);
    END LOOP;

  END drop_all_nstr_synonyms;

END dar_synonym_manager;
/
--END_PLSQL
GRANT execute on dar_owner.dar_synonym_manager to public;
