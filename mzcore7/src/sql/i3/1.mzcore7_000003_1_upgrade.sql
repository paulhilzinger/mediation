-- MED-606 - Upgrade to MZ8.3 SQL
--

CREATE TABLE external_ref_db (
        reference          VARCHAR(64)   NOT NULL,
        ref_key            VARCHAR(128)  NOT NULL,
        ref_value          VARCHAR(1000) NOT NULL,
        modified_date     DATE DEFAULT SYSDATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX external_ref_db1_u_idx ON external_ref_db(reference, ref_key);
