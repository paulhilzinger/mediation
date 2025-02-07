-- MZMOB-469 - Create new data view for Monitoring Solutions to help with roaming monitoring and alerting
--
CREATE OR REPLACE VIEW MZ_MOB_DATA_OWNER.MONSOL_PGW_ROAMING
(
   EVENT_INTERVAL_UTC,
   MCC,
   MNC,
   ROAM_COUNTRY,   
   ACCESS_TYPE,
   DATA_USAGE_BYTES
)
AS
SELECT substr(to_char(rec_open_time_utc, 'yyyy-mm-dd hh24:mi'), 1, 15) || '0:00' as event_interval_utc,
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
         sum(nvl(upvol1, 0) + nvl(downvol1, 0) 
           + nvl(upvol2, 0) + nvl(downvol2, 0) 
           + nvl(upvol3, 0) + nvl(downvol3, 0) 
           + nvl(upvol4, 0) + nvl(downvol4, 0) 
           + nvl(upvol5, 0) + nvl(downvol5, 0)) as data_usage_bytes
  FROM mz_mob_data_owner.cdr_input_pgw p,
       mz_mob_data_owner.gsma_tadig t
 WHERE p.mcc != '234'
   AND p.mcc = t.mcc
   AND p.mnc = t.mnc
   AND p.created_date > SYSDATE - (20 / 1440)
   AND (nvl(upvol1, 0) > 0 or nvl(downvol1, 0) > 0 
        or nvl(upvol2, 0) > 0 or nvl(downvol2, 0) > 0 
        or nvl(upvol3, 0) > 0 or nvl(downvol3, 0) > 0 
        or nvl(upvol4, 0) > 0 or nvl(downvol4, 0) > 0 
        or nvl(upvol5, 0) > 0 or nvl(downvol5, 0) > 0)
 GROUP BY substr(to_char(rec_open_time_utc, 'yyyy-mm-dd hh24:mi'), 1, 15) || '0:00', t.country, p.mcc, p.mnc, p.rat
;
