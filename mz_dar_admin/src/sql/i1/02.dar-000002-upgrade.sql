----------------------------------------
-- Company : Easynet UK
-- Project : dar
-- Author  : Lucy Jeffs
-- Version : Upgrade Delta 000002
----------------------------------------

--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE dar_owner.dar_grant_manager
AUTHID CURRENT_USER
AS
/********************************************************************************
   NAME:       dar_grant_manager
   TYPE:       PL/SQL Package Body
   PURPOSE:    Grants permissions for Netstream schemas to appropriate roles

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------
   1.0        23/10/2006  LEJ              Initial Version.                                             
   1.3        03/05/2007  LEJ              Change parameter type to varchar2
   1.4        22/05/2007  LEJ              Add grantee parameters
*********************************************************************************/

PROCEDURE do_grants
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_readonly_grantee IN varchar2 default NULL
  ,p_update_grantee IN varchar2 default NULL
  ,p_execute_grantee IN varchar2 default NULL
  );

PROCEDURE do_revoke
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_readonly_grantee IN varchar2 default NULL
  ,p_update_grantee IN varchar2 default NULL
  ,p_execute_grantee IN varchar2 default NULL
  );

PROCEDURE grant_all_nstr
  (
   p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  );

PROCEDURE revoke_all_nstr
  (
   p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  );

PROCEDURE grant_engine
  (
  p_schema_name IN varchar2
  ,p_type IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_readonly_grantee IN varchar2 default NULL
  ,p_update_grantee IN varchar2 default NULL
  ,p_execute_grantee IN varchar2 default NULL
  );

END dar_grant_manager;
/
--END_PLSQL

--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE BODY DAR_OWNER.dar_grant_manager
AS
/********************************************************************************
   NAME:       dar_grant_manager
   TYPE:       PL/SQL Package Body
   PURPOSE:    Grants permissions for Netstream schemas to appropriate roles

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------
   1.0        23/10/2006  LEJ              Initial Version.
   1.1        12/03/2006  LEJ              Improved vetting of executing user
   1.2        03/04/2007  OJT              Can skip invalid views and keep going!
   1.3        03/05/2007  LEJ              Change parameter type to varchar2
   1.4        22/05/2007  LEJ              Add grantee parameters
*********************************************************************************/

  PROCEDURE do_grants
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_readonly_grantee IN varchar2 default NULL
  ,p_update_grantee IN varchar2 default NULL
  ,p_execute_grantee IN varchar2 default NULL
  )
  IS
  BEGIN
    dar_grant_manager.grant_engine(p_schema_name, 'GRANT', p_show_sql, p_exec_sql, p_readonly_grantee, p_update_grantee, p_execute_grantee);
  END do_grants;

  PROCEDURE do_revoke
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_readonly_grantee IN varchar2 default NULL
  ,p_update_grantee IN varchar2 default NULL
  ,p_execute_grantee IN varchar2 default NULL
  )
  IS
  BEGIN
    dar_grant_manager.grant_engine(p_schema_name, 'REVOKE', p_show_sql, p_exec_sql, p_readonly_grantee, p_update_grantee, p_execute_grantee);
  END do_revoke;

  PROCEDURE grant_engine
  (
   p_schema_name IN varchar2
  ,p_type        IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  ,p_readonly_grantee IN varchar2 default NULL
  ,p_update_grantee IN varchar2 default NULL
  ,p_execute_grantee IN varchar2 default NULL
  )
  IS

  ------------------------------------------------------------------
  -- Local variables for identifying schema name
  ------------------------------------------------------------------
  l_schema    VARCHAR2(30)   := UPPER(NVL(p_schema_name , USER));
  --  use l_suffix_length to strip the _OWNER from the schema name
  l_suffix_length NUMBER     := 6;
  l_main_user VARCHAR2(30)   := SUBSTR(l_schema, 1, LENGTH( l_schema ) - l_suffix_length);
  l_readonly_grantee VARCHAR2(30):= UPPER(NVL(p_readonly_grantee, l_main_user||'_READONLY'));
  l_update_grantee   VARCHAR2(30):= UPPER(NVL(p_update_grantee, l_main_user||'_UPDATE'));
  l_execute_grantee  VARCHAR2(30):= UPPER(NVL(p_execute_grantee, l_main_user||'_EXECUTE'));
  l_action    VARCHAR2(10);
  l_action_prep VARCHAR2(10);
  l_statement VARCHAR2(500);

  CURSOR c_gen_grants_tabview
  IS
    SELECT object_name
    FROM   all_objects
    WHERE  object_type IN ( 'TABLE', 'VIEW' )
    AND    owner = l_schema
    AND    object_name NOT LIKE 'BIN%'
    AND    object_name NOT LIKE '%$%';

  CURSOR c_gen_grants_seq
  IS
    SELECT object_name
    FROM   all_objects
    WHERE  object_type IN ( 'SEQUENCE' )
    AND    owner = l_schema
    AND    object_name NOT LIKE 'BIN%'
    AND    object_name NOT LIKE '%$%';

  CURSOR c_gen_grants_package
  IS
    SELECT object_name
    FROM   all_objects
    WHERE  object_type IN ( 'PACKAGE' )
    AND    owner = l_schema
    AND    object_name NOT LIKE 'BIN%';

