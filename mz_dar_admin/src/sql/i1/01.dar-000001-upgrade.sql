----------------------------------------
-- Company : Easynet UK
-- Project : dar
-- Author  : Lucy Jeffs
-- Version : Upgrade Delta 000001
----------------------------------------
-- Merged into one script at version 1.30
-- dar_1.00_DAR_RECOMPILE.sql
-- dar_1.00_DAR_UTILS_b.sql
-- dar_1.00_DAR_UTILS_h.sql
-- dar_1.30_grant_manager_b.sql
-- dar_1.30_grant_manager_h.sql
-- dar_1.30_synonym_manager_b.sql
-- dar_1.30_synonym_manager_h.sql

--BEGIN_PLSQL
CREATE OR REPLACE FUNCTION dar_recompile
(
--  ___________________________________________________________________
-- |
-- |				Recompile Utility
-- |___________________________________________________________________
--
--		Objects are recompiled based on object dependencies and
--		therefore compiling  all requested objects in one path.
--		Recompile Utility skips every object which is either of
--		unsupported object type or depends on INVALID object(s)
--		outside of current request (which means we know upfront
--		compilation will fail anyway).  If object recompilation
--		is not successful, Recompile Utility continues with the
--		next object. Recompile Utility has four parameters:
--
--		  o_name   - IN  mode  parameter is a VARCHAR2 defining
--			     names  of to  be  recompiled  objects.  It
--			     accepts operator LIKE widcards.  Backslash
--			     (\)  is used  for escaping  wildcards.  If
--			     omitted, it defaults to '%' - any name.
--		  o_type   - IN  mode  parameter is a VARCHAR2 defining
--			     types  of to  be  recompiled  objects.  It
--			     accepts operator LIKE widcards.  Backslash
--			     (\)  is used  for escaping  wildcards.  If
--			     omitted, it defaults to '%' - any type.
--		  o_status - IN  mode  parameter is a VARCHAR2 defining
--			     status of to  be  recompiled  objects.  It
--			     accepts operator LIKE widcards.  Backslash
--			     (\)  is used  for escaping  wildcards.  If
--			     omitted, it defaults  to 'INVALID'.
--		  display  - IN  mode parameter is a  BOOLEAN  defining
--			     whether object recompile status is written
--			     to  DBMS_OUTPUT  buffer.  If  omitted,  it
--			     defaults to TRUE.
--
--		Recompile Utility returns the following values or their
--		combinations:
--
--		  0 - Success. All requested objects are recompiled and
--		      are VALID.
--		  1 - INVALID_TYPE. At least one  of to  be  recompiled
--		      objects is not of supported object type.
--		  2 - INVALID_PARENT. At  least one of to be recompiled
--		      objects depends on an  invalid object outside  of
--		      current request.
--		  4 - COMPILE_ERRORS. At  least one of to be recompiled
--		      objects was compiled with errors and is INVALID.
-- ______________________________________________________________________
--

   o_name IN VARCHAR2 := '%',
   o_type IN VARCHAR2 := '%',
   o_status IN VARCHAR2 := 'INVALID',
   display IN BOOLEAN := TRUE)
   RETURN NUMBER
   AUTHID CURRENT_USER
