-- MZMOB-704 - Please filter the number range 447860015000 to 447860015009 in Mediation as part of PLM77
-- Also added other 116xxx numbers for filtering

insert into DN_FREEPHONE_CODES_SMS (SMS_CODE, DESCRIPTION) values ('116111', 'Child helpline');
insert into DN_FREEPHONE_CODES_SMS (SMS_CODE, DESCRIPTION) values ('116006', 'Helpline for victims of crime');
insert into DN_FREEPHONE_CODES_SMS (SMS_CODE, DESCRIPTION) values ('116117', 'Non-emergency medical on-call service');
insert into DN_FREEPHONE_CODES_SMS (SMS_CODE, DESCRIPTION) values ('116123', 'Emotional support helpline');
insert into DN_FREEPHONE_CODES_SMS (SMS_CODE, DESCRIPTION) values ('0786001500', 'OTA messages prefix');