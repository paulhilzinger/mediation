--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE dar_mailer IS

/*******************************************************************************
   NAME:       dar_mailer
   TYPE:       PL/SQL Package Header
   PURPOSE:    Sends emails

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------
   1.0        03/10/2008  OJT             Initial version

*******************************************************************************/
   
  ----------------------- Customizable Section -----------------------
   
  -- Customize the SMTP host, port and your domain name below.
  smtp_host   VARCHAR2(256) := 'smtp.sky.com';
  smtp_port   PLS_INTEGER   := 25;
  smtp_domain VARCHAR2(256) := 'sky.com';

  -- Customize the signature that will appear in the email's MIME header.
  -- Useful for versioning.
  MAILER_ID   CONSTANT VARCHAR2(256) := 'Mailer by Oracle UTL_SMTP';
  
  --------------------- End Customizable Section ---------------------

  -- A unique string that demarcates boundaries of parts in a multi-part email
  -- The string should not appear inside the body of any part of the email.
  -- Customize this if needed or generate this randomly dynamically.
  BOUNDARY        CONSTANT VARCHAR2(256) := '-----7D81B75CCC90D2974F7A1CBD';
  FIRST_BOUNDARY  CONSTANT VARCHAR2(256) := '--' || BOUNDARY || utl_tcp.CRLF;
  LAST_BOUNDARY   CONSTANT VARCHAR2(256) := '--' || BOUNDARY || '--' ||utl_tcp.CRLF;

  -- A MIME type that denotes multi-part email (MIME) messages.
  MULTIPART_MIME_TYPE CONSTANT VARCHAR2(256) := 'multipart/mixed; boundary="'||BOUNDARY || '"';
  MAX_BASE64_LINE_WIDTH CONSTANT PLS_INTEGER   := 76 / 4 * 3;

  -- A simple email API for sending email in plain text in a single call.
  -- The format of an email address is one of these:
  --   someone@some-domain
  --   "Someone at some domain" <someone@some-domain>
  --   Someone at some domain <someone@some-domain>
  -- The recipients is a list of email addresses  separated by
  -- either a "," or a ";"
  PROCEDURE mail
  ( sender     IN VARCHAR2
  , recipients IN VARCHAR2
  , subject    IN VARCHAR2
  , message    IN VARCHAR2
  );

  -- Extended email API to send email in HTML or plain text with no size limit.
  -- First, begin the email by begin_mail(). Then, call write_text() repeatedly
  -- to send email in ASCII piece-by-piece. Or, call write_mb_text() to send
  -- email in non-ASCII or multi-byte character set. End the email with
  -- end_mail().
  
  FUNCTION begin_mail
  ( sender     IN VARCHAR2
  , recipients IN VARCHAR2
  , subject    IN VARCHAR2
  , mime_type  IN VARCHAR2    DEFAULT 'text/plain'
  , priority   IN PLS_INTEGER DEFAULT NULL
  )
  RETURN utl_smtp.connection;

  -- Write email body in ASCII
  PROCEDURE write_text
  ( conn    IN OUT NOCOPY utl_smtp.connection
  , message IN VARCHAR2
  );

  -- Write email body in non-ASCII (including multi-byte). The email body
  -- will be sent in the database character set.
  PROCEDURE write_mb_text
  ( conn    IN OUT NOCOPY utl_smtp.connection
  , message IN VARCHAR2
  );
  
  -- Write email body in binary
  PROCEDURE write_raw
  ( conn    IN OUT NOCOPY utl_smtp.connection
  , message IN RAW
  );

  -- APIs to send email with attachments. Attachments are sent by sending
  -- emails in "multipart/mixed" MIME format. Specify that MIME format when
  -- beginning an email with begin_mail().
  
  -- Send a single text attachment.
  PROCEDURE attach_text
  ( conn     IN OUT NOCOPY utl_smtp.connection
  , data         IN VARCHAR2
  , mime_type    IN VARCHAR2 DEFAULT 'text/plain'
  , inline       IN BOOLEAN  DEFAULT TRUE
  , filename     IN VARCHAR2 DEFAULT NULL
  , last         IN BOOLEAN  DEFAULT FALSE
  );
  
  -- Send a binary attachment. The attachment will be encoded in Base-64
  -- encoding format.
  PROCEDURE attach_base64
  ( conn         IN OUT NOCOPY utl_smtp.connection
  , data         IN RAW
  , mime_type    IN VARCHAR2 DEFAULT 'application/octet'
  , inline       IN BOOLEAN  DEFAULT TRUE
  , filename     IN VARCHAR2 DEFAULT NULL
  , last         IN BOOLEAN  DEFAULT FALSE
  );
  
  -- Send an attachment with no size limit. First, begin the attachment
  -- with begin_attachment(). Then, call write_text repeatedly to send
  -- the attachment piece-by-piece. If the attachment is text-based but
  -- in non-ASCII or multi-byte character set, use write_mb_text() instead.
  -- To send binary attachment, the binary content should first be
  -- encoded in Base-64 encoding format using the demo package for 8i,
  -- or the native one in 9i. End the attachment with end_attachment.
  
  PROCEDURE begin_attachment
  ( conn         IN OUT NOCOPY utl_smtp.connection
  , mime_type    IN VARCHAR2 DEFAULT 'text/plain'
  , inline       IN BOOLEAN  DEFAULT TRUE
  , filename     IN VARCHAR2 DEFAULT NULL
  , transfer_enc IN VARCHAR2 DEFAULT NULL
  );
  
  -- End the attachment.
  PROCEDURE end_attachment
   ( conn IN OUT NOCOPY utl_smtp.connection
   , last IN BOOLEAN DEFAULT FALSE
   );
  
  -- End the email.
  PROCEDURE end_mail
  (conn IN OUT NOCOPY utl_smtp.connection);

  -- Extended email API to send multiple emails in a session for better
  -- performance. First, begin an email session with begin_session.
  -- Then, begin each email with a session by calling begin_mail_in_session
  -- instead of begin_mail. End the email with end_mail_in_session instead
  -- of end_mail. End the email session by end_session.
  FUNCTION begin_session 
  RETURN utl_smtp.connection;
  
  -- Begin an email in a session.
  PROCEDURE begin_mail_in_session
  ( conn       IN OUT NOCOPY utl_smtp.connection
  , sender     IN VARCHAR2
  , recipients IN VARCHAR2
  , subject    IN VARCHAR2
  , mime_type  IN VARCHAR2  DEFAULT 'text/plain'
  , priority   IN PLS_INTEGER DEFAULT NULL
  );
  
  -- End an email in a session.
  PROCEDURE end_mail_in_session
  (conn IN OUT NOCOPY utl_smtp.connection);
  
  -- End an email session.
  PROCEDURE end_session
  (conn IN OUT NOCOPY utl_smtp.connection);

