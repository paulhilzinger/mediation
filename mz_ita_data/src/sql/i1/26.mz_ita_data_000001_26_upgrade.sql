-- MZITA-217 - New sequence for traffic analysis
CREATE SEQUENCE TA_OUTPUT_SEQ
MINVALUE 1 
MAXVALUE 999999999999999999999999999 
INCREMENT BY 1 
START WITH 1 
NOCACHE  
NOORDER  
NOCYCLE;
