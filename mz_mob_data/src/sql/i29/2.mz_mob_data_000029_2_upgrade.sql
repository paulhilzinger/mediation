-- MZMOB-389 - Handle SMSC shortcodes for IBS
--
CREATE TABLE SKY_SHORTCODE_ACCOUNT
(
  SHORTCODE_ACCOUNT	VARCHAR2(30 BYTE),
  DESCRIPTION	VARCHAR2(40 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


-- INSERT SHORTCODE ACCOUNTS
--
INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'MMSC', 'Sky SMSC Shortcode Account'); 

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'OCS_GFEP', 'Sky SMSC Shortcode Account');

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'OTA', 'Sky SMSC Shortcode Account');

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'SKY_VMS', 'Sky SMSC Shortcode Account');

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'SKY_VVG', 'Sky SMSC Shortcode Account');

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'SKY_VVM', 'Sky SMSC Shortcode Account');

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'SKY_WSMS', 'Sky SMSC Shortcode Account');

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'TEST1', 'Sky SMSC Shortcode Account');

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'Gateway_G', 'Sky SMSC Shortcode Account');

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'SKYTEST2', 'Sky SMSC Shortcode Account');

INSERT INTO SKY_SHORTCODE_ACCOUNT ( SHORTCODE_ACCOUNT,
DESCRIPTION ) VALUES (
'TEST', 'Sky SMSC Shortcode Account');