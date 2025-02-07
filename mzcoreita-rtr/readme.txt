Author: W. Tang
Date: 2019-11-11

Summary:
This is a special SVN directory created to enable the creation of an RTR MZ app schema on the same DB as the CDR MZ app schema.

In production, there will be separate DBs for RTR and CDR.

But in UK VDC Test, we didn't have another DB for RTR testing, so to facilitate testing in the UK, we will create the RTR MZ app schema on the same DB as the CDR MZ app schema.

In UK VDC Test, the DB name is DV1MZN.

RTR MZ app schema name is "MZ_ITA_RTR_OWNER" with associated "MZ_ITA_RTR_ADMIN" user.