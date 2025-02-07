-- MZMOB-502 - Create new views for monitoring solution roaming dashbaord
--
-- MZMOB-502 - New OCS IMS View
--
CREATE OR REPLACE VIEW MZ_MOB_DATA_OWNER.MONSOL_OCS_IMS_VOICE_ROAMING_3
AS SELECT o.created_date as mediation_insertion_time,
       to_date(o.cust_local_start_date, 'yyyymmddhh24miss') as call_event_time,
       i.mcc as mcc,
       i.mnc as mnc,
       CASE
 	  WHEN (UPPER (o.calling_roam_country) != 
	        'UNITED KINGDOM'
                AND o.service_flow = '1')
          THEN
                o.calling_roam_country
          WHEN (UPPER (o.called_roam_country) != 
                'UNITED KINGDOM'
                AND o.service_flow = '2')
          THEN
                o.called_roam_country
       END
          AS roam_country,
       CASE
          WHEN (UPPER (o.calling_roam_country) !=
                'UNITED KINGDOM'
                AND o.service_flow = '1')
          THEN
                'Outgoing'
          WHEN (UPPER (o.called_roam_country) !=
                'UNITED KINGDOM'
                AND o.service_flow = '2')
          THEN
                'Incoming'
       END
          AS call_direction,
       i.ims_charging_id as ims_charging_id,
       o.duration as ocs_duration
  FROM mz_mob_data_owner.cdr_input_ocs_voice o,
       mz_mob_data_owner.cdr_input_ims i
 WHERE ((UPPER (o.calling_roam_country) !=
           'UNITED KINGDOM'
         AND service_flow = '1')
         OR (UPPER (o.called_roam_country) !=
          'UNITED KINGDOM'
         AND service_flow = '2'))
   AND o.created_date > SYSDATE - (60 / 1440)
   AND o.duration > 0                    
   AND i.ims_charging_id = o.ims_charging_identifier
   AND i.record_type = 69
   AND i.role_of_node = o.service_flow - 1
   AND i.duration > 0                    
   AND i.created_date > SYSDATE - (80 / 1440);


-- MZMOB-502 - New SMSC View
--
CREATE OR REPLACE VIEW MZ_MOB_DATA_OWNER.MONSOL_SMSC_ROAMING_2
AS SELECT mediation_insertion_time as mediation_insertion_time, 
       event_time as event_time,
       t.mcc as mcc,
       t.mnc as mnc,
       t.country as roam_country,
       event_direction as event_diretion,
       sm_id as sm_id
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
          sm_id AS sm_id
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
) a
WHERE a.msc_address BETWEEN n.gt_start AND n.gt_stop
  AND n.rowid = (SELECT n2.rowid
                   FROM mz_mob_data_owner.gsma_gt_node n2
                  WHERE a.msc_address between n2.gt_start AND n2.gt_stop
                    AND rownum = 1)
  AND n.tadig = t.tadig;


-- MZMOB-502 - New PGW View
--
CREATE OR REPLACE VIEW MZ_MOB_DATA_OWNER.MONSOL_PGW_ROAMING_2
AS SELECT p.created_date as mediation_insertion_time,
          rec_open_time_utc as event_time_utc,
          p.mcc as mcc, 
          p.mnc as mnc, 
          t.country as roam_country,         
          CASE
              WHEN p.rat = 1 THEN '3G'
              WHEN p.rat = 2 THEN '2G'
              WHEN p.rat = 3 THEN 'WLAN'
              WHEN p.rat = 4 THEN 'GAN'
              WHEN p.rat = 5 THEN 'HSPA'
              WHEN p.rat = 6 THEN '4G'
              ELSE 'UNKNOWN'
          END
             AS access_type, 
            nvl(upvol1, 0) + nvl(downvol1, 0) 
          + nvl(upvol2, 0) + nvl(downvol2, 0) 
          + nvl(upvol3, 0) + nvl(downvol3, 0) 
          + nvl(upvol4, 0) + nvl(downvol4, 0) 
          + nvl(upvol5, 0) + nvl(downvol5, 0) as data_usage_bytes,
          p.chargingid as chargingid
  FROM mz_mob_data_owner.cdr_input_pgw p,
       mz_mob_data_owner.gsma_tadig t
 WHERE p.mcc != '234'
   AND p.mcc = t.mcc
   AND p.mnc = t.mnc
   AND p.created_date > SYSDATE - (30 / 1440)
   AND (nvl(upvol1, 0) > 0 or nvl(downvol1, 0) > 0 
        or nvl(upvol2, 0) > 0 or nvl(downvol2, 0) > 0 
        or nvl(upvol3, 0) > 0 or nvl(downvol3, 0) > 0 
        or nvl(upvol4, 0) > 0 or nvl(downvol4, 0) > 0 
        or nvl(upvol5, 0) > 0 or nvl(downvol5, 0) > 0);
  

-- 2019-02-19 - WLT - MZMOB-511
--
-- RETROSPECTIVELY ADDED THE FOLLOWING ADHOC DATAFIXES TO KEEP FUTURE BUILDS UP_TO_DATE
-- 
delete from mz_mob_data_owner.dn_freephone_prefix_codes
 where freephone_prefix_code = '0500';