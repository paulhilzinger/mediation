-- MED-592.[ROI N-IMS] - All issues and observations related to ROI Nokia IMS. Issue 48: dn_freephone_prefix_codes_roi table
--
Update MZ_CDR_OWNER.DN_FREEPHONE_PREFIX_CODES_ROI
set FREEPHONE_PREFIX_CODE = '0896555000', FREEPHONE_PREFIX_DESC = 'Voicemail ROI roaming (normalised)'
where   FREEPHONE_PREFIX_CODE  = '353896522000';
  
Update MZ_CDR_OWNER.DN_FREEPHONE_PREFIX_CODES_ROI
set FREEPHONE_PREFIX_CODE = '01800', FREEPHONE_PREFIX_DESC = 'Freephone prefix  arriving as 3531800xxxxxxx'
where  FREEPHONE_PREFIX_CODE  = '1800';

INSERT INTO DN_FREEPHONE_PREFIX_CODES_ROI ( FREEPHONE_PREFIX_CODE,
FREEPHONE_PREFIX_DESC ) VALUES ( 
'116', 'Any other hotline number'); 