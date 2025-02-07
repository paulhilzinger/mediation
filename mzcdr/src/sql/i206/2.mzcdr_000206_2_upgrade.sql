-- Add transaction ID and file control ID to BW table
--
ALTER TABLE CDR_INPUT_BW
ADD(
TRANSACTION_ID NUMBER,
FILE_CONTROL_ID NUMBER
	);
