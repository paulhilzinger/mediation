-- MZMOB-850 Incorporate Sinch SMSC Welcome messages into the Monitoring Solutions view
CREATE OR REPLACE VIEW MZ_MOB_DATA_OWNER.MONSOL_SMSC_ROAMING_4
AS SELECT created_date as mediation_insertion_time, 
          to_date(substr(s.org_submission_time, 1, 4) ||
                  substr(s.org_submission_time, 6, 2) ||
                  substr(s.org_submission_time, 9, 2) || 
                  substr(s.org_submission_time, 12, 2) ||
                  substr(s.org_submission_time, 15, 2) ||
                  substr(s.org_submission_time, 18, 2)
                  , 'yyyymmddhh24miss') as event_time, 
          sm_id as sm_id,
          org_account as org_account,
          dest_account as dest_account,
          mtmscaddr as mtmscaddr,
          locussmstatus as locussmstatus
  FROM mz_mob_data_owner.cdr_input_smsc s
 WHERE org_account = 'SKY_WSMS'
   AND created_date > SYSDATE - (30 / 1440)
UNION ALL
  SELECT created_date as mediation_insertion_time, 
          to_date(s.entry_ts,'yyyymmddhh24miss')
          as event_time, 
          seq_num as sm_id,
          src_name as org_account,
          sink_name as dest_account,
          dest_msc as mtmscaddr,
          s_state as locussmstatus
  FROM mz_mob_data_owner.cdr_input_smsc_sinch s
 WHERE src_name in ('CEL_WSMS','CEL_WSMS_BACKUP','WSMS')
   AND created_date > SYSDATE - (30 / 1440);