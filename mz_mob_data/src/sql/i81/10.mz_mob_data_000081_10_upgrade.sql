-- MZMOB-912. Improve performance of AOCS BU Build Function


--Add new column to AOCS_ISR_RESOURCES
ALTER TABLE AOCS_ISR_RESOURCES ADD RESOURCE_VALUE_STR VARCHAR2(20);

-- Rename index for consistency
ALTER INDEX AOCS_ISR_RESOURCES_PK RENAME TO AOCS_ISR_RESOURCES_IDX1;

--Add new index
CREATE INDEX MZ_MOB_DATA_OWNER.AOCS_ISR_RESOURCES_IDX2 ON MZ_MOB_DATA_OWNER.AOCS_ISR_RESOURCES ("RESOURCE_VALUE_STR");