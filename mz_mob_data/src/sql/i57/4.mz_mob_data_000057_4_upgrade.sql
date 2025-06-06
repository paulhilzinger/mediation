-- MZMOB-675. AMG. Use an APN reference table to determine VOLTE calls to IBS Create new table PGW_APN

CREATE TABLE "MZ_MOB_DATA_OWNER"."PGW_APN" 
(
	"TYPE"	VARCHAR2(20) NOT NULL,
	"APN"	VARCHAR2(32) NOT NULL,
	"DESCRIPTION"  VARCHAR2(32) NOT NULL
	 );

-- -- MZMOB-675. AMG. Adding the records in the the table PGW_APN 

INSERT INTO MZ_MOB_DATA_OWNER.PGW_APN (TYPE, APN, DESCRIPTION) VALUES ('VOLTE', 'imspreprod','TB1 Test');
INSERT INTO MZ_MOB_DATA_OWNER.PGW_APN (TYPE, APN,DESCRIPTION)  VALUES ('VOLTE', 'imsdev', 'TB2 Test');
INSERT INTO MZ_MOB_DATA_OWNER.PGW_APN (TYPE, APN,DESCRIPTION)  VALUES ('VOLTE', 'imsenglo', 'ENGLO Trial');
INSERT INTO MZ_MOB_DATA_OWNER.PGW_APN (TYPE, APN,DESCRIPTION)  VALUES ('VOLTE', 'imsmimnc', 'MIMNC Trial');
INSERT INTO MZ_MOB_DATA_OWNER.PGW_APN (TYPE, APN,DESCRIPTION)  VALUES ('VOLTE', 'ims', 'Production');