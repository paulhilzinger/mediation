--MZMOB-793 Incorporate Nokia IMS into the MZ_MOB_DATA_OWNER.MONSOL_OCS_IMS_VOICE_ROAMING_3 view
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
   AND i.created_date > SYSDATE - (80 / 1440)
UNION ALL
SELECT oa.created_date as mediation_insertion_time,
       to_date(oa.event_local_start_time, 'yyyymmddhh24miss') as call_event_time,
       i.mcc as mcc,
       i.mnc as mnc,
       CASE
 	  WHEN (UPPER (oa.roaming_country_name_calling) !=
	        'UNITED KINGDOM'
                AND oa.call_direction = '1')
          THEN
                oa.roaming_country_name_calling
          WHEN (UPPER (oa.roam_country_name_called) !=
                'UNITED KINGDOM'
                AND oa.call_direction = '2')
          THEN
                oa.roam_country_name_called
       END
          AS roam_country,
       CASE
          WHEN (UPPER (oa.roaming_country_name_calling) !=
                'UNITED KINGDOM'
                AND oa.call_direction = '1')
          THEN
                'Outgoing'
          WHEN (UPPER (oa.roam_country_name_called) !=
                'UNITED KINGDOM'
                AND oa.call_direction = '2')
          THEN
                'Incoming'
       END
          AS call_direction,
       i.ims_charging_id as ims_charging_id,
       oa.duration as ocs_duration
  FROM mz_mob_data_owner.cdr_input_ocs_voice_amdocs oa,
       mz_mob_data_owner.cdr_input_ims i
 WHERE ((UPPER (oa.roaming_country_name_calling) !=
           'UNITED KINGDOM'
         AND oa.call_direction = '1')
         OR (UPPER (oa.roam_country_name_called) !=
          'UNITED KINGDOM'
         AND oa.call_direction = '2'))
   AND oa.created_date > SYSDATE - (60 / 1440)
   AND oa.duration > 0                    
   AND i.ims_charging_id = oa.ims_identifier
   AND i.record_type = 69
   AND i.role_of_node = oa.call_direction - 1
   AND i.duration > 0                    
AND i.created_date > SYSDATE - (80 / 1440)

--Nokia IMS Starts here

UNION ALL
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
       i.ims_charging_id as ims_charging_id,
       o.duration as ocs_duration
  FROM mz_mob_data_owner.cdr_input_ocs_voice o,
       mz_mob_data_owner.cdr_input_ims_nokia i
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
UNION ALL
SELECT oa.created_date as mediation_insertion_time,
       to_date(oa.event_local_start_time, 'yyyymmddhh24miss') as call_event_time,
       i.mcc as mcc,
       i.mnc as mnc,
       CASE
 	  WHEN (UPPER (oa.roaming_country_name_calling) !=
	        'UNITED KINGDOM'
                AND oa.call_direction = '1')
          THEN
                oa.roaming_country_name_calling
          WHEN (UPPER (oa.roam_country_name_called) !=
                'UNITED KINGDOM'
                AND oa.call_direction = '2')
          THEN
                oa.roam_country_name_called
       END
          AS roam_country,
       CASE
          WHEN (UPPER (oa.roaming_country_name_calling) !=
                'UNITED KINGDOM'
                AND oa.call_direction = '1')
          THEN
                'Outgoing'
          WHEN (UPPER (oa.roam_country_name_called) !=
                'UNITED KINGDOM'
                AND oa.call_direction = '2')
          THEN
                'Incoming'
       END
          AS call_direction,
       i.ims_charging_id as ims_charging_id,
       oa.duration as ocs_duration
  FROM mz_mob_data_owner.cdr_input_ocs_voice_amdocs oa,
       mz_mob_data_owner.cdr_input_ims_nokia i
 WHERE ((UPPER (oa.roaming_country_name_calling) !=
           'UNITED KINGDOM'
         AND oa.call_direction = '1')
         OR (UPPER (oa.roam_country_name_called) !=
          'UNITED KINGDOM'
         AND oa.call_direction = '2'))
   AND oa.created_date > SYSDATE - (60 / 1440)
   AND oa.duration > 0                    
   AND i.ims_charging_id = oa.ims_identifier
   AND i.record_type = 69
   AND i.role_of_node = oa.call_direction - 1
   AND i.duration > 0                    
AND i.created_date > SYSDATE - (80 / 1440);