BEGIN
  -- First make sure the executor is a valid one
  IF USER NOT IN ('SYS','SYSTEM', 'DAR_ADMIN', p_schema_name)
  THEN

    RAISE_APPLICATION_ERROR ( -20010, 'User '||USER||' not permitted to execute this procedure for schema '|| p_schema_name);

  END IF;

dbms_output.put_line('grantee is: '||l_readonly_grantee);

  IF p_type = 'GRANT'
  THEN
    l_action      := 'GRANT';
    l_action_prep := 'TO';

  ELSIF p_type = 'REVOKE'
  THEN
    l_action      := 'REVOKE';
    l_action_prep := 'FROM';
  END IF;

  -- Read only grants.
  FOR r_gen_grants_tabview IN c_gen_grants_tabview
  LOOP
    
    BEGIN

    l_statement := l_action||' SELECT ON '||l_schema||'.'||r_gen_grants_tabview.object_name ||' '||l_action_prep||' '||l_readonly_grantee;


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
      NULL;
    END;

  END LOOP;


  -- Insert update and delete grants.
  FOR r_gen_grants_tabview IN c_gen_grants_tabview
  LOOP

    l_statement := l_action||' INSERT, UPDATE, DELETE ON '||l_schema||'.'||r_gen_grants_tabview.object_name ||' '||l_action_prep||' '||l_update_grantee;

    BEGIN

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
      NULL;
    END;

  END LOOP;

  -- grants to sequences.
  FOR r_gen_grants_seq IN c_gen_grants_seq
  LOOP

    l_statement := l_action||' SELECT ON '||l_schema||'.'||r_gen_grants_seq.object_name ||' '||l_action_prep||' '||l_update_grantee;

    IF p_show_sql = 'TRUE'
    THEN
      DBMS_OUTPUT.PUT_LINE ( l_statement );
    END IF;

    IF p_exec_sql = 'TRUE'
    THEN
      EXECUTE IMMEDIATE ( l_statement );
    END IF;

  END LOOP;

  -- grant execute on packages
  FOR r_gen_grants_package IN c_gen_grants_package
  LOOP

    l_statement := l_action||' EXECUTE ON '||l_schema||'.'||r_gen_grants_package.object_name||' '||l_action_prep||' '||l_execute_grantee;

    IF p_show_sql = 'TRUE'
    THEN
      DBMS_OUTPUT.PUT_LINE ( l_statement );
    END IF;

    IF p_exec_sql = 'TRUE'
    THEN
      EXECUTE IMMEDIATE ( l_statement );
    END IF;

  END LOOP;

  END grant_engine;

  PROCEDURE grant_all_nstr
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
    l_schemas := l_schema_list ('HECTOR_OWNER', 'PENFOLD_OWNER',
                          'LLUSPLUS_OWNER','SWISH_OWNER','XENA_OWNER','BTBILL_OWNER');
    FOR i IN l_schemas.FIRST..l_schemas.LAST LOOP
      dar_grant_manager.do_grants(l_schemas(i), p_show_sql, p_exec_sql);
    END LOOP;

  END grant_all_nstr;

  PROCEDURE revoke_all_nstr
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
    l_schemas := l_schema_list ('HECTOR_OWNER', 'PENFOLD_OWNER',
                          'LLUSPLUS_OWNER','SWISH_OWNER','XENA_OWNER', 'BTBILL_OWNER');
    FOR i IN l_schemas.FIRST..l_schemas.LAST LOOP
      dar_grant_manager.do_revoke(l_schemas(i), p_show_sql, p_exec_sql);
    END LOOP;

  END revoke_all_nstr;

END dar_grant_manager;
/
--END_PLSQL
GRANT execute on dar_owner.dar_grant_manager to public;

