
-- 2024-04-24.AMG.MZITA-258. CR for new flow from Mediation RTR to SMC

INSERT INTO SKYIT_PARAMETERS VALUES ('RTR_SMC_ALL_STATES', '7', 'CSO (SMS)');
INSERT INTO SKYIT_PARAMETERS VALUES ('RTR_SMC_ALL_STATES', '16', 'CSO (SMS)');
INSERT INTO SKYIT_PARAMETERS VALUES ('RTR_SMC_ALL_STATES', '18', 'CSO (SMS)');

delete from mz_ita_rtr_data_owner.skyit_parameters
where parameter like 'RTR_RESET%';
insert into mz_ita_rtr_data_owner.skyit_parameters              
values ('RTR_RESET_WF0103_TIMESEQUENCE_v4', '0', 'set to 1 to reset timesequence history for RTR.WF0103_Time_Sequence_Check.v4');
insert into mz_ita_rtr_data_owner.skyit_parameters              
values ('RTR_RESET_WF0103_TIMESEQUENCE_v6', '0', 'set to 1 to reset timesequence history for RTR.WF0103_Time_Sequence_Check.v6');
insert into mz_ita_rtr_data_owner.skyit_parameters              
values ('RTR_RESET_WF0107_UNIQSESS_REG_v4', '0', 'set to 1 to reset uniqsess reporting registry for RTR.WF0107_Report_trigger.v4');
insert into mz_ita_rtr_data_owner.skyit_parameters              
values ('RTR_RESET_WF0107_UNIQSESS_REG_v6', '0', 'set to 1 to reset uniqsess reporting registry for RTR.WF0103_Report_trigger.v6');
