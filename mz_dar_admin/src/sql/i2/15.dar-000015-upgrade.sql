--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE dar_owner.dar_edition_manager_defn
AUTHID DEFINER
AS

  PROCEDURE setEdition (pName VARCHAR2);

END dar_edition_manager_defn;
/
--END_PLSQL
--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE BODY dar_owner.dar_edition_manager_defn AS

  -----------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE setEdition (pName VARCHAR2) IS
  -----------------------------------------------------------------------------------------------------------------------------------------

    editionAlreadyExists  EXCEPTION;
    PRAGMA EXCEPTION_INIT (editionAlreadyExists, -00955);

  BEGIN

    BEGIN
      EXECUTE IMMEDIATE 'CREATE EDITION ' || pName;
      EXECUTE IMMEDIATE 'GRANT USE ON EDITION ' || pName || ' TO PUBLIC';
    EXCEPTION
      WHEN editionAlreadyExists THEN
        NULL; 
    END;

    DBMS_SESSION.SET_EDITION_DEFERRED(pName);

  ---------------
  END setEdition;
  ---------------

END dar_edition_manager_defn;
/
--END_PLSQL
