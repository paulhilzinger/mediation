-- MZMOB-878. We need to use a DB sequence for files into OFCA [amg]
CREATE SEQUENCE OFCA_OUTPUT_SEQ
  MINVALUE 1 
  MAXVALUE 999999 
  INCREMENT BY 1 
  START WITH 1 
  NOCACHE  
  NOORDER  
CYCLE;
  