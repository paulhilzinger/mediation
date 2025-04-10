-- MZMOB-818 - Create a Sky SMSC SMSoWIFI and SMS-LTE TADIG lookup tables

-- Create Table SKY_SMSC_LTE_GT_ROI
CREATE TABLE SKY_SMSC_LTE_GT_ROI
(
  GT	VARCHAR2(25 BYTE),
  ROLE_OF_NODE	NUMBER,
  DESCRIPTION	VARCHAR2(40 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;

-- Create Table SKY_SMSC_WIFI_GT_ROI
CREATE TABLE SKY_SMSC_WIFI_GT_ROI
(
  GT	VARCHAR2(25 BYTE),
  ROLE_OF_NODE	NUMBER,
  DESCRIPTION	VARCHAR2(40 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;

