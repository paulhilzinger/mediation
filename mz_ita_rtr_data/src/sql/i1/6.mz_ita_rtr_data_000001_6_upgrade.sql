-- Widen the CUMULATIVE_RADIUS.ALL_STATES field from 2 to 6 digits
--
ALTER TABLE CUMULATIVE_RADIUS MODIFY ALL_STATES NUMBER(6);


-- Widen the CDR_INPUT_RTR.ALL_STATES field from 2 to 6 digits
--
ALTER TABLE CDR_INPUT_RTR MODIFY ALL_STATES NUMBER(6);
