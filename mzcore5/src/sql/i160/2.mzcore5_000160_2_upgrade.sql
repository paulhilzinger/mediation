-- As part of deploying MZO-449 to production, it was found we needed to adjust a table. DR knew about this problem and supplied a fix
-- This needed to be added as a fix-on-fail on 4th July 2014.
--

ALTER TABLE pico_client_stat MODIFY
(cpu_time_avr NUMBER(8,3)
,cpu_time_min NUMBER(8,3)
,cpu_time_max NUMBER(8,3));

