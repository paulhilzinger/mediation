-- MZMOB-465 - Change to view to only bring back successful calls
--
CREATE OR REPLACE VIEW MONSOL_OCS_IMS_VOICE_ROAMING AS
SELECT t.created_date as created_date,
       t.mnc as mnc,
       t.roam_country as roam_country,
       count(t.roam_country) as count
FROM ( 
        SELECT o.created_date, 
               i.mnc,
               case
                 when (UPPER(o.calling_roam_country) != 'UNITED KINGDOM' and o.service_flow = '1') then o.calling_roam_country
                 when (UPPER(o.called_roam_country) != 'UNITED KINGDOM' and o.service_flow = '2') then o.called_roam_country
               end as roam_country
          FROM mz_mob_data_owner.cdr_input_ocs_voice o,
               mz_mob_data_owner.cdr_input_ims i
         WHERE ((UPPER(o.calling_roam_country) != 'UNITED KINGDOM' and service_flow = '1') or (UPPER(o.called_roam_country) != 'UNITED KINGDOM' and service_flow = '2') )
           AND o.created_date > sysdate - (15/1440)
           AND o.duration > 0
           AND i.ims_charging_id = o.ims_charging_identifier
           AND i.record_type = 69
           AND i.role_of_node = o.service_flow -1
           AND i.cause_for_record_closing = 0
           AND i.duration > 0
           AND i.created_date > sysdate - (45/1440)
     ) t
GROUP BY t.created_date, t.mnc, t.roam_country;