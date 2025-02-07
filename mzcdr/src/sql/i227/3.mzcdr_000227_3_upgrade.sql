-- MZMOB-568 - Updated DB script from Chanchal Neema for Multi-Site DNs
--

-- UPDATE the procesdure
-- 

--BEGIN_PLSQL
CREATE OR REPLACE PROCEDURE MZ_CDR_OWNER.DN_ENHANCED_TWIG_UPDATE
AS

v_service_limit NUMBER := 60; -- days after which ceased services can be removed if DN reused
v_ceased_limit NUMBER := 730 ; -- days past that ceased services will be captured

BEGIN

  /* Join/merge against unit_id as well. For inner joins default twig unit_id to 2 unless it is 9 because sub views return 2 or 9 only */

  /* cancelled ceases first - to ensure we don't overwrite any manual ceases (ie those without orders) */

  MERGE INTO MZ_CDR_OWNER.DN_BU_LOOKUP_FIXED bul
  USING (select distinct twig.directory_number, decode(twig.unit_id, 6, twig.join_unit_id, twig.unit_id) unit_id
         from nstream_mzn_user.vw_mzn_cancel_cease@SNS_PENFOLD_DB_LINK can_cease,
              nstream_mzn_user.vw_mzn_bu_lookup@SNS_PENFOLD_DB_LINK twig
         where twig.directory_number = can_cease.directory_number
         and   decode(twig.unit_id, 6, decode(twig.join_unit_id, 9, 9, 13, 13,16,16,19,19, 2), 9, 9, 13, 13,16,16,19,19, 2) = can_cease.unit_id) dn -- twig unit_id default to 2 unless 9 for join only
  ON (dn.directory_number = bul.directory_number AND dn.unit_id = bul.unit_id)
  WHEN MATCHED THEN
    UPDATE SET CEASE_DATE=NULL, CKCI_FLAG=NULL ;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE MZ_CDR_OWNER.DN_ENHANCED_LOAD' ;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE MZ_CDR_OWNER.DN_ENHANCED_LOAD_PROV' ;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE MZ_CDR_OWNER.DN_ENHANCED_LOAD_CEASE' ;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE MZ_CDR_OWNER.DN_ENHANCED_DELETE_EXPIRED' ;

  COMMIT ;

  /* service baseline next - should pretty much ensure BU LOOKUP is completely updated */
  /* test_line added to provide active defaults if the DN is state of TEST and franchise is Sky Talk */

  INSERT INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD
  select distinct twig.directory_number,
         decode(twig.unit_id, 6, twig.join_unit_id, twig.unit_id),
         decode(twig.test_line, 'N', greatest(nvl(service.start_date, twig.start_date), twig.start_date), to_date('18-JUL-2013', 'DD-MON-YYYY')),
         decode(twig.test_line, 'N', decode(service.start_date, null, null, 1), 1),
         service.cease_date,
         decode(service.cease_date, null, null, 1)
  from nstream_mzn_user.vw_mzn_services@SNS_PENFOLD_DB_LINK service,
       nstream_mzn_user.vw_mzn_bu_lookup@SNS_PENFOLD_DB_LINK twig
  where twig.directory_number = service.directory_number (+)
  and   decode(twig.unit_id, 6, decode(twig.join_unit_id, 9, 9, 13, 13, 16,16,19,19,2), 9, 9, 13, 13,16,16, 19,19,2) = service.unit_id (+)
  and   nvl(service.dn_rank, 1) = 1;

  COMMIT ;

  /* now the services that have ceased recently, but been migrated to another operator/franchise */

  INSERT INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD
  select distinct service.directory_number,
         service.unit_id,
         service.start_date,
         cast(1 as number),
         service.cease_date,
         cast(1 as number)
  from nstream_mzn_user.vw_mzn_services@SNS_PENFOLD_DB_LINK service
  where service.service_rank = 2
  and   service.cease_date > sysdate - v_ceased_limit
  and   (service.directory_number, service.unit_id) not in (select load.directory_number, load.unit_id from mz_cdr_owner.dn_enhanced_load load);

  COMMIT ;

  /* in flight provisions */

  INSERT INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD_PROV
  select distinct twig.directory_number, decode(twig.unit_id, 6, twig.join_unit_id, twig.unit_id), kci2.kci2_date, cast(0 as number), null, null
  from nstream_mzn_user.vw_mzn_inflight_prov@SNS_PENFOLD_DB_LINK kci2,
       nstream_mzn_user.vw_mzn_bu_lookup@SNS_PENFOLD_DB_LINK twig
  where twig.directory_number = kci2.directory_number
  and   decode(twig.unit_id, 6, decode(twig.join_unit_id, 9, 9, 13, 13,16,16,19,19, 2), 9, 9, 13, 13,16,16,19,19,2) = kci2.unit_id;

  COMMIT ;

  /* cancelled provisions */

  INSERT INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD_CEASE
  select distinct twig.directory_number, decode(twig.unit_id, 6, twig.join_unit_id, twig.unit_id), can_prov.kci2_date, cast(0 as number), twig.cancelled_date, cast(1 as number)
  from nstream_mzn_user.vw_mzn_cancel_prov@SNS_PENFOLD_DB_LINK can_prov,
       nstream_mzn_user.vw_mzn_bu_lookup_cancel@SNS_PENFOLD_DB_LINK twig
  where twig.directory_number = can_prov.directory_number
  and   decode(twig.unit_id, 6, decode(twig.join_unit_id, 9, 9, 13, 13,16,16,19,19,2), 9, 9, 13, 13,16,16,19,19,2) = can_prov.unit_id
  and   twig.cancelled_date is not null;

  COMMIT ;

  /* Put them into the main load table */

  MERGE INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD dnel
  USING (select directory_number, unit_id, start_date, skci_flag, cease_date, ckci_flag from MZ_CDR_OWNER.DN_ENHANCED_LOAD_PROV) dn
  ON (dn.directory_number = dnel.directory_number and dn.unit_id = dnel.unit_id)
  WHEN MATCHED THEN
    UPDATE SET START_DATE=dn.START_DATE, SKCI_FLAG=dn.SKCI_FLAG, CEASE_DATE=dn.CEASE_DATE, CKCI_FLAG=dn.CKCI_FLAG;

  COMMIT ;

  MERGE INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD dnel
  USING (select directory_number, unit_id, start_date, skci_flag, cease_date, ckci_flag from MZ_CDR_OWNER.DN_ENHANCED_LOAD_PROV) dn
  ON (dn.directory_number = dnel.directory_number and dn.unit_id = dnel.unit_id)
  WHEN NOT MATCHED THEN
    INSERT (DIRECTORY_NUMBER, UNIT_ID, START_DATE, SKCI_FLAG, CEASE_DATE, CKCI_FLAG)
    VALUES (dn.DIRECTORY_NUMBER, dn.UNIT_ID, dn.START_DATE, dn.SKCI_FLAG, dn.CEASE_DATE, dn.CKCI_FLAG);

  COMMIT ;

  MERGE INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD dnel
  USING (select directory_number, unit_id, start_date, skci_flag, cease_date, ckci_flag from MZ_CDR_OWNER.DN_ENHANCED_LOAD_CEASE) dn
  ON (dn.directory_number = dnel.directory_number and dn.unit_id = dnel.unit_id)
  WHEN MATCHED THEN
    UPDATE SET START_DATE=dn.START_DATE, SKCI_FLAG=dn.SKCI_FLAG, CEASE_DATE=dn.CEASE_DATE, CKCI_FLAG=dn.CKCI_FLAG;


  COMMIT ;

  MERGE INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD dnel
  USING (select directory_number, unit_id, start_date, skci_flag, cease_date, ckci_flag from MZ_CDR_OWNER.DN_ENHANCED_LOAD_CEASE) dn
  ON (dn.directory_number = dnel.directory_number and dn.unit_id = dnel.unit_id)
  WHEN NOT MATCHED THEN
    INSERT (DIRECTORY_NUMBER, UNIT_ID, START_DATE, SKCI_FLAG, CEASE_DATE, CKCI_FLAG)
    VALUES (dn.DIRECTORY_NUMBER, dn.UNIT_ID, dn.START_DATE, dn.SKCI_FLAG, dn.CEASE_DATE, dn.CKCI_FLAG);

  /* in flight ceases */

  EXECUTE IMMEDIATE 'TRUNCATE TABLE MZ_CDR_OWNER.DN_ENHANCED_LOAD_CEASE' ;

  INSERT INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD_CEASE
  select distinct twig.directory_number, decode(twig.unit_id, 6, twig.join_unit_id, twig.unit_id), null, null, cease.cease_request_date, cast(0 as number)
  from nstream_mzn_user.vw_mzn_inflight_cease@SNS_PENFOLD_DB_LINK cease,
       nstream_mzn_user.vw_mzn_bu_lookup@SNS_PENFOLD_DB_LINK twig
  where twig.directory_number = cease.directory_number
  and   decode(twig.unit_id, 6, decode(twig.join_unit_id, 9, 9, 13, 13, 16,16,19,19,2), 9, 9, 13, 13, 16,16,19,19,2) = cease.unit_id
  and   twig.unit_id != 6;

  COMMIT ;

  MERGE INTO MZ_CDR_OWNER.DN_ENHANCED_LOAD dnel
  USING (select directory_number, unit_id, start_date, skci_flag, cease_date, ckci_flag from MZ_CDR_OWNER.DN_ENHANCED_LOAD_CEASE) dn
  ON (dn.directory_number = dnel.directory_number AND dn.unit_id = dnel.unit_id AND dnel.start_date < dn.cease_date)
  WHEN MATCHED THEN
    UPDATE SET CEASE_DATE=dn.CEASE_DATE, CKCI_FLAG=dn.CKCI_FLAG;

  COMMIT ;

  /* Update BU Lookup */

  MERGE INTO MZ_CDR_OWNER.DN_BU_LOOKUP_FIXED bul
  USING (SELECT distinct DIRECTORY_NUMBER, UNIT_ID, START_DATE, SKCI_FLAG, CEASE_DATE, CKCI_FLAG FROM MZ_CDR_OWNER.DN_ENHANCED_LOAD) dn
  ON (dn.directory_number = bul.directory_number and dn.unit_id = bul.unit_id)
  WHEN NOT MATCHED THEN
    INSERT (DIRECTORY_NUMBER, UNIT_ID, START_DATE, SKCI_FLAG, CEASE_DATE, CKCI_FLAG)
    VALUES (dn.DIRECTORY_NUMBER, dn.UNIT_ID, dn.START_DATE, dn.SKCI_FLAG, dn.CEASE_DATE, dn.CKCI_FLAG);

  MERGE INTO MZ_CDR_OWNER.DN_BU_LOOKUP_FIXED bul
  USING (SELECT distinct DIRECTORY_NUMBER, UNIT_ID, START_DATE, SKCI_FLAG, CEASE_DATE, CKCI_FLAG FROM MZ_CDR_OWNER.DN_ENHANCED_LOAD) dn
  ON (dn.directory_number = bul.directory_number and dn.unit_id = bul.unit_id)
  WHEN MATCHED THEN
    UPDATE SET START_DATE=dn.START_DATE, SKCI_FLAG=dn.SKCI_FLAG, CEASE_DATE=dn.CEASE_DATE, CKCI_FLAG=dn.CKCI_FLAG;

  /* Delete expired records from BU Lookup. eg where the unit_id has changed the previous record only needs to be kept 30 days */

  INSERT INTO MZ_CDR_OWNER.DN_ENHANCED_DELETE_EXPIRED
  select  directory_number,
         unit_id,
         cease_date,
         rank () over (partition by directory_number order by nvl(start_date, to_date('01-JAN-1970', 'dd-mon-yyyy')) desc, nvl(ckci_flag, -1) desc) bu_rank,
         lag (unit_id, 1) over (partition by directory_number order by nvl(start_date, to_date('01-JAN-1970', 'dd-mon-yyyy')) desc, nvl(ckci_flag, -1) desc) bu_now
  from MZ_CDR_OWNER.DN_BU_LOOKUP_FIXED
  where directory_number in (select directory_number from MZ_CDR_OWNER.DN_BU_LOOKUP_FIXED group by directory_number having count(*) > 1);

  DELETE FROM MZ_CDR_OWNER.DN_BU_LOOKUP_FIXED
  WHERE (directory_number, unit_id) IN (select directory_number, unit_id from MZ_CDR_OWNER.DN_ENHANCED_DELETE_EXPIRED where bu_rank > 1 and ((bu_now != 6 and nvl(cease_date, to_date('01-JAN-1970', 'dd-mon-yyyy')) < sysdate - v_service_limit) or bu_now = 6)) ;

  COMMIT;

  /* Final clean up to delete any 'Free' records that clash with unit_id data. */

  DELETE FROM MZ_CDR_OWNER.DN_BU_LOOKUP_FIXED
  WHERE unit_id = 6
  AND (directory_number, nvl(start_date, to_date('01/01/1970','dd/mm/yyyy')), nvl(cease_date, to_date('01/01/1970','dd/mm/yyyy')))
   IN (select directory_number, nvl(start_date, to_date('01/01/1970','dd/mm/yyyy')), nvl(cease_date, to_date('01/01/1970','dd/mm/yyyy'))
       from MZ_CDR_OWNER.DN_BU_LOOKUP_FIXED
       group by directory_number, nvl(start_date, to_date('01/01/1970','dd/mm/yyyy')), nvl(cease_date, to_date('01/01/1970','dd/mm/yyyy'))
       having count(*) > 1);

  COMMIT;

END;
/
--END_PLSQL
