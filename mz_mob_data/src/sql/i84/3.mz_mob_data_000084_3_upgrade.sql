create table CHF_APN (
   TYPE VARCHAR2(20 BYTE),
   APN VARCHAR2(32 BYTE),
   DESCRIPTION VARCHAR2(32 BYTE)
);

insert into CHF_APN (type, apn, description) values ('CHFVL', 'imspreprod', 'TB1 Test');
insert into CHF_APN (type, apn, description) values ('CHFVL', 'imsdev', 'TB2 Test');
insert into CHF_APN (type, apn, description) values ('CHFVL', 'imsenglo', 'ENGLO Trial');
insert into CHF_APN (type, apn, description) values ('CHFVL', 'imsenbgk', 'ENBGK Trial');
insert into CHF_APN (type, apn, description) values ('CHFVL', 'imsenlcs', 'ENLCS Trial');
insert into CHF_APN (type, apn, description) values ('CHFVL', 'imsmimnc', 'MIMNC Trial');
insert into CHF_APN (type, apn, description) values ('CHFVL', 'ims', 'Production');