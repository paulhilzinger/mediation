-- MZMOB-677 - Add N-PGW data into the Monitoring Solutions view
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
        or nvl(upvol5, 0) > 0 or nvl(downvol5, 0) > 0)
UNION
SELECT p.created_date as mediation_insertion_time,
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
            nvl(svcupvol1, 0) + nvl(svcdownvol1, 0) 
          + nvl(svcupvol2, 0) + nvl(svcdownvol2, 0) 
          + nvl(svcupvol3, 0) + nvl(svcdownvol3, 0) 
          + nvl(svcupvol4, 0) + nvl(svcdownvol4, 0) 
          + nvl(svcupvol5, 0) + nvl(svcdownvol5, 0) 
          + nvl(svcupvol6, 0) + nvl(svcdownvol6, 0) 
          + nvl(svcupvol7, 0) + nvl(svcdownvol7, 0) 
          + nvl(svcupvol8, 0) + nvl(svcdownvol8, 0) 
          + nvl(svcupvol9, 0) + nvl(svcdownvol9, 0)           
          + nvl(svcupvol10, 0) + nvl(svcdownvol10, 0) as data_usage_bytes,
          p.chargingid as chargingid
  FROM mz_mob_data_owner.cdr_input_pgw_nokia p,
       mz_mob_data_owner.gsma_tadig t
 WHERE p.mcc != '234'
   AND p.mcc = t.mcc
   AND p.mnc = t.mnc
   AND p.created_date > SYSDATE - (30 / 1440)
   AND (nvl(svcupvol1, 0) > 0 or nvl(svcdownvol1, 0) > 0 
        or nvl(svcupvol2, 0) > 0 or nvl(svcdownvol2, 0) > 0 
        or nvl(svcupvol3, 0) > 0 or nvl(svcdownvol3, 0) > 0 
        or nvl(svcupvol4, 0) > 0 or nvl(svcdownvol4, 0) > 0 
        or nvl(svcupvol5, 0) > 0 or nvl(svcdownvol5, 0) > 0 
        or nvl(svcupvol6, 0) > 0 or nvl(svcdownvol6, 0) > 0 
        or nvl(svcupvol7, 0) > 0 or nvl(svcdownvol7, 0) > 0 
        or nvl(svcupvol8, 0) > 0 or nvl(svcdownvol8, 0) > 0 
        or nvl(svcupvol9, 0) > 0 or nvl(svcdownvol9, 0) > 0 
        or nvl(svcupvol10, 0) > 0 or nvl(svcdownvol10, 0) > 0);        