IS

   -- Exceptions

   successwithcompilationerror EXCEPTION;
   PRAGMA EXCEPTION_INIT (successwithcompilationerror,- 24344);

   -- Return Codes

   invalid_type   CONSTANT INTEGER := 1;
   invalid_parent CONSTANT INTEGER := 2;
   compile_errors CONSTANT INTEGER := 4;

   cnt              NUMBER;
   dyncur           INTEGER;
   type_status      INTEGER := 0;
   parent_status    INTEGER := 0;
   recompile_status INTEGER := 0;
   object_status    VARCHAR2(30);

   CURSOR invalid_parent_cursor
   ( oname VARCHAR2
   , otype VARCHAR2
   , ostatus VARCHAR2
   , oid NUMBER
   )
   IS
      SELECT /*+ RULE */o.object_id
      FROM   public_dependency d
           , user_objects o
      WHERE  d.object_id = oid
      AND    o.object_id = d.referenced_object_id
      AND    o.status != 'VALID'
      MINUS
      SELECT /*+ RULE */object_id
      FROM   user_objects
      WHERE  object_name LIKE UPPER (oname)
      AND    object_type LIKE UPPER (otype)
      AND    status LIKE UPPER (ostatus);

   CURSOR recompile_cursor
   ( oid NUMBER )
   IS
      SELECT /*+ RULE */'ALTER '||
      DECODE ( object_type, 'PACKAGE BODY'
                          , 'PACKAGE'
                          , 'TYPE BODY'
                          , 'TYPE'
                          , object_type
             ) ||' '||
             object_name ||' COMPILE '||
      DECODE ( object_type, 'PACKAGE BODY'
                          , ' BODY'
                          , 'TYPE BODY'
                          , 'BODY'
                          , 'TYPE'
                          , 'SPECIFICATION'
                          , ''
             ) stmt
             , object_type
             , object_name
        FROM  user_objects
        WHERE object_id = oid;

   recompile_record recompile_cursor%ROWTYPE;

   CURSOR obj_cursor
   ( oname VARCHAR2
   , otype VARCHAR2
   , ostatus VARCHAR2
   )
   IS
      SELECT /*+ RULE */MAX (LEVEL) dlevel, object_id
      FROM   sys.public_dependency
      START WITH object_id IN ( SELECT object_id
                                FROM user_objects
                                WHERE object_name LIKE UPPER (oname)
                                AND   object_type LIKE UPPER (otype)
                                AND   status      LIKE UPPER (ostatus)
                               )
      CONNECT BY object_id = PRIOR referenced_object_id
      GROUP BY object_id
      HAVING MIN (LEVEL) = 1
      UNION ALL
      SELECT 1 dlevel
           , object_id
      FROM  user_objects o
      WHERE object_name LIKE UPPER (oname)
      AND   object_type LIKE UPPER (otype)
      AND status        LIKE UPPER (ostatus)
      AND NOT EXISTS ( SELECT 1
                       FROM  sys.public_dependency d
                       WHERE d.object_id = o.object_id
                     )
      ORDER BY 1 desc;

   CURSOR status_cursor (oid NUMBER)
   IS
     SELECT /*+ RULE */status
     FROM   user_objects
     WHERE  object_id = oid;

BEGIN

   -- Recompile requested objects based on their dependency levels.

   IF display
   THEN
     DBMS_OUTPUT.put_line (CHR (0));
     DBMS_OUTPUT.put_line ('                            RECOMPILING OBJECTS');
     DBMS_OUTPUT.put_line (CHR (0));
     DBMS_OUTPUT.put_line ('                            Object Name is   '|| o_name   );
     DBMS_OUTPUT.put_line ('                            Object Type is   '|| o_type   );
     DBMS_OUTPUT.put_line ('                            Object Status is '|| o_status );
     DBMS_OUTPUT.put_line (CHR (0));
   END IF;

   dyncur := DBMS_SQL.open_cursor;
   FOR obj_record IN obj_cursor (o_name, o_type, o_status)
   LOOP
      OPEN recompile_cursor (obj_record.object_id);
      FETCH recompile_cursor INTO recompile_record;
      CLOSE recompile_cursor;

      -- We can recompile only Functions, Packages, Package Bodies,
      -- Procedures, Triggers, Views, Types and Type Bodies.

      IF recompile_record.object_type IN ( 'FUNCTION'
                                         , 'PACKAGE'
                                         , 'PACKAGE BODY'
                                         , 'PROCEDURE'
                                         , 'TRIGGER'
                                         , 'VIEW'
                                         , 'TYPE'
                                         , 'TYPE BODY'
                                         )
      THEN

         -- There is no sense to recompile an object that depends on
         -- invalid objects outside of the current recompile request.

         OPEN invalid_parent_cursor
         ( o_name
         , o_type
         , o_status
         , obj_record.object_id
         );
         FETCH invalid_parent_cursor INTO cnt;
         IF invalid_parent_cursor%NOTFOUND
         THEN

            -- Recompile object.

            BEGIN
               DBMS_SQL.parse (dyncur, recompile_record.stmt, DBMS_SQL.native);
            EXCEPTION
            WHEN successwithcompilationerror
            THEN
               NULL;
            END;

            OPEN status_cursor (obj_record.object_id);
            FETCH status_cursor INTO object_status;
            CLOSE status_cursor;
            IF display
            THEN
               DBMS_OUTPUT.put_line
               ( recompile_record.object_type ||
                 ' '||
                 recompile_record.object_name ||
                 ' is recompiled. Object status is '||
                 object_status ||
                 '.'
               );
            END IF;

            IF object_status != 'VALID'
            THEN
               recompile_status := compile_errors;
            END IF;

         ELSE

            IF display
            THEN
               DBMS_OUTPUT.put_line (
                  recompile_record.object_type ||
                  ' '||
                  recompile_record.object_name ||
                  ' references invalid object(s)'||
                  ' outside of this request.'
               );
            END IF;

            parent_status := invalid_parent;

         END IF;
         CLOSE invalid_parent_cursor;
      ELSE
         IF display
         THEN
            DBMS_OUTPUT.put_line (
               recompile_record.object_name ||
               ' is a '||
               recompile_record.object_type ||
               ' and can not be recompiled.'
            );
         END IF;
         type_status := invalid_type;
      END IF;

   END LOOP;
   DBMS_SQL.close_cursor (dyncur);

   RETURN type_status + parent_status + recompile_status;

