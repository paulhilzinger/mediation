-- Database changes required for the upgrade to MZ6.3
--
CREATE INDEX default_dupbatch_txn_idx ON default_dupbatch(txn);

ALTER TABLE configuration_data ADD is_dirty number(1) DEFAULT 0 not null;

ALTER TABLE configuration_folder DROP CONSTRAINT fk_cf_owner;

ALTER TABLE configuration_data DROP CONSTRAINT fk_cd_owner;