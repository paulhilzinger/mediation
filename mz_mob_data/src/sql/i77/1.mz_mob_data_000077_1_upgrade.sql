-- MZMOB-829. MOC TAP records with TADIG 'ZWEN1' needs to be filtered from TAPIN

create table MZ_MOB_DATA_OWNER.TAP_FILTER_NETWORK_TADIG (
    TADIG	VARCHAR2(5) NOT NULL
);

-- Initial inserts
INSERT INTO MZ_MOB_DATA_OWNER.TAP_FILTER_NETWORK_TADIG (TADIG) VALUES ('ZWEN1');