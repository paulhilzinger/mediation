--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE             "DAR_GRANT_MANAGER"
AUTHID CURRENT_USER
AS
/*******************************************************************************
*
   NAME:       dar_grant_manager
   TYPE:       PL/SQL Package Body
   PURPOSE:    Grants permissions for Netstream schemas to appropriate roles

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------
-
   1.0        23/10/2006  LEJ              Initial Version.
   1.3        03/05/2007  LEJ              Change parameter type to varchar2
   1.4        22/05/2007  LEJ              Add grantee parameters
   1.5        03/07/2007  LEJ              Add FUNCTION to grant to EXECUTE role

   1.5        07/08/2007  OJT              Added overloaded procs.
********************************************************************************
*/
   PROCEDURE do_grants (
      p_schema_name        IN   VARCHAR2,
      p_show_sql           IN   VARCHAR2 DEFAULT 'TRUE',
      p_exec_sql           IN   VARCHAR2 DEFAULT 'FALSE'
   );

   PROCEDURE do_grants (
      p_schema_name        IN   VARCHAR2,
      p_show_sql           IN   VARCHAR2 DEFAULT 'TRUE',
      p_exec_sql           IN   VARCHAR2 DEFAULT 'FALSE',
      p_readonly_grantee   IN   VARCHAR2,
      p_update_grantee     IN   VARCHAR2,
      p_execute_grantee    IN   VARCHAR2
   );

   PROCEDURE do_revoke (
      p_schema_name        IN   VARCHAR2,
      p_show_sql           IN   VARCHAR2 DEFAULT 'TRUE',
      p_exec_sql           IN   VARCHAR2 DEFAULT 'FALSE'
   );

   PROCEDURE do_revoke (
      p_schema_name        IN   VARCHAR2,
      p_show_sql           IN   VARCHAR2 DEFAULT 'TRUE',
      p_exec_sql           IN   VARCHAR2 DEFAULT 'FALSE',
      p_readonly_grantee   IN   VARCHAR2,
      p_update_grantee     IN   VARCHAR2,
      p_execute_grantee    IN   VARCHAR2
   );

   PROCEDURE grant_engine (
      p_schema_name        IN   VARCHAR2,
      p_type               IN   VARCHAR2,
      p_show_sql           IN   VARCHAR2 DEFAULT 'TRUE',
      p_exec_sql           IN   VARCHAR2 DEFAULT 'FALSE',
      p_readonly_grantee   IN   VARCHAR2 DEFAULT NULL,
      p_update_grantee     IN   VARCHAR2 DEFAULT NULL,
      p_execute_grantee    IN   VARCHAR2 DEFAULT NULL
   );
END dar_grant_manager;
/
--END_PLSQL

