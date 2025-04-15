-- MZMOB-1001.Remove hyphens in GT_RANGE_START and GT_RANGE_STOP fields
--
update MZ_MOB_DATA_OWNER.GSMA_GT_NODE set GT_RANGE_START = rtrim(GT_RANGE_START,'-') where GT_RANGE_START like '%-';
 
update MZ_MOB_DATA_OWNER.GSMA_GT_NODE set GT_RANGE_STOP = rtrim(GT_RANGE_STOP,'-') where GT_RANGE_STOP like '%-';


update MZ_MOB_DATA_OWNER.GSMA_GT_NODE_ROI set GT_RANGE_START = rtrim(GT_RANGE_START,'-') where GT_RANGE_START like '%-'; 

update MZ_MOB_DATA_OWNER.GSMA_GT_NODE_ROI set GT_RANGE_STOP = rtrim(GT_RANGE_STOP,'-') where GT_RANGE_STOP like '%-';