EXCEPTION
   WHEN OTHERS
   THEN
      IF obj_cursor%ISOPEN
      THEN
         CLOSE obj_cursor;
      END IF;
      IF recompile_cursor%ISOPEN
      THEN
         CLOSE recompile_cursor;
      END IF;
      IF invalid_parent_cursor%ISOPEN
      THEN
         CLOSE invalid_parent_cursor;
      END IF;
      IF status_cursor%ISOPEN
      THEN
         CLOSE status_cursor;
      END IF;
      IF DBMS_SQL.is_open (dyncur)
      THEN
         DBMS_SQL.close_cursor (dyncur);
      END IF;
      RAISE;
END;
/
--END_PLSQL

--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE dar_utils
AUTHID CURRENT_USER
AS
/********************************************************************************
   NAME:       dar_utils
   TYPE:       PL/SQL Package Header
   PURPOSE:    A general-purpose package of utilities

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------
   1          06/12/2003  OJT              Initial Version.

*********************************************************************************/

  -- A wrapper for the function DAR_RECOMPILE,
  -- so that client SQL scripts can recompile using a single statement

  PROCEDURE recompile_all_invalid;

END dar_utils;
/
--END_PLSQL

--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE BODY dar_utils
AS
/********************************************************************************
   NAME:       dar_recompile
   TYPE:       PL/SQL Package Header
   PURPOSE:    A general-purpose package of utilities.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------
   1          06/12/2003  OJT              Initial Version.

*********************************************************************************/

  -- A wrapper for the function DAR_RECOMPILE,
  -- so that client SQL scripts can recompile using a single statement

  PROCEDURE recompile_all_invalid
  AS

    L_RETVAL  NUMBER;

  BEGIN

    L_RETVAL := DAR_RECOMPILE();

    IF L_RETVAL != 0
    THEN
        RAISE_APPLICATION_ERROR ( -20000, 'Recompile Output Status: ' || L_RETVAL );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Recompile Output Status: ' || L_RETVAL);

  END recompile_all_invalid;
  
  --------------------------------------------------------------------------------

END dar_utils;
/
--END_PLSQL

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
*********************************************************************************/

PROCEDURE do_grants
  (
  p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  );