--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE BODY             "DAR_GRANT_MANAGER"
AS
/*******************************************************************************
*
   NAME:       dar_grant_manager
   TYPE:       PL/SQL Package Body
   PURPOSE:    Grants permissions for Netstream schemas to appropriate roles

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------
-
   1.0        23/10/2006  LEJ              Initial Version.
   1.1        12/03/2006  LEJ              Improved vetting of executing user
   1.2        03/04/2007  OJT              Can skip invalid views and keep going
!
   1.3        03/05/2007  LEJ              Change parameter type to varchar2
   1.4        22/05/2007  LEJ              Add grantee parameters
   1.5        07/08/2007  OJT              Improved grantee feature flexibility.

********************************************************************************
*/


  PROCEDURE do_grants
  (
   p_schema_name IN varchar2
  ,p_show_sql    IN varchar2 default 'TRUE'
  ,p_exec_sql    IN varchar2 default 'FALSE'
  )
  IS

    l_schema           VARCHAR2(30);
    l_main_user        VARCHAR2(30);
    l_readonly_grantee VARCHAR2(30);
    l_update_grantee   VARCHAR2(30);
    l_execute_grantee  VARCHAR2(30);
    l_suffix_length    CONSTANT NUMBER := 6;

  BEGIN

    l_schema           := UPPER(NVL(p_schema_name , USER));
    l_main_user        := SUBSTR(l_schema, 1, LENGTH( l_schema ) - l_suffix_length);
    l_readonly_grantee := UPPER(l_main_user||'_READONLY');
    l_update_grantee   := UPPER(l_main_user||'_UPDATE');
    l_execute_grantee  := UPPER(l_main_user||'_EXECUTE');

    dar_grant_manager.grant_engine(p_schema_name, 'GRANT', p_show_sql, p_exec_sql, l_readonly_grantee, l_update_grantee, l_execute_grantee);

  END do_grants;

  PROCEDURE do_grants
  (
   p_schema_name      IN VARCHAR2
  ,p_show_sql         IN VARCHAR2 DEFAULT 'TRUE'
  ,p_exec_sql         IN VARCHAR2 DEFAULT 'FALSE'
  ,p_readonly_grantee IN VARCHAR2 
  ,p_update_grantee   IN VARCHAR2 
  ,p_execute_grantee  IN VARCHAR2 
  )
  IS
  BEGIN

    dar_grant_manager.grant_engine(p_schema_name, 'GRANT', p_show_sql, p_exec_sql, p_readonly_grantee, p_update_grantee, p_execute_grantee);

  END do_grants;

  PROCEDURE do_revoke
  (
   p_schema_name      IN VARCHAR2
  ,p_show_sql         IN VARCHAR2 DEFAULT 'TRUE'
  ,p_exec_sql         IN VARCHAR2 DEFAULT 'FALSE'
  ,p_readonly_grantee IN VARCHAR2 
  ,p_update_grantee   IN VARCHAR2 
  ,p_execute_grantee  IN VARCHAR2 
  )
  IS
  BEGIN

    dar_grant_manager.grant_engine(p_schema_name, 'REVOKE', p_show_sql, p_exec_sql, p_readonly_grantee, p_update_grantee, p_execute_grantee);

  END do_revoke;

  PROCEDURE do_revoke
  (
   p_schema_name      IN varchar2
  ,p_show_sql         IN varchar2 default 'TRUE'
  ,p_exec_sql         IN varchar2 default 'FALSE'
  )
  IS

    l_schema           VARCHAR2(30);
    l_main_user        VARCHAR2(30);
    l_readonly_grantee VARCHAR2(30);
    l_update_grantee   VARCHAR2(30);
    l_execute_grantee  VARCHAR2(30);
    l_suffix_length    CONSTANT NUMBER := 6;

  BEGIN

    l_schema           := UPPER(NVL(p_schema_name , USER));
    l_main_user        := SUBSTR(l_schema, 1, LENGTH( l_schema ) - l_suffix_length);
    l_readonly_grantee := UPPER(l_main_user||'_READONLY');
    l_update_grantee   := UPPER(l_main_user||'_UPDATE');
    l_execute_grantee  := UPPER(l_main_user||'_EXECUTE');

    dar_grant_manager.grant_engine(p_schema_name, 'REVOKE', p_show_sql, p_exec_sql, l_readonly_grantee, l_update_grantee, l_execute_grantee);

  END do_revoke;

  PROCEDURE grant_engine
  (
   p_schema_name      IN varchar2
  ,p_type             IN varchar2
  ,p_show_sql         IN varchar2 default 'TRUE'
  ,p_exec_sql         IN varchar2 default 'FALSE'
  ,p_readonly_grantee IN varchar2 default NULL
  ,p_update_grantee   IN varchar2 default NULL
  ,p_execute_grantee  IN varchar2 default NULL
  )
  IS

  l_action      VARCHAR2(10);
  l_action_prep VARCHAR2(10);
  l_statement   VARCHAR2(500);

  CURSOR c_gen_grants_tabview
  ( cp_schema VARCHAR2 )
  IS
    SELECT object_name
    FROM   all_objects
    WHERE  object_type IN ( 'TABLE', 'VIEW' )
    AND    owner = cp_schema
    AND    object_name NOT LIKE 'BIN%'
    AND    object_name NOT LIKE '%$%';

  CURSOR c_gen_grants_seq
  ( cp_schema VARCHAR2 )
  IS
    SELECT object_name
    FROM   all_objects
    WHERE  object_type IN ( 'SEQUENCE' )
    AND    owner = cp_schema
    AND    object_name NOT LIKE 'BIN%'
    AND    object_name NOT LIKE '%$%';

  CURSOR c_gen_grants_package
  ( cp_schema VARCHAR2 )
  IS
    SELECT object_name
    FROM   all_objects
    WHERE  object_type IN ( 'PACKAGE', 'FUNCTION' )
    AND    owner = cp_schema
    AND    object_name NOT LIKE 'BIN%';

