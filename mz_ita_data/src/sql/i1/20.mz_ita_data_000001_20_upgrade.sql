-- MZITA-181 - Correct the 116UUU entries in the PREFIX_TO_KENAN_MAPPING table
--
-- REMOVE ALL EXISTING '116' ENTIRES
--
DELETE FROM PREFIX_TO_KENAN_MAPPING
 WHERE PREFIX LIKE '116%';


-- INSERT ALL THE PERMUTATIONS OF 116111 to 116999
--
--BEGIN_PLSQL
BEGIN
  FOR i IN 116111..116999 LOOP
    INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES (i, 'Freephone - Public Utility Service', '2005', '018#');
  END LOOP;
END;
/
--END_PLSQL


-- REMOVE ALL '116' ENTIRES THAT HAVE '0' IN THEM
--
DELETE FROM PREFIX_TO_KENAN_MAPPING
 WHERE PREFIX LIKE '116%0%';