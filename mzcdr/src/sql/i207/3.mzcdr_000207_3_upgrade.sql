-- Create Nokia IMS Output Sequences
--
CREATE SEQUENCE IMS_NOKIA_BI_FULL_OUTPUT_SEQ
  MINVALUE 1 
  MAXVALUE 999999999999999999999999999 
  INCREMENT BY 1 
  START WITH 1 
  NOCACHE  
  NOORDER  
  NOCYCLE;
  
CREATE SEQUENCE IMS_NOKIA_FRAUD_OUTPUT_SEQ
  MINVALUE 1 
  MAXVALUE 999999999999999999999999999 
  INCREMENT BY 1 
  START WITH 1 
  NOCACHE  
  NOORDER  
  NOCYCLE;