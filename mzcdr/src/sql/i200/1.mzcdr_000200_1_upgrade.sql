-- MED-242 - Add Visited Network ID for Strategic Access to the IMS input table
--
ALTER TABLE CDR_INPUT_IMS
  ADD VISITED_NETWORK_ID VARCHAR2(512);


-- 2019-02-19 - WLT - MED-249
--
-- RETROSPECTIVELY ADDED THE FOLLOWING ADHOC DATAFIXES TO KEEP FUTURE BUILDS UP_TO_DATE
-- 
delete from mz_cdr_owner.dn_freephone_prefix_codes
 where freephone_prefix_code = '0500';
 

-- 2019-02-19 - WLT - MED-250
--
-- RETROSPECTIVELY ADDED THE FOLLOWING ADHOC DATAFIXES TO KEEP FUTURE BUILDS UP_TO_DATE
-- 
insert into mz_cdr_owner.dn_freephone_prefix_codes values ('02087599036', 'BT Engineering Test Number');

insert into mz_cdr_owner.dn_freephone_prefix_codes values ('01412040004', 'BT Engineering Test Number');

insert into mz_cdr_owner.dn_freephone_prefix_codes values ('01332751424', 'BT Engineering Test Number');

insert into mz_cdr_owner.dn_freephone_prefix_codes values ('01412432990', 'BT Engineering Test Number');