BEGIN
  -- First make sure the executor is a valid one
  IF USER NOT IN ('SYS','SYSTEM', 'DAR_ADMIN', p_schema_name)
  THEN

    RAISE_APPLICATION_ERROR ( -20010, 'User '||USER||' not permitted to execute this procedure for schema '|| p_schema_name);

  END IF;

  dbms_output.put_line('grantee is: '||p_readonly_grantee);

  IF p_type = 'GRANT'
  THEN
    l_action      := 'GRANT';
    l_action_prep := 'TO';

  ELSIF p_type = 'REVOKE'
  THEN
    l_action      := 'REVOKE';
    l_action_prep := 'FROM';
  END IF;

  -- READ_ONLY
  IF ( p_readonly_grantee IS NOT NULL )
  THEN
    FOR r_gen_grants_tabview IN c_gen_grants_tabview( p_schema_name )
    LOOP

      BEGIN

      l_statement := l_action||' SELECT ON '||p_schema_name||'.'||r_gen_grants_tabview.object_name ||' '||l_action_prep||' '||p_readonly_grantee;


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

  END IF;

  -- UPDATE ( Insert, Update, Delete )
  IF ( p_update_grantee IS NOT NULL )
  THEN
    FOR r_gen_grants_tabview IN c_gen_grants_tabview( p_schema_name )
    LOOP

      l_statement := l_action||' INSERT, UPDATE, DELETE ON '||p_schema_name||'.'||r_gen_grants_tabview.object_name ||' '||l_action_prep||' '||p_update_grantee;

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

    -- (Sequences)
    FOR r_gen_grants_seq IN c_gen_grants_seq( p_schema_name )
    LOOP

      l_statement := l_action||' SELECT ON '||p_schema_name||'.'||r_gen_grants_seq.object_name ||' '||l_action_prep||' '||p_update_grantee;

      IF p_show_sql = 'TRUE'
      THEN
        DBMS_OUTPUT.PUT_LINE ( l_statement );
      END IF;

      IF p_exec_sql = 'TRUE'
      THEN
        EXECUTE IMMEDIATE ( l_statement );
      END IF;

    END LOOP;
  END IF;

  -- EXECUTE
  IF ( p_execute_grantee IS NOT NULL )
  THEN
    FOR r_gen_grants_package IN c_gen_grants_package( p_schema_name )
    LOOP

      l_statement := l_action||' EXECUTE ON '||p_schema_name||'.'||r_gen_grants_package.object_name||' '||l_action_prep||' '||p_execute_grantee;

      IF p_show_sql = 'TRUE'
      THEN
        DBMS_OUTPUT.PUT_LINE ( l_statement );
      END IF;

      IF p_exec_sql = 'TRUE'
      THEN
        EXECUTE IMMEDIATE ( l_statement );
      END IF;

    END LOOP;
  END IF;

  END grant_engine;

END dar_grant_manager;
/
--END_PLSQL
