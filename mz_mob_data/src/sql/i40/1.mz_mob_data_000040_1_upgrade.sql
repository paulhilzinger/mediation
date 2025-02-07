-- MZMOB-490. WLT. Filter off free data usage from the Kenan feed
--

-- Create a table to hold free usage LasfEffectOffering Ids
--
CREATE TABLE OCS_FREE_DATA_USAGE_LOOKUP
(
   LAST_EFFECT_OFFERING VARCHAR2(30)  NOT NULL,
   DESCRIPTION VARCHAR2(100)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


-- Insert two rows into the OCS_FREE_DATA_USAGE_LOOKUP
--
INSERT INTO OCS_FREE_DATA_USAGE_LOOKUP (LAST_EFFECT_OFFERING, DESCRIPTION)
 VALUES 
    ('444400000000000001', 'Christmas 2018 Free Data Usage ID - Trial');

INSERT INTO OCS_FREE_DATA_USAGE_LOOKUP (LAST_EFFECT_OFFERING, DESCRIPTION)
 VALUES 
    ('444400000000000002', 'Christmas 2018 Free Data Usage ID');


-- Add a new UM filter reason for the free data usage
--
INSERT INTO MZ_FILTER_REASONS (FILTER_REASON_ID, DESCRIPTION)
 VALUES
    (62, 'Not Required For Kenan Free Data Offer');


-- Realign SVN SQL - WLT - Added 2019-01-11 into im40, retrospectively, so that adhoc datafixes so far are
-- picked up in future DB Incrementor builds
--
--

-- MZMOB-399 - As per RQTASK1931700 remove this row from the mobile Mediation freephone table
--
delete from MZ_MOB_DATA_OWNER.DN_FREEPHONE_PREFIX_CODES
 where FREEPHONE_PREFIX_CODE = '00800';

-- MZMOB-467
--
UPDATE OCS_PLM_MAPPING SET OUTPUT_VALUE = 'The French West Indies / Netherlands Antilles' WHERE OCS_VALUE IN ('Martinique', 'Guadeloupe');

INSERT INTO OCS_PLM_MAPPING VALUES ('Sint Maarten', 'The French West Indies / Netherlands Antilles');

INSERT INTO OCS_PLM_MAPPING VALUES ('Antilles (Netherlands)', 'The French West Indies / Netherlands Antilles'); 

-- MZMOB-488
--
INSERT INTO MZ_MOB_DATA_OWNER.OCS_PLM_MAPPING VALUES ('Aruba', 'The French West Indies / Netherlands Antilles');

-- MZMOB-491
--
update mz_mob_data_owner.ocs_free_data_usage_lookup
   set description = 'O2 Compensation - 20181208'
 where last_effect_offering = '444400000000000002';
 
insert into mz_mob_data_owner.ocs_free_data_usage_lookup
   (last_effect_offering, description)
 values
   ('444400000000000003', 'Christmas 2018 Free Data Usage ID');