-- Create view to get roaming subscribers from OCS and IMS Voice records
--
CREATE OR REPLACE VIEW MONSOL_OCS_IMS_VOICE_ROAMING AS
SELECT o.created_date as created_date, i.mnc as mnc, o.calling_roam_country as calling_roam_country, count(i.mnc) as count
  FROM cdr_input_ocs_voice o,
       cdr_input_ims i
 WHERE UPPER(o.calling_roam_country) != 'UNITED KINGDOM'
   AND o.created_date > sysdate - (15/1440) -- Get the last 15 minutes
   AND i.ims_charging_id = o.ims_charging_identifier
   AND i.role_of_node in  (0,1) -- Only need MO and MT
   AND i.record_type = 69 -- Only need ATS
 GROUP BY o.created_date, o.calling_roam_country, i.mnc;   


-- Create view to get roaming subscribers from OCS SMS records
--
CREATE OR REPLACE VIEW MONSOL_OCS_SMS_ROAMING AS
SELECT created_date as created_date, calling_roam_country as calling_roam_country, count(calling_roam_country) as count
  FROM cdr_input_ocs_sms
 WHERE UPPER(calling_roam_country) != 'UNITED KINGDOM'  
   AND created_date > sysdate - (15/1440) -- Get the last 15 minutes
 GROUP BY created_date, calling_roam_country;  


-- Create view to get roaming subscribers from OCS MMS records
--
CREATE OR REPLACE VIEW MONSOL_OCS_MMS_ROAMING AS
SELECT created_date as created_date, calling_roam_country as calling_roam_country, count(calling_roam_country) as count
  FROM cdr_input_ocs_mms
 WHERE UPPER(calling_roam_country) != 'UNITED KINGDOM'  
   AND created_date > sysdate - (15/1440) -- Get the last 15 minutes
 GROUP BY created_date, calling_roam_country;   


-- Create view to get roaming subscribers from OCS GPRS records
--
CREATE OR REPLACE VIEW MONSOL_OCS_GPRS_ROAMING AS
SELECT created_date as created_date, calling_roam_country as calling_roam_country, count(calling_roam_country) as count
  FROM cdr_input_ocs_gprs
 WHERE UPPER(calling_roam_country) != 'UNITED KINGDOM'  
   AND created_date > sysdate - (15/1440) -- Get the last 15 minutes
 GROUP BY created_date, calling_roam_country;   

