-- MZMOB-905. [GT_NODE] Derivation issue with Input IR21 records where Blank GT_Start and GT_Stop are blank

-- Remove erroneous records in GSMA_GT_NODE
DELETE FROM MZ_MOB_DATA_OWNER.GSMA_GT_NODE WHERE GT_RANGE_START = '---' AND GT_RANGE_STOP = '---';