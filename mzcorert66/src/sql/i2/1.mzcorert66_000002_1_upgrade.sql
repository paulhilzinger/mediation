-- Adjust the column sizes to the correct values
--

ALTER TABLE pico_client_stat MODIFY
(cpu_time_avr NUMBER(8,3)
,cpu_time_min NUMBER(8,3)
,cpu_time_max NUMBER(8,3));