-- MZMOB-512 - Increase size of FILE_IN_LOG field
--
ALTER TABLE FILE_IN_LOG MODIFY FILENAME VARCHAR2(500);