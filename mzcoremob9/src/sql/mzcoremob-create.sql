-- =========================
-- Create user: mz_mob_owner
-- =========================
CREATE USER mz_mob_owner IDENTIFIED BY mz_mob
  DEFAULT TABLESPACE mz_mob_data
  TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON mz_mob_data;

-- Grant necessary privileges to mz_mob_owner
GRANT CREATE SESSION TO mz_mob_owner;
GRANT CREATE TABLE TO mz_mob_owner;
GRANT CREATE VIEW TO mz_mob_owner;
GRANT CREATE SEQUENCE TO mz_mob_owner;
GRANT CREATE TRIGGER TO mz_mob_owner;
GRANT CREATE ANY SYNONYM TO mz_mob_owner;
GRANT DROP ANY SYNONYM TO mz_mob_owner;
GRANT CREATE PUBLIC SYNONYM TO mz_mob_owner;
GRANT DROP PUBLIC SYNONYM TO mz_mob_owner;
GRANT SELECT_CATALOG_ROLE TO mz_mob_owner;

-- ========================
-- Create user: mz_mob_admin
-- ========================
CREATE USER mz_mob_admin IDENTIFIED BY mz_mob
  DEFAULT TABLESPACE mz_mob_data
  TEMPORARY TABLESPACE temp
  QUOTA 0 ON mz_mob_data;

-- ========================
-- Create custom role: mzrole
-- ========================
CREATE ROLE mzrole;

-- Grant privileges to mz_mob_admin
GRANT CREATE SESSION TO mz_mob_admin;
GRANT CREATE ANY SYNONYM TO mz_mob_admin;
GRANT DROP ANY SYNONYM TO mz_mob_admin;
GRANT CREATE PUBLIC SYNONYM TO mz_mob_admin;
GRANT DROP PUBLIC SYNONYM TO mz_mob_admin;

-- Assign roles to mz_mob_admin
GRANT mzrole TO mz_mob_admin;
GRANT CONNECT, RESOURCE TO mz_mob_admin;
