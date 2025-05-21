-- =========================
-- Create user: mz_fixed_owner
-- =========================
CREATE USER mz_fixed_owner IDENTIFIED BY mz_fixed
  DEFAULT TABLESPACE mz_fixed_data
  TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON mz_fixed_data;

-- Grant necessary privileges to mz_fixed_owner
GRANT CREATE SESSION TO mz_fixed_owner;
GRANT CREATE TABLE TO mz_fixed_owner;
GRANT CREATE VIEW TO mz_fixed_owner;
GRANT CREATE SEQUENCE TO mz_fixed_owner;
GRANT CREATE TRIGGER TO mz_fixed_owner;
GRANT CREATE ANY SYNONYM TO mz_fixed_owner;
GRANT DROP ANY SYNONYM TO mz_fixed_owner;
GRANT CREATE PUBLIC SYNONYM TO mz_fixed_owner;
GRANT DROP PUBLIC SYNONYM TO mz_fixed_owner;

-- ========================
-- Create user: mz_fixed_admin
-- ========================
CREATE USER mz_fixed_admin IDENTIFIED BY mz_fixed
  DEFAULT TABLESPACE mz_fixed_data
  TEMPORARY TABLESPACE temp
  QUOTA 0 ON mz_fixed_data;

-- ========================
-- Create custom role: mzrole
-- ========================
CREATE ROLE mzrole;

-- Grant privileges to mz_fixed_admin
GRANT CREATE SESSION TO mz_fixed_admin;
GRANT CREATE ANY SYNONYM TO mz_fixed_admin;
GRANT DROP ANY SYNONYM TO mz_fixed_admin;
GRANT CREATE PUBLIC SYNONYM TO mz_fixed_admin;
GRANT DROP PUBLIC SYNONYM TO mz_fixed_admin;

-- Assign roles to mz_fixed_admin
GRANT mzrole TO mz_fixed_admin;
GRANT CONNECT, RESOURCE TO mz_fixed_admin;
