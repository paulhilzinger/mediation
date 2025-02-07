-- MED-494 - Widen the fields in the ECS output table to be the same as the CDR input table
--
ALTER TABLE CDR_OUTPUT_IMS_NOKIA_ECS
MODIFY (
   CALLING_NUMBER VARCHAR2(128),
   CALLED_NUMBER VARCHAR2(128)
);


-- MED-499 - Add new DB field to hold the Visited Network ID
--
ALTER TABLE CDR_INPUT_IMS_NOKIA
  ADD VISITED_NETWORK_ID VARCHAR2(512);