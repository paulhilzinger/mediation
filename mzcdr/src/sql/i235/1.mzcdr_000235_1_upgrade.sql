CREATE TABLE MZ_CDR_OWNER.MZ_EXT_TRUNK_GRP_NAME
 (
   EXTERNAL_TRUNK_GRP_NAME  VARCHAR2(50) NOT NULL, 
   UNIT_NAME VARCHAR2(20 BYTE) NOT NULL
 );
    	
CREATE INDEX MZ_EXT_TRUNK_GRP_NAME_IDX1 ON MZ_EXT_TRUNK_GRP_NAME (EXTERNAL_TRUNK_GRP_NAME);




