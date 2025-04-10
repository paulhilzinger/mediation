--BEGIN_PLSQL
CREATE OR REPLACE PROCEDURE dar_owner.execute_object_privilege (
  p_action             IN   VARCHAR2,
  p_object_privilege   IN   VARCHAR2,
  p_schema_name        IN   VARCHAR2,
  p_object_name        IN   VARCHAR2,
  p_grantee            IN   VARCHAR2,
  p_show_sql           IN   VARCHAR2 DEFAULT 'TRUE',
  p_exec_sql           in   VARCHAR2 DEFAULT 'FALSE',
  p_with_grant_option  in   VARCHAR2 DEFAULT 'FALSE',
  p_ignore_errors      IN   VARCHAR2 DEFAULT 'FALSE'
)
IS
  l_statement   VARCHAR2(500);
  --
BEGIN
  --
  IF p_action = 'GRANT'
  THEN
    --
    l_statement := p_action||' '||p_object_privilege||' ON '||p_schema_name||'.'||p_object_name||' TO '||p_grantee;
    --
    IF p_with_grant_option = 'TRUE' 
    THEN
      l_statement := l_statement||' WITH GRANT OPTION';
    END IF;
    --
  ELSIF p_action = 'REVOKE'
  THEN
    --
    l_statement := p_action||' '||p_object_privilege||' ON '||p_schema_name||'.'||p_object_name||' FROM '||p_grantee;
    --
  END IF;
  --
  IF p_show_sql = 'TRUE'
  THEN
    dbms_output.put_line ( l_statement );
  END IF;
  --
  BEGIN
    IF p_exec_sql = 'TRUE'
    THEN
      EXECUTE IMMEDIATE l_statement;
    END IF;
  EXCEPTION
    WHEN others 
    THEN
      IF NVL(p_ignore_errors, 'FALSE') = 'FALSE' 
      THEN
        raise;
      END IF;
  END;
  --
END execute_object_privilege;
/
--END_PLSQL
GRANT EXECUTE ON execute_object_privilege TO dar_execute; 

