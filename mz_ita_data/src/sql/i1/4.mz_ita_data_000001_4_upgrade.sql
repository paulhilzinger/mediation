CREATE TABLE PREFIX_TO_KENAN_MAPPING
(
  PREFIX varchar2(20) NOT NULL,
  DESCRIPTION varchar2(200) NOT NULL,
  USAGE_TYPE varchar2(5),
  ANNOTATION varchar2(5)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE SERVICE_TO_KENAN_MAPPING
(
  SERVICE_TYPE varchar2(5) NOT NULL,
  SERVICE_ACTION varchar2(5) NOT NULL,
  DESCRIPTION varchar2(200) NOT NULL,
  USAGE_TYPE varchar2(5),
  ANNOTATION varchar2(5)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


-- INSERT INTO THE PREFIX TABLE
--
INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('112','Emergency - Police','2000','013#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('113','Emergency - Police','2000','013#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('114','Emergency - Child Line','2000','013#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('115','Emergency - Fire Department','2000','013#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('118','Emergency - Sanity','2000','013#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1920','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1921','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1922','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1923','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1924','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1925','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1926','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1927','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1928','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1929','Sky Customer Service','2000','010#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('700','Freephone - Internet Access Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1161','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1162','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1163','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1164','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1165','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1166','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1167','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1168','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1169','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('117','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1500','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1515','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1518','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1522','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1525','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1530','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('1544','Freephone - Public Utility Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16921','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16922','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16923','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16924','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16925','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16926','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16931','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16932','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16933','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16934','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16935','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16936','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16941','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16942','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16943','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16944','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16945','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16946','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16951','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16952','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16953','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16954','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16955','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16956','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16961','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16962','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16963','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16964','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16965','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16966','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16971','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16972','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16973','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16974','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16975','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16976','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16981','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16982','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16983','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16984','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16985','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16986','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16991','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16992','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16993','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16994','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16995','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('16996','Freephone - Social Communication Service','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('800','Freephone - Debit Services To Called Party','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('803','Freephone - Debit Services To Called Party','2005','018#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('124','Directory Information','2001','011#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('125','Directory Information','2001','011#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('126','Directory Information','2001','011#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('127','Directory Information','2001','011#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('128','Directory Information','2001','011#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('129','Directory Information','2001','011#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('42','Premium Rate - Internal Network Services','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('485','Premium Rate - Internal Network Services','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('5','Premium Rate - Nomadic Telephony Services','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('840','Premium Rate - Service With Split Charging','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('841','Premium Rate - Service With Split Charging','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('847','Premium Rate - Service With Split Charging','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('848','Premium Rate - Service With Split Charging','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('178','Premium Rate - Personal Or Unique Number Service','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('199','Premium Rate - Personal Or Unique Number Service','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('892','Premium Rate - Overprice Services VAS','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('895','Premium Rate - Overprice Services VAS','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('894','Premium Rate - Overprice Services VAS','2002','012#');

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('899','Premium Rate - Overprice Services VAS','2002','012#');


-- INSERT INTO THE SERVICE TYPE TABLE
--
INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('22','3','Alarm Call','2008','030#');

INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('5','3','Call Forwarding','2000','032#');

INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('7','3','Three Way Calling','2000','033#');

INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('1','3','Voice Mail','2016','040#');

INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('2','3','Auto Recall','2022','041#');

INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('32','3','Hidden Number','2000','043#');

INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('39','1','Do Not Disturb','2018','044#');

INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('39','2','Do Not Disturb','2018','044#');

INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('39','3','Do Not Disturb','2018','044#');

INSERT INTO SERVICE_TO_KENAN_MAPPING VALUES ('39','5','Do Not Disturb','2018','044#');