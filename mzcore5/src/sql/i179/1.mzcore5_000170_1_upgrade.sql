-- New column needs to be added to the ECS_UDR table as part of the MZ6.0 to MZ6.1 upgrade
--
ALTER TABLE ECS_UDR ADD (MODIFICATION_TIME DATE DEFAULT SYSDATE NOT NULL);