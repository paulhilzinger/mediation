-- MZMOB-1027 S4 archiving solution for re-architecture
CREATE TABLE MZ_MOB_DATA_OWNER.MZ_AUDIT_S4_COLLECTED 
( 
    TRANSACTION_ID NUMERIC(12),
    WORKFLOW  VARCHAR(100),
    PATH_NAME VARCHAR(500),
    FILE_NAME VARCHAR(200),
    COLLECTED TIMESTAMP,
    FILE_SIZE INTEGER
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;

