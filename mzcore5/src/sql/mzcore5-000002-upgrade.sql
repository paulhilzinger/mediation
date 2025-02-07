-- Upgrade script 1 for MZ5.0FR3 to MZ5.1 FR0. MZO-420
--
/* Table containing sample statistics for each realtime queue */
PROMPT wf_queue_stat
CREATE TABLE wf_queue_stat (
    host_stat_id      CONSTRAINT fk_wf_queue_stat_host_id
                      REFERENCES host_stat(id) 
                      on delete cascade 
                      NOT NULL,
    client_name		    VARCHAR2(64)  NOT NULL,
    wf_name		        VARCHAR2(128) NOT NULL,
    route_name        VARCHAR(128)  NOT NULL,
    routed_udr_avr        NUMERIC(19)   NOT NULL,
    routed_udr_min        NUMERIC(19)   NOT NULL,
    routed_udr_max        NUMERIC(19)   NOT NULL,
    queue_size        NUMERIC(19)   NOT NULL,
    udr_on_queue_avr  NUMERIC(19)   NOT NULL,
    udr_on_queue_min  NUMERIC(19)   NOT NULL,
    udr_on_queue_max  NUMERIC(19)   NOT NULL
);

CREATE INDEX wf_queue_stat_hostid_idx on 
 wf_queue_stat(host_stat_id);
CREATE INDEX wf_queue_stat_name_idx on 
 wf_queue_stat(wf_name);


-- Upgrade script 2 for MZ5.0FR3 to MZ5.1 FR0. MZO-420
--
create synonym mz5_admin.wf_queue_stat for mz5_owner.wf_queue_stat;
create synonym mz_support_user.wf_queue_stat for mz5_owner.wf_queue_stat;


-- Upgrade script 3 for MZ5.0FR3 to MZ5.1 FR0. MZO-420
--
grant select, update, insert, delete on wf_queue_stat to mz5_role;
grant select, update, insert, delete on wf_queue_stat to mz5_admin;
grant select, update, insert, delete on wf_queue_stat to mz5_readonly;


-- Upgrade script 4 for MZ5.0FR3 to MZ5.1 FR0. MZO-420
--
/*************************************************************************/
/* Contains SQL statement for upgrading table default_dupbatch           */
/* After successful MZ51 upgrade please execute the command(s) below     */
/* using sqlplus or similar oracle tool.                                 */ 
/*************************************************************************/

--
-- Login as mzowner and execute:
--
DEFINE TS_MZ_TAB        = MZ_DATA    --This is the default TS 
DEFINE TS_MZ_IDX        = MZ_DATA

ALTER TABLE default_dupbatch RENAME CONSTRAINT pk_default_dupbatch TO pk_default_dupbatch_old;
ALTER TABLE default_dupbatch RENAME TO default_dupbatch_old;
---
CREATE TABLE default_dupbatch (
       id number        not null,
       txn number       not null,
       timestamp date not null,
       crc number not null,
       logged_mims varchar2(4000)       null,
       txn_safe number(1) DEFAULT 0 NOT NULL,
       profile varchar2(64) NOT NULL,
       CONSTRAINT pk_default_dupbatch_id
            PRIMARY KEY(id) USING INDEX TABLESPACE &TS_MZ_IDX
) TABLESPACE &TS_MZ_TAB;
--
-- Sequence and Auto increment trigger.
--
CREATE SEQUENCE default_dupbatch_seq
       START WITH 1
       INCREMENT BY 1
       NOMAXVALUE;
--
CREATE TRIGGER default_dupbatch_trigger
       BEFORE INSERT ON default_dupbatch
       FOR EACH ROW
       BEGIN
            SELECT default_dupbatch_seq.nextval into :new.id from dual;
       END;
/
--
INSERT INTO default_dupbatch
     ( txn,
       timestamp,
       crc,
       logged_mims,
       txn_safe,
       profile ) 
       SELECT id AS txn,
              timestamp,
              crc,
              logged_mims,
              txn_safe,
              profile
       FROM default_dupbatch_old;

ALTER TABLE default_dupbatch_old DROP CONSTRAINT pk_default_dupbatch_old;
DROP TABLE default_dupbatch_old;
--
CREATE INDEX default_dupbatch_time_idx 
 on default_dupbatch(profile, timestamp) TABLESPACE &TS_MZ_IDX; 

CREATE INDEX default_dupbatch_crc_idx 
 on default_dupbatch(crc) TABLESPACE &TS_MZ_IDX; 

--
GRANT select, update, insert, delete on default_dupbatch to mz5_role;
GRANT select, update, insert, delete on default_dupbatch to mz5_admin;
GRANT select, update, insert, delete on default_dupbatch to mz5_readonly;
