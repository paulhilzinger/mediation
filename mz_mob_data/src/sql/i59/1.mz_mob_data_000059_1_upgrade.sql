-- MZMOB-704 - Please filter the number range 447860015000 to 447860015009 in Mediation as part of PLM77
-- Adding Text relays

--delete redundant entry
delete from MZ_MOB_DATA_OWNER.DN_FREEPHONE_CODES_SMS where SMS_CODE = '18001111';

--add text relay prefix
insert into MZ_MOB_DATA_OWNER.DN_FREEPHONE_CODES_SMS (SMS_CODE, DESCRIPTION) values ('18000', 'Text relay emergency');
insert into MZ_MOB_DATA_OWNER.DN_FREEPHONE_CODES_SMS (SMS_CODE, DESCRIPTION) values ('18001', 'Text relay prefix');
insert into MZ_MOB_DATA_OWNER.DN_FREEPHONE_CODES_SMS (SMS_CODE, DESCRIPTION) values ('18002', 'Text relay prefix');