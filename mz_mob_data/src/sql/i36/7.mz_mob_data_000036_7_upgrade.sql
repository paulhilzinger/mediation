-- MZMOB-469 - Create new voice view for Monitoring Solutions to help with roaming monitoring and alerting
--
CREATE OR REPLACE VIEW MZ_MOB_DATA_OWNER.MONSOL_OCS_IMS_VOICE_ROAMING_2
(
   MEDIATION_INSERTION_TIME,
   CALL_EVENT_TIME,
   MCC,
   MNC,
   ROAM_COUNTRY,
   CALL_DIRECTION,
   IMS_CHARGING_ID
)
AS
SELECT o.created_date as mediation_insertion_time,
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
       i.ims_charging_id as ims_charging_id          
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
   AND i.created_date > SYSDATE - (80 / 1440)
;


-- MZMOB-469 - Create new data view for Monitoring Solutions to help with roaming monitoring and alerting
--
CREATE OR REPLACE VIEW MZ_MOB_DATA_OWNER.MONSOL_PGW_ROAMING
(
   EVENT_INTERVAL,
   MCC,
   MNC,
   ROAM_COUNTRY,   
   ACCESS_TYPE,
   DATA_USAGE_BYTES
)
AS
SELECT substr(recordopeningtime, 1, 10) || ' ' || substr(recordopeningtime, 12, 2) || ':' || substr(recordopeningtime, 15, 1)  || '0:00' as event_interval,
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
         sum(nvl(upvol1, 0) + nvl(downvol1, 0) + nvl(upvol2, 0) + nvl(downvol2, 0) + nvl(upvol3, 0) + nvl(downvol3,0) + nvl(upvol4, 0) + nvl(downvol4, 0) + nvl(upvol5, 0) + nvl(downvol5, 0)) as data_usage_bytes
  FROM mz_mob_data_owner.cdr_input_pgw p,
       mz_mob_data_owner.gsma_tadig t
 WHERE p.mcc != '234'
   AND p.mcc = t.mcc
   AND t.mnc = t.mnc
   AND p.created_date > SYSDATE - (20 / 1440)
   AND (upvol1 > 0 or downvol1 > 0 or upvol2 > 0 or downvol2 > 0 or upvol3 > 0 or downvol3 > 0 or upvol4 > 0 or downvol4 > 0 or upvol5 > 0 or downvol5 > 0)
 GROUP BY substr(recordopeningtime, 1, 10) || ' ' || substr(recordopeningtime, 12, 2) || ':' || substr(recordopeningtime, 15, 1)  || '0:00', t.country, p.mcc, p.mnc, p.rat
;


-- MZMOB-469 - Create new SMS view for Monitoring Solutions to help with roaming monitoring and alerting
--
CREATE OR REPLACE VIEW MZ_MOB_DATA_OWNER.MONSOL_SMSC_ROAMING
(
   EVENT_INTERVAL,
   MCC,
   MNC,
   ROAM_COUNTRY,
   EVENT_DIRECTION,
   SMS_MESSAGE_COUNT
)
AS
SELECT event_interval as event_interval,
       t.mcc as mcc,
       t.mnc as mnc,
       t.country as roam_country,
       event_direction as event_diretion,
       sms_message_count as sms_message_count
  FROM mz_mob_data_owner.gsma_gt_node n,
       mz_mob_data_owner.gsma_tadig t,
(
SELECT event_interval as event_interval,
       msc_address as msc_address,
       event_direction as event_direction,
       count(1) as sms_message_count
  FROM
(
SELECT substr(s.org_submission_time, 1, 4) || '-' || 
       substr(s.org_submission_time, 6, 2) || '-' ||
       substr(s.org_submission_time, 9, 2) ||
       substr(s.org_submission_time, 11, 5) || '0:00'
       as event_interval,
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
          as event_direction
  FROM mz_mob_data_owner.cdr_input_smsc s
 WHERE smstatus = 1
   AND created_date > SYSDATE - (20 / 1440)
   AND ( 
         ( s.messagetype in (1, 2, 3, 4) AND 
           s.momscaddr not like '44%')
         OR
         ( s.messagetype in (5, 6, 16) AND 
           s.mtmscaddr not like '44%' ) 
       )
) t
GROUP BY event_interval, msc_address, event_direction
) a
WHERE a.msc_address BETWEEN n.gt_start AND n.gt_stop
  AND n.rowid = (SELECT n2.rowid
                   FROM mz_mob_data_owner.gsma_gt_node n2
                  WHERE a.msc_address between n2.gt_start AND n2.gt_stop
                    AND rownum = 1)
  AND n.tadig = t.tadig
;
