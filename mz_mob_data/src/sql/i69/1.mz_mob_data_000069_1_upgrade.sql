--MZMOB-752 Incorporate Sinch SMSC data into the existing Monitoring Solutions roaming views

  CREATE OR REPLACE VIEW "MZ_MOB_DATA_OWNER"."MONSOL_SMSC_ROAMING_3" ("MEDIATION_INSERTION_TIME", "EVENT_TIME", "MCC", "MNC", "ROAM_COUNTRY", "EVENT_DIRECTION", "SM_ID", "ORG_ACCOUNT", "DEST_ACCOUNT") AS 
  SELECT mediation_insertion_time as mediation_insertion_time, 
       event_time as event_time,
       t.mcc as mcc,
       t.mnc as mnc,
       t.country as roam_country,
       event_direction as event_direction,
       sm_id as sm_id,
       org_account as org_account,
       dest_account as dest_account       
  FROM mz_mob_data_owner.gsma_gt_node n,
       mz_mob_data_owner.gsma_tadig t,
(
SELECT s.created_date as mediation_insertion_time,
       to_date(substr(s.org_submission_time, 1, 4) ||
               substr(s.org_submission_time, 6, 2) ||
               substr(s.org_submission_time, 9, 2) || 
               substr(s.org_submission_time, 12, 2) ||
               substr(s.org_submission_time, 15, 2) ||
               substr(s.org_submission_time, 18, 2)
               , 'yyyymmddhh24miss') as event_time, 
       case 
          when (s.messagetype in (1, 2, 3, 4) and s.momscaddr like '281%')
             then rpad(substr(s.momscaddr, 4, length(s.momscaddr)), 15, '0')
          when (s.messagetype in (1, 2, 3, 4) and s.momscaddr not like '281%' and s.momscaddr not like '44%' )
             then rpad(s.momscaddr, 15, '0')
          when (s.messagetype in (5, 6, 16) and s.mtmscaddr like '281%')
             then rpad(substr(s.mtmscaddr, 4, length(s.mtmscaddr)), 15, '0')
          when (s.messagetype in (5, 6, 16) and s.mtmscaddr not like '281%' and s.mtmscaddr not like '44%' )
             then rpad(s.mtmscaddr, 15, '0')
       end
          as msc_address, 
       case
          when s.messagetype in (1, 2, 3, 4)
             then 'Outgoing'
          when s.messagetype in (5, 6, 16)
             then 'Incoming'
       end
          as event_direction,
          sm_id AS sm_id,
          org_account as org_account,
          dest_account as dest_account
  FROM mz_mob_data_owner.cdr_input_smsc s
 WHERE smstatus = 1
   AND created_date > SYSDATE - (30 / 1440)
   AND ( 
         ( s.messagetype in (1, 2, 3, 4) AND 
           s.momscaddr not like '44%')
         OR
         ( s.messagetype in (5, 6, 16) AND 
           s.mtmscaddr not like '44%' ) 
       )
UNION ALL
SELECT s.created_date as mediation_insertion_time,
       to_date(s.entry_ts,'yyyymmddhh24miss')
	   as event_time, 
       case 
          when (s.record_type = 02 and s.orig_msc like '281%')
             then rpad(substr(s.orig_msc, 4, length(s.orig_msc)), 15, '0')
          when (s.record_type = 02 and s.orig_msc not like '281%' and s.orig_msc not like '44%' )
             then rpad(s.orig_msc, 15, '0')
          when (s.record_type in (01, 09) and s.dest_msc like '281%')
             then rpad(substr(s.dest_msc, 4, length(s.dest_msc)), 15, '0')
          when (s.record_type in (01, 09) and s.dest_msc not like '281%' and s.dest_msc not like '44%' )
             then rpad(s.dest_msc, 15, '0')
       end
          as msc_address, 
       case
          when s.record_type = 02
             then 'Outgoing'
          when s.record_type in (01, 09)
             then 'Incoming'
       end
          as event_direction,
          seq_num AS sm_id,
          src_name as org_account,
          sink_name as dest_account
  FROM mz_mob_data_owner.cdr_input_smsc_sinch s
 WHERE s_state in ('Delivered','Delivered direct')
   AND created_date > SYSDATE - (30 / 1440)
   AND ( 
         ( s.record_type = 02 AND 
           s.orig_msc not like '44%')
         OR
         ( s.record_type in (01, 09) AND 
           s.dest_msc not like '44%' ) 
       )
) a
WHERE a.msc_address BETWEEN n.gt_start AND n.gt_stop
  AND n.rowid = (SELECT n2.rowid
                   FROM mz_mob_data_owner.gsma_gt_node n2
                  WHERE a.msc_address between n2.gt_start AND n2.gt_stop
                    AND rownum = 1)
AND n.tadig = t.tadig;
