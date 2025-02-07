-- Create CDR_INPUT_PGW_NOKIA table
-- MZMOB-775. Nokia PGW Mediation Functions Ro
--
CREATE TABLE MZ_MOB_DATA_OWNER.CDR_INPUT_PGW_NOKIA_ROI
(
	"TRANSACTION_ID" NUMBER NOT NULL, 
	"CREATED_DATE" DATE DEFAULT sysdate NOT NULL, 
	"INPUT_FILENAME" VARCHAR2(80 BYTE), 
	"SERVED_MSISDN" VARCHAR2(40 BYTE), 	
	"MSISDN" VARCHAR2(30 BYTE), 
	"IMSI" VARCHAR2(20 BYTE), 
	"IMEI" VARCHAR2(20 BYTE), 
	"RAT" NUMBER(*,0), 
	"RECORDOPENINGTIME" VARCHAR2(30 BYTE), 
	"REC_OPEN_TIME_UTC" DATE, 
	"MSTZ" VARCHAR2(10 BYTE), 
	"DURATION" NUMBER(15,0), 
	"CAUSE_REC_CLOSE" NUMBER(*,0), 
	"CHARGINGID" NUMBER(*,0), 
	"LOCAL_SEQ_NUM" NUMBER(*,0), 
	"SEQ_NUM" NUMBER(*,0), 
	"APN" VARCHAR2(80 BYTE), 
	"ULI_ORIGINAL" VARCHAR2(50 BYTE), 
	"MCC" VARCHAR2(5 BYTE), 
	"MNC" VARCHAR2(5 BYTE), 
	"LAC" VARCHAR2(10 BYTE), 
	"CI" VARCHAR2(10 BYTE), 
	"SAC" VARCHAR2(20 BYTE), 
	"RAC" VARCHAR2(5 BYTE), 
	"TAC" VARCHAR2(20 BYTE), 
	"ECI" VARCHAR2(20 BYTE),
	"SMENB" VARCHAR2(5 BYTE),			-- MAIN LEVEL SMENB FLAG
	"ENODEB_ID" VARCHAR2(50 BYTE),			-- MAIN LEVEL ENODEB ID	
	"SERVING_NODE_TYPE" VARCHAR2(5 BYTE), 
	"STARTTIME" VARCHAR2(30 BYTE), 
	"STOPTIME" VARCHAR2(30 BYTE), 
	"IPADD" VARCHAR2(50 BYTE),			-- PDPPDN IP ADDRESS
	"UWAN_IPADD" VARCHAR2(50),			-- RAW UWAN DATA
	"UE_IP" VARCHAR2(50),				-- UWAN DATA IN IP NOTATION
	"INCOMP_CDR_IND_ACRLOST_START" VARCHAR2(1),	-- FAILOVER FIELDS
	"INCOMP_CDR_IND_ACRLOST_INTRM" NUMBER,
	"INCOMP_CDR_IND_ACRLOST_STOP" VARCHAR2(1),
	"SESSION_ID" VARCHAR2(200 BYTE),
	"PGW_ADDRESS" VARCHAR2(50 BYTE),
	"RECORD_CLOSURE_TIME" VARCHAR2(30 BYTE),
	"QCI" NUMBER(20,0),				-- MAIN QOS FIELDS
	"MAX_REQ_BW_UL" NUMBER(20,0),
	"MAX_REQ_BW_DL" NUMBER(20,0),
	"GUARANTEED_BR_UL" NUMBER(20,0),
	"GUARANTEED_BR_DL" NUMBER(20,0),
	"ARP" NUMBER(20,0),
	"APN_AGGR_MAX_BR_UL" NUMBER(20,0),
	"APN_AGGR_MAX_BR_DL" NUMBER(20,0),
	"EXT_MAX_REQ_BW_UL" NUMBER(20,0),
	"EXT_MAX_REQ_BW_DL" NUMBER(20,0),
	"EXT_APN_AM_BR_UL" NUMBER(20,0),
	"EXT_APN_AM_BR_DL" NUMBER(20,0),
	"RATING_GRP1" NUMBER(*,0),			-- START OF TEN DATA SERVICE CONTAINERS
	"FIRST_USAGE1" VARCHAR2(30 BYTE), 
	"LAST_USAGE1" VARCHAR2(30 BYTE), 
	"TIME_USAGE1" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE1" VARCHAR2(40 BYTE), 
	"SVCUPVOL1" NUMBER(20,0), 
	"SVCDOWNVOL1" NUMBER(20,0), 
	"RAT1" NUMBER(*,0), 
	"LOCAL_SEQ_NUM1" NUMBER(20,0), 
	"AF_CHARGING_ID_1" VARCHAR2(128),
	"UE_IP_1" VARCHAR2(50),
	"ULI_ORIG1" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS 
	"MCC1" VARCHAR2(5 BYTE), 
	"MNC1" VARCHAR2(5 BYTE), 
	"LAC1" VARCHAR2(10 BYTE), 
	"CI1" VARCHAR2(10 BYTE), 
	"SAC1" VARCHAR2(20 BYTE), 
	"RAC1" VARCHAR2(5 BYTE), 
	"TAC1" VARCHAR2(20 BYTE), 
	"ECI1" VARCHAR2(20 BYTE), 	
	"SMENB1" VARCHAR2(5 BYTE),
	"ENODEB_ID1" VARCHAR2(50 BYTE),
	"QCI1"	VARCHAR2(5 BYTE),	
	"RATING_GRP2" NUMBER(*,0), 
	"FIRST_USAGE2" VARCHAR2(30 BYTE), 
	"LAST_USAGE2" VARCHAR2(30 BYTE),
	"TIME_USAGE2" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE2" VARCHAR2(40 BYTE), 
	"SVCUPVOL2" NUMBER(20,0), 
	"SVCDOWNVOL2" NUMBER(20,0), 
	"RAT2" NUMBER(*,0), 
	"LOCAL_SEQ_NUM2" NUMBER(20,0), 
	"AF_CHARGING_ID_2" VARCHAR2(128),
	"UE_IP_2" VARCHAR2(50),
	"ULI_ORIG2" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS 
	"MCC2" VARCHAR2(5 BYTE), 
	"MNC2" VARCHAR2(5 BYTE), 
	"LAC2" VARCHAR2(10 BYTE), 
	"CI2" VARCHAR2(10 BYTE), 
	"SAC2" VARCHAR2(20 BYTE), 
	"RAC2" VARCHAR2(5 BYTE), 
	"TAC2" VARCHAR2(20 BYTE), 
	"ECI2" VARCHAR2(20 BYTE), 	
	"SMENB2" VARCHAR2(5 BYTE),
	"ENODEB_ID2" VARCHAR2(50 BYTE),
	"QCI2"	VARCHAR2(5 BYTE),
	"RATING_GRP3" NUMBER(*,0), 
	"FIRST_USAGE3" VARCHAR2(30 BYTE), 
	"LAST_USAGE3" VARCHAR2(30 BYTE),
	"TIME_USAGE3" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE3" VARCHAR2(40 BYTE), 
	"SVCUPVOL3" NUMBER(20,0), 
	"SVCDOWNVOL3" NUMBER(20,0), 
	"RAT3" NUMBER(*,0), 
	"LOCAL_SEQ_NUM3" NUMBER(20,0), 
	"AF_CHARGING_ID_3" VARCHAR2(128),
	"UE_IP_3" VARCHAR2(50),
	"ULI_ORIG3" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS 
	"MCC3" VARCHAR2(5 BYTE), 
	"MNC3" VARCHAR2(5 BYTE), 
	"LAC3" VARCHAR2(10 BYTE), 
	"CI3" VARCHAR2(10 BYTE), 
	"SAC3" VARCHAR2(20 BYTE), 
	"RAC3" VARCHAR2(5 BYTE), 
	"TAC3" VARCHAR2(20 BYTE), 
	"ECI3" VARCHAR2(20 BYTE), 	
	"SMENB3" VARCHAR2(5 BYTE),
	"ENODEB_ID3" VARCHAR2(50 BYTE),
	"QCI3"	VARCHAR2(5 BYTE),	
	"RATING_GRP4" NUMBER(*,0), 
	"FIRST_USAGE4" VARCHAR2(30 BYTE), 
	"LAST_USAGE4" VARCHAR2(30 BYTE),
	"TIME_USAGE4" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE4" VARCHAR2(40 BYTE), 
	"SVCUPVOL4" NUMBER(20,0), 
	"SVCDOWNVOL4" NUMBER(20,0), 
	"RAT4" NUMBER(*,0), 
	"LOCAL_SEQ_NUM4" NUMBER(20,0), 
	"AF_CHARGING_ID_4" VARCHAR2(128),
	"UE_IP_4" VARCHAR2(50),
	"ULI_ORIG4" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS  
	"MCC4" VARCHAR2(5 BYTE), 
	"MNC4" VARCHAR2(5 BYTE), 
	"LAC4" VARCHAR2(10 BYTE), 
	"CI4" VARCHAR2(10 BYTE), 
	"SAC4" VARCHAR2(20 BYTE), 
	"RAC4" VARCHAR2(5 BYTE), 
	"TAC4" VARCHAR2(20 BYTE), 
	"ECI4" VARCHAR2(20 BYTE), 	
	"SMENB4" VARCHAR2(5 BYTE),
	"ENODEB_ID4" VARCHAR2(50 BYTE),
	"QCI4"	VARCHAR2(5 BYTE), 	
	"RATING_GRP5" NUMBER(*,0), 
	"FIRST_USAGE5" VARCHAR2(30 BYTE), 
	"LAST_USAGE5" VARCHAR2(30 BYTE),
	"TIME_USAGE5" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE5" VARCHAR2(40 BYTE), 
	"SVCUPVOL5" NUMBER(20,0), 
	"SVCDOWNVOL5" NUMBER(20,0), 
	"RAT5" NUMBER(*,0), 
	"LOCAL_SEQ_NUM5" NUMBER(20,0), 
	"AF_CHARGING_ID_5" VARCHAR2(128),	
	"UE_IP_5" VARCHAR2(50),
	"ULI_ORIG5" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS 
	"MCC5" VARCHAR2(5 BYTE), 
	"MNC5" VARCHAR2(5 BYTE), 
	"LAC5" VARCHAR2(10 BYTE), 
	"CI5" VARCHAR2(10 BYTE), 
	"SAC5" VARCHAR2(20 BYTE), 
	"RAC5" VARCHAR2(5 BYTE), 
	"TAC5" VARCHAR2(20 BYTE), 
	"ECI5" VARCHAR2(20 BYTE), 	
	"SMENB5" VARCHAR2(5 BYTE),
	"ENODEB_ID5" VARCHAR2(50 BYTE),
	"QCI5"	VARCHAR2(5 BYTE),	
	"RATING_GRP6" NUMBER(*,0), 
	"FIRST_USAGE6" VARCHAR2(30 BYTE), 
	"LAST_USAGE6" VARCHAR2(30 BYTE),
	"TIME_USAGE6" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE6" VARCHAR2(40 BYTE), 
	"SVCUPVOL6" NUMBER(20,0), 
	"SVCDOWNVOL6" NUMBER(20,0), 
	"RAT6" NUMBER(*,0), 
	"LOCAL_SEQ_NUM6" NUMBER(20,0), 
	"AF_CHARGING_ID_6" VARCHAR2(128),	
	"UE_IP_6" VARCHAR2(50),
	"ULI_ORIG6" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS 
	"MCC6" VARCHAR2(5 BYTE), 
	"MNC6" VARCHAR2(5 BYTE), 
	"LAC6" VARCHAR2(10 BYTE), 
	"CI6" VARCHAR2(10 BYTE), 
	"SAC6" VARCHAR2(20 BYTE), 
	"RAC6" VARCHAR2(5 BYTE), 
	"TAC6" VARCHAR2(20 BYTE), 
	"ECI6" VARCHAR2(20 BYTE), 	
	"SMENB6" VARCHAR2(5 BYTE),
	"ENODEB_ID6" VARCHAR2(50 BYTE),
	"QCI6"	VARCHAR2(5 BYTE),	
	"RATING_GRP7" NUMBER(*,0), 
	"FIRST_USAGE7" VARCHAR2(30 BYTE), 
	"LAST_USAGE7" VARCHAR2(30 BYTE),
	"TIME_USAGE7" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE7" VARCHAR2(40 BYTE), 
	"SVCUPVOL7" NUMBER(20,0), 
	"SVCDOWNVOL7" NUMBER(20,0), 
	"RAT7" NUMBER(*,0), 
	"LOCAL_SEQ_NUM7" NUMBER(20,0), 
	"AF_CHARGING_ID_7" VARCHAR2(128),
	"UE_IP_7" VARCHAR2(50),
	"ULI_ORIG7" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS 
	"MCC7" VARCHAR2(5 BYTE), 
	"MNC7" VARCHAR2(5 BYTE), 
	"LAC7" VARCHAR2(10 BYTE), 
	"CI7" VARCHAR2(10 BYTE), 
	"SAC7" VARCHAR2(20 BYTE), 
	"RAC7" VARCHAR2(5 BYTE), 
	"TAC7" VARCHAR2(20 BYTE), 
	"ECI7" VARCHAR2(20 BYTE), 	
	"SMENB7" VARCHAR2(5 BYTE),
	"ENODEB_ID7" VARCHAR2(50 BYTE),
	"QCI7"	VARCHAR2(5 BYTE),	
	"RATING_GRP8" NUMBER(*,0), 
	"FIRST_USAGE8" VARCHAR2(30 BYTE), 
	"LAST_USAGE8" VARCHAR2(30 BYTE),
	"TIME_USAGE8" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE8" VARCHAR2(40 BYTE), 
	"SVCUPVOL8" NUMBER(20,0), 
	"SVCDOWNVOL8" NUMBER(20,0), 
	"RAT8" NUMBER(*,0), 
	"LOCAL_SEQ_NUM8" NUMBER(20,0), 
	"AF_CHARGING_ID_8" VARCHAR2(128),	
	"UE_IP_8" VARCHAR2(50),
	"ULI_ORIG8" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS 
	"MCC8" VARCHAR2(5 BYTE), 
	"MNC8" VARCHAR2(5 BYTE), 
	"LAC8" VARCHAR2(10 BYTE), 
	"CI8" VARCHAR2(10 BYTE), 
	"SAC8" VARCHAR2(20 BYTE), 
	"RAC8" VARCHAR2(5 BYTE), 
	"TAC8" VARCHAR2(20 BYTE), 
	"ECI8" VARCHAR2(20 BYTE), 	
	"SMENB8" VARCHAR2(5 BYTE),
	"ENODEB_ID8" VARCHAR2(50 BYTE),
	"QCI8"	VARCHAR2(5 BYTE),	
	"RATING_GRP9" NUMBER(*,0), 
	"FIRST_USAGE9" VARCHAR2(30 BYTE), 
	"LAST_USAGE9" VARCHAR2(30 BYTE),
	"TIME_USAGE9" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE9" VARCHAR2(40 BYTE), 
	"SVCUPVOL9" NUMBER(20,0), 
	"SVCDOWNVOL9" NUMBER(20,0), 
	"RAT9" NUMBER(*,0), 
	"LOCAL_SEQ_NUM9" NUMBER(20,0), 
	"AF_CHARGING_ID_9" VARCHAR2(128),	
	"UE_IP_9" VARCHAR2(50),
	"ULI_ORIG9" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS 
	"MCC9" VARCHAR2(5 BYTE), 
	"MNC9" VARCHAR2(5 BYTE), 
	"LAC9" VARCHAR2(10 BYTE), 
	"CI9" VARCHAR2(10 BYTE), 
	"SAC9" VARCHAR2(20 BYTE), 
	"RAC9" VARCHAR2(5 BYTE), 
	"TAC9" VARCHAR2(20 BYTE), 
	"ECI9" VARCHAR2(20 BYTE), 	
	"SMENB9" VARCHAR2(5 BYTE),
	"ENODEB_ID9" VARCHAR2(50 BYTE),
	"QCI9"	VARCHAR2(5 BYTE),	
	"RATING_GRP10" NUMBER(*,0), 
	"FIRST_USAGE10" VARCHAR2(30 BYTE), 
	"LAST_USAGE10" VARCHAR2(30 BYTE),
	"TIME_USAGE10" VARCHAR2(30 BYTE),
	"SVC_COND_CHANGE10" VARCHAR2(40 BYTE), 
	"SVCUPVOL10" NUMBER(20,0), 
	"SVCDOWNVOL10" NUMBER(20,0), 
	"RAT10" NUMBER(*,0), 
	"LOCAL_SEQ_NUM10" NUMBER(20,0),
	"AF_CHARGING_ID_10" VARCHAR2(128),
	"UE_IP_10" VARCHAR2(50),
	"ULI_ORIG10" VARCHAR2(50 BYTE),			-- THESE ARE ULI FIELDS 
	"MCC10" VARCHAR2(5 BYTE), 
	"MNC10" VARCHAR2(5 BYTE), 
	"LAC10" VARCHAR2(10 BYTE), 
	"CI10" VARCHAR2(10 BYTE), 
	"SAC10" VARCHAR2(20 BYTE), 
	"RAC10" VARCHAR2(5 BYTE), 
	"TAC10" VARCHAR2(20 BYTE), 
	"ECI10" VARCHAR2(20 BYTE), 	
	"SMENB10" VARCHAR2(5 BYTE),
	"ENODEB_ID10" VARCHAR2(50 BYTE),
	"QCI10"	VARCHAR2(5 BYTE),
    "SERVINGNODEPLMNID"	VARCHAR2(6 BYTE),
	"DATAVOLUMEUPLINK_5G"	NUMBER(20,0),
	"DATAVOLUMEDOWNLINK_5G"	NUMBER(20,0),
	"RANSTARTTIME_5G"	VARCHAR2(30 BYTE),
	"RANENDTIME_5G"	VARCHAR2(30 BYTE),
	"SECONDARYRATTYPE_5G"	VARCHAR2(5 BYTE)		
) 
SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE MZ_MOB_CDR_DATA
partition by range(CREATED_DATE)
(
  PARTITION PMAXVALUE  VALUES LESS THAN (MAXVALUE) TABLESPACE  MZ_MOB_CDR_DATA
);

-- Create Indexes on CDR_INPUT_PGW_NOKIA_ROI
--
CREATE INDEX CDR_INPUT_PGW_ROI_IDX1 ON CDR_INPUT_PGW_NOKIA_ROI (CREATED_DATE) LOCAL;

CREATE INDEX CDR_INPUT_PGW_ROI_IDX2 ON CDR_INPUT_PGW_NOKIA_ROI (TRANSACTION_ID) LOCAL;

CREATE INDEX CDR_INPUT_PGW_ROI_IDX3 ON CDR_INPUT_PGW_NOKIA_ROI (MSISDN) LOCAL;