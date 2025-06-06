-- MZMOB-377 Upgrade compound indexes to include a descending effective date
-- Author: B Knowles 
-- Date: 2nd OCtober 2017

drop index MZ_MOB_DATA_OWNER.GSMA_IP_RANGES_IDX1;
CREATE INDEX MZ_MOB_DATA_OWNER.GSMA_IP_RANGES_IDX1 ON MZ_MOB_DATA_OWNER.GSMA_IP_RANGES (IP_START DESC, IP_STOP ASC, EFF_DATE DESC);
analyze table MZ_MOB_DATA_OWNER.GSMA_IP_RANGES compute statistics;

drop index MZ_MOB_DATA_OWNER.GSMA_GT_RANGES_IDX1;
CREATE INDEX MZ_MOB_DATA_OWNER.GSMA_GT_RANGES_IDX1 ON MZ_MOB_DATA_OWNER.GSMA_GT_RANGES (GT_START DESC, GT_STOP ASC, EFF_DATE DESC);
analyze table MZ_MOB_DATA_OWNER.GSMA_GT_RANGES compute statistics;

drop index MZ_MOB_DATA_OWNER.GSMA_GT_NODE_IDX1;
CREATE INDEX MZ_MOB_DATA_OWNER.GSMA_GT_NODE_IDX1 ON MZ_MOB_DATA_OWNER.GSMA_GT_NODE (GT_START DESC, GT_STOP ASC, EFF_DATE DESC);
analyze table MZ_MOB_DATA_OWNER.GSMA_GT_NODE compute statistics;

drop index MZ_MOB_DATA_OWNER.GSMA_GT_NODE_IDX2;
CREATE INDEX MZ_MOB_DATA_OWNER.GSMA_GT_NODE_IDX2 ON MZ_MOB_DATA_OWNER.GSMA_GT_NODE (IP_START DESC, IP_STOP ASC, EFF_DATE DESC);
analyze table MZ_MOB_DATA_OWNER.GSMA_GT_NODE compute statistics;
