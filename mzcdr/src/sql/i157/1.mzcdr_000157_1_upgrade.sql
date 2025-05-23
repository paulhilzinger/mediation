-- CREATE A NEW SEQUENCE FOR THE TUK BI FRAUD FEED
--
CREATE SEQUENCE MZ_CDR_OWNER.BI_TUK_OUTPUT_SEQ
  MINVALUE 1
  MAXVALUE 99999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOORDER
  CYCLE;
  
CREATE SYNONYM MZ_CDR_USER.BI_TUK_OUTPUT_SEQ FOR MZ_CDR_OWNER.BI_TUK_OUTPUT_SEQ;

GRANT SELECT ON MZ_CDR_OWNER.BI_TUK_OUTPUT_SEQ TO MZ_CDR_UPDATE;