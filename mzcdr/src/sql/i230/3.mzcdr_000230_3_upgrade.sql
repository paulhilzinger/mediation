-- MED-616. [NEXUS] Call to 1800 freephone sent to customer billing instead of filtering

DELETE FROM MZ_CDR_OWNER.DN_FREEPHONE_PREFIX_CODES_ROI WHERE FREEPHONE_PREFIX_CODE = '01800';