END;
/
--END_PLSQL
--BEGIN_PLSQL
CREATE OR REPLACE PACKAGE BODY dar_mailer 
IS

/*******************************************************************************
   NAME:       dar_mailer
   TYPE:       PL/SQL Package Body
   PURPOSE:    Sends emails

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------
   1.0        03/10/2008  OJT             Initial version

*******************************************************************************/

   
  -- Return the next email address in the list of email addresses, separated
  -- by either a "," or a ";".  The format of mailbox may be in one of these:
  --   someone@some-domain
  --   "Someone at some domain" <someone@some-domain>
  --   Someone at some domain <someone@some-domain>
  FUNCTION get_address
  ( addr_list IN OUT VARCHAR2)
  RETURN VARCHAR2 
  IS

    addr VARCHAR2(256);
    i    pls_integer;

    FUNCTION lookup_unquoted_char
    ( str  IN VARCHAR2
    , chrs IN VARCHAR2
    ) 
    RETURN pls_integer 
    AS
        
      c            VARCHAR2(5);
      i            pls_integer;
      len          pls_integer;
      inside_quote BOOLEAN;
          
    BEGIN
      
      inside_quote := false;
      i   := 1;
      len := length(str);
        
      WHILE (i <= len) 
      LOOP

        c := substr(str, i, 1);

        IF (inside_quote) 
        THEN
          IF (c = '"') 
          THEN
            inside_quote := false;
          ELSIF (c = '\') 
          THEN
            i := i + 1; -- Skip the quote character
          END IF;
          GOTO next_char;
        END IF;
       
        IF (c = '"') 
        THEN
          inside_quote := true;
          GOTO next_char;
        END IF;
          
        IF (instr(chrs, c) >= 1) THEN
          RETURN i;
        END IF;
          
        <<next_char>>
        i := i + 1;

      END LOOP;
        
      RETURN 0;
        
    END;

  BEGIN

    addr_list := ltrim(addr_list);
    i := lookup_unquoted_char(addr_list, ',;');
      
    IF (i >= 1) 
    THEN
      addr      := substr(addr_list, 1, i - 1);
      addr_list := substr(addr_list, i + 1);
    ELSE
      addr := addr_list;
      addr_list := '';
    END IF;
     
    i := lookup_unquoted_char(addr, '<');
      
    IF (i >= 1) 
    THEN
      addr := substr(addr, i + 1);
      i    := instr(addr, '>');
      IF (i >= 1) 
      THEN
        addr := substr(addr, 1, i - 1);
      END IF;
    END IF;

    RETURN addr;
      
  END get_address;
  
 ------------------------------------------------------------------------------  
    
  -- Write a MIME header
  PROCEDURE write_mime_header
  ( conn  IN OUT NOCOPY utl_smtp.connection
  , name  IN VARCHAR2
  , value IN VARCHAR2
  ) IS
  BEGIN
    utl_smtp.write_data(conn, name || ': ' || value || utl_tcp.CRLF);
  END write_mime_header;
 ------------------------------------------------------------------------------  

  -- Mark a message-part boundary.  Set <last> to TRUE for the last boundary.
  PROCEDURE write_boundary
  ( conn  IN OUT NOCOPY utl_smtp.connection
  , last  IN BOOLEAN DEFAULT FALSE
  ) 
  AS
  BEGIN
    IF (last) THEN
      utl_smtp.write_data(conn, LAST_BOUNDARY);
    ELSE
      utl_smtp.write_data(conn, FIRST_BOUNDARY);
    END IF;
  END write_boundary;

  ------------------------------------------------------------------------------
  
  PROCEDURE mail
  ( sender     IN VARCHAR2
  , recipients IN VARCHAR2
  , subject    IN VARCHAR2
  , message    IN VARCHAR2
  ) 
  IS
    conn utl_smtp.connection;
  BEGIN
    conn := begin_mail(sender, recipients, subject);
    write_text(conn, message);
    end_mail(conn);
  END mail;

  ------------------------------------------------------------------------------
  
  FUNCTION begin_mail
  ( sender  IN VARCHAR2
  , recipients IN VARCHAR2
  , subject    IN VARCHAR2
  , mime_type  IN VARCHAR2    DEFAULT 'text/plain'
  , priority   IN PLS_INTEGER DEFAULT NULL
  )
  RETURN utl_smtp.connection 
  IS
    conn utl_smtp.connection;
  BEGIN
    conn := begin_session;
    begin_mail_in_session(conn, sender, recipients, subject, mime_type,priority);
    RETURN conn;
  END begin_mail;

  ------------------------------------------------------------------------------
  
  PROCEDURE write_text
  ( conn    IN OUT NOCOPY utl_smtp.connection
  , message IN VARCHAR2
  ) 
  IS
  BEGIN
    utl_smtp.write_data(conn, message);
  END write_text;

  ------------------------------------------------------------------------------
  
  PROCEDURE write_mb_text
  ( conn    IN OUT NOCOPY utl_smtp.connection
  , message IN VARCHAR2
  ) 
  IS
  BEGIN
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw(message));
  END write_mb_text;

  ------------------------------------------------------------------------------
  
  PROCEDURE write_raw
  ( conn    IN OUT NOCOPY utl_smtp.connection
  , message IN RAW
  ) IS
  BEGIN
    utl_smtp.write_raw_data(conn, message);
  END write_raw;

  ------------------------------------------------------------------------------
  
  PROCEDURE attach_text
  ( conn         IN OUT NOCOPY utl_smtp.connection
  , data         IN VARCHAR2
  , mime_type    IN VARCHAR2 DEFAULT 'text/plain'
  , inline       IN BOOLEAN  DEFAULT TRUE
  , filename     IN VARCHAR2 DEFAULT NULL
  , last         IN BOOLEAN  DEFAULT FALSE
  ) 
  IS
  BEGIN
    begin_attachment(conn, mime_type, inline, filename);
    write_text(conn, data);
    end_attachment(conn, last);
  END attach_text;

  ------------------------------------------------------------------------------
  
  PROCEDURE attach_base64
  ( conn         IN OUT NOCOPY utl_smtp.connection
  , data         IN RAW
  , mime_type    IN VARCHAR2 DEFAULT 'application/octet'
  , inline       IN BOOLEAN  DEFAULT TRUE
  , filename     IN VARCHAR2 DEFAULT NULL
  , last         IN BOOLEAN  DEFAULT FALSE
  ) 
  IS
    i   PLS_INTEGER;
    len PLS_INTEGER;
  BEGIN
    
    begin_attachment(conn, mime_type, inline, filename, 'base64');

    -- Split the Base64-encoded attachment into multiple lines
    i   := 1;
    len := utl_raw.length(data);
    WHILE (i < len) LOOP
       IF (i + MAX_BASE64_LINE_WIDTH < len) THEN
   utl_smtp.write_raw_data(conn,
      utl_encode.base64_encode(utl_raw.substr(data, i,
      MAX_BASE64_LINE_WIDTH)));
       ELSE
   utl_smtp.write_raw_data(conn,
     utl_encode.base64_encode(utl_raw.substr(data, i)));
       END IF;
       utl_smtp.write_data(conn, utl_tcp.CRLF);
       i := i + MAX_BASE64_LINE_WIDTH;
    END LOOP;
    
    end_attachment(conn, last);

  END attach_base64;

  ------------------------------------------------------------------------------
  
  PROCEDURE begin_attachment
  ( conn         IN OUT NOCOPY utl_smtp.connection
  , mime_type    IN VARCHAR2 DEFAULT 'text/plain'
  , inline       IN BOOLEAN  DEFAULT TRUE
  , filename     IN VARCHAR2 DEFAULT NULL
  , transfer_enc IN VARCHAR2 DEFAULT NULL
  ) 
  IS
  BEGIN
    write_boundary(conn);
    write_mime_header(conn, 'Content-Type', mime_type);

    IF (filename IS NOT NULL) THEN
       IF (inline) THEN
    write_mime_header(conn, 'Content-Disposition',
      'inline; filename="'||filename||'"');
       ELSE
    write_mime_header(conn, 'Content-Disposition',
      'attachment; filename="'||filename||'"');
       END IF;
    END IF;

    IF (transfer_enc IS NOT NULL) THEN
      write_mime_header(conn, 'Content-Transfer-Encoding', transfer_enc);
    END IF;
    
    utl_smtp.write_data(conn, utl_tcp.CRLF);
  END begin_attachment;

  ------------------------------------------------------------------------------
  
  PROCEDURE end_attachment
  ( conn IN OUT NOCOPY utl_smtp.connection
  , last IN BOOLEAN DEFAULT FALSE) 
  IS
  BEGIN
    utl_smtp.write_data(conn, utl_tcp.CRLF);
    IF (last) THEN
      write_boundary(conn, last);
    END IF;
  END  end_attachment;

  ------------------------------------------------------------------------------
  
  PROCEDURE end_mail
  ( conn IN OUT NOCOPY utl_smtp.connection
  ) 
  IS
  BEGIN
    end_mail_in_session(conn);
    end_session(conn);
  END end_mail;

  ------------------------------------------------------------------------------
  
  FUNCTION begin_session 
  RETURN utl_smtp.connection 
  IS
    conn utl_smtp.connection;
  BEGIN
    -- open SMTP connection
    conn := utl_smtp.open_connection(smtp_host, smtp_port);
    utl_smtp.helo(conn, smtp_domain);
    RETURN conn;
  END begin_session;

  ------------------------------------------------------------------------------
  
  PROCEDURE begin_mail_in_session
  ( conn  IN OUT NOCOPY utl_smtp.connection
  , sender     IN VARCHAR2
  , recipients IN VARCHAR2
  , subject    IN VARCHAR2
  , mime_type  IN VARCHAR2  DEFAULT 'text/plain'
  , priority   IN PLS_INTEGER DEFAULT NULL
  ) 
  IS
    my_recipients VARCHAR2(32767) := recipients;
    my_sender     VARCHAR2(32767) := sender;
  BEGIN

    -- Specify sender's address (our server allows bogus address
    -- as long as it is a full email address (xxx@yyy.com).
    utl_smtp.mail(conn, get_address(my_sender));

    -- Specify recipient(s) of the email.
    WHILE (my_recipients IS NOT NULL) LOOP
      utl_smtp.rcpt(conn, get_address(my_recipients));
    END LOOP;

    -- Start body of email
    utl_smtp.open_data(conn);

    -- Set "From" MIME header
    write_mime_header(conn, 'From', sender);

    -- Set "To" MIME header
    write_mime_header(conn, 'To', recipients);

    -- Set "Subject" MIME header
    write_mime_header(conn, 'Subject', subject);

    -- Set "Content-Type" MIME header
    write_mime_header(conn, 'Content-Type', mime_type);

    -- Set "X-Mailer" MIME header
    write_mime_header(conn, 'X-Mailer', MAILER_ID);

    -- Set priority:
    --   High      Normal       Low
    --   1     2     3     4     5
    IF (priority IS NOT NULL) THEN
      write_mime_header(conn, 'X-Priority', priority);
    END IF;

    -- Send an empty line to denotes end of MIME headers and
    -- beginning of message body.
    utl_smtp.write_data(conn, utl_tcp.CRLF);

    IF (mime_type LIKE 'multipart/mixed%') THEN
      write_text(conn, 'This is a multi-part message in MIME format.' ||utl_tcp.crlf);
    END IF;

  END begin_mail_in_session;

  ------------------------------------------------------------------------------
  
  PROCEDURE end_mail_in_session
  ( conn IN OUT NOCOPY utl_smtp.connection) 
  IS
  BEGIN
    utl_smtp.close_data(conn);
  END end_mail_in_session;
    
  ------------------------------------------------------------------------------
  
  PROCEDURE end_session
  ( conn IN OUT NOCOPY utl_smtp.connection ) 
  IS
  BEGIN
    utl_smtp.quit(conn);
  END end_session;

END;
/
--END_PLSQL
GRANT EXECUTE ON DAR_MAILER TO PUBLIC;
--BEGIN_PLSQL
CREATE OR REPLACE FUNCTION DAR_OWNER.dar_recompile
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
      AND   object_type != 'MATERIALIZED VIEW'
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
