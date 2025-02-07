-- Re-create view to get roaming subscribers from OCS GPRS records
--
CREATE OR REPLACE VIEW MONSOL_OCS_GPRS_ROAMING AS
SELECT created_date as created_date, calling_roam_country as calling_roam_country, count(calling_roam_country) as count, sum(actual_usage) as usage
  FROM cdr_input_ocs_gprs
 WHERE UPPER(calling_roam_country) != 'UNITED KINGDOM'  
   AND created_date > sysdate - (15/1440) -- Get the last 15 minutes
   AND actual_usage > 0
 GROUP BY created_date, calling_roam_country;   