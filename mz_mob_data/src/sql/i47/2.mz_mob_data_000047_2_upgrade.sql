-- MZMOB-548 - Add columns for VoLTE and WoWIFI QoS
--
ALTER TABLE CDR_INPUT_IMS
  ADD ( 
       ABNORMAL_FINISH_REASON VARCHAR2(200),
       ABNORMAL_FINISH_WARNING VARCHAR2(200) 
      );