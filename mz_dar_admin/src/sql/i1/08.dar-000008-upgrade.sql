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
      SELECT o.object_id
      FROM   public_dependency d
           , user_objects o
      WHERE  d.object_id = oid
      AND    o.object_id = d.referenced_object_id
      AND    o.status   != 'VALID'
      MINUS
      SELECT object_id
      FROM   user_objects
      WHERE  object_name LIKE UPPER (oname)
      AND    object_type LIKE UPPER (otype)
      AND    status      LIKE UPPER (ostatus)
      AND    object_name NOT LIKE 'BIN$%';

   CURSOR recompile_cursor
   ( oid NUMBER )
   IS
      SELECT 'ALTER '||
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
      SELECT MAX (LEVEL) dlevel, object_id
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
      AND   status      LIKE UPPER (ostatus)
      AND   object_name NOT LIKE 'BIN$%'
      AND NOT EXISTS ( SELECT 1
                       FROM  sys.public_dependency d
                       WHERE d.object_id = o.object_id
                     )
      ORDER BY 1 desc;

   CURSOR status_cursor (oid NUMBER)
   IS
     SELECT status
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
grant execute on dar_utils to public;