PROCEDURE do_revoke
  (
  p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
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
*********************************************************************************/

  PROCEDURE do_grants
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  )
  IS
  BEGIN
    dar_grant_manager.grant_engine(p_schema_name, 'GRANT', p_show_sql, p_exec_sql);
  END do_grants;

  PROCEDURE do_revoke
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  )
  IS
  BEGIN
    dar_grant_manager.grant_engine(p_schema_name, 'REVOKE', p_show_sql, p_exec_sql);
  END do_revoke;

  PROCEDURE grant_engine
  (
   p_schema_name IN varchar2
  ,p_type        IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  )
  IS

  ------------------------------------------------------------------
  -- Local variables for identifying schema name
  ------------------------------------------------------------------
  l_schema    VARCHAR2(30)   := UPPER(NVL(p_schema_name , USER));
  --  use l_suffix_length to strip the _OWNER from the schema name
  l_suffix_length NUMBER     := 6;
  l_main_user VARCHAR2(30)   := SUBSTR(l_schema, 1, LENGTH( l_schema ) - l_suffix_length);
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
  IF USER NOT IN ('SYS','SYSTEM', p_schema_name)
  THEN

    RAISE_APPLICATION_ERROR ( -20010, 'User '||USER||' not permitted to execute this procedure for schema '|| p_schema_name);

  END IF;

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

    l_statement := l_action||' SELECT ON '||l_schema||'.'||r_gen_grants_tabview.object_name ||' '||l_action_prep||' '||l_main_user||'_READONLY';


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

    l_statement := l_action||' INSERT, UPDATE, DELETE ON '||l_schema||'.'||r_gen_grants_tabview.object_name ||' '||l_action_prep||' '||l_main_user||'_UPDATE';

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

    l_statement := l_action||' SELECT ON '||l_schema||'.'||r_gen_grants_seq.object_name ||' '||l_action_prep||' '||l_main_user||'_UPDATE';

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

    l_statement := l_action||' EXECUTE ON '||l_schema||'.'||r_gen_grants_package.object_name||' '||l_action_prep||' '||l_main_user||'_EXECUTE';

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
*********************************************************************************/

PROCEDURE create_synonyms
  (
  p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  );

PROCEDURE drop_synonyms
  (
  p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
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
*********************************************************************************/

  PROCEDURE create_synonyms
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  )
  IS
  BEGIN
    dar_synonym_manager.synonym_engine(p_schema_name, 'CREATE', p_show_sql, p_exec_sql);
  END create_synonyms;

  PROCEDURE drop_synonyms
  (
   p_schema_name IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  )
  IS
  BEGIN
    dar_synonym_manager.synonym_engine(p_schema_name, 'DROP', p_show_sql, p_exec_sql);
  END drop_synonyms;

  PROCEDURE synonym_engine
  (
   p_schema_name IN varchar2
  ,p_type        IN varchar2
  ,p_show_sql IN varchar2 default 'TRUE'
  ,p_exec_sql IN varchar2 default 'FALSE'
  )
  IS

  ------------------------------------------------------------------
  -- Local variables for identifying schema name
  ------------------------------------------------------------------
  l_schema    VARCHAR2(30)   := UPPER(NVL(p_schema_name , USER));
  --  use l_suffix_length to strip the _OWNER from the schema name
  l_suffix_length NUMBER     := 6;
  l_main_user VARCHAR2(30)   := SUBSTR(l_schema, 1, LENGTH( l_schema ) - l_suffix_length);
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
  IF USER NOT IN ('SYS','SYSTEM', p_schema_name)
  THEN 

    RAISE_APPLICATION_ERROR ( -20010, 'User '||USER||' not permitted to execute this procedure for schema '|| p_schema_name);

  END IF;

  IF p_type = 'CREATE'
  THEN
    -- Create Synonyms.
    FOR r_gen_synonyms IN c_gen_synonyms
    LOOP
      BEGIN

        l_statement := 'CREATE SYNONYM '||l_main_user||'_USER.'||r_gen_synonyms.object_name ||' FOR '||l_schema||'.'||r_gen_synonyms.object_name ;

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

        l_statement := 'DROP SYNONYM '||l_main_user||'_USER.'||r_gen_synonyms.object_name ;

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
