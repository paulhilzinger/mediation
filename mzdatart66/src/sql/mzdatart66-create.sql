-- mz_r66_data_owner

create user mz_r66_data_owner identified by mz_r66
default tablespace mz_r66_audit_data
temporary tablespace temp
quota unlimited on mz_r66_audit_data;

grant create table to mz_r66_data_owner;
grant create view to mz_r66_data_owner;
grant create sequence to mz_r66_data_owner;
grant create trigger to mz_r66_data_owner;
grant create session to mz_r66_data_owner;

grant create any synonym to mz_r66_data_owner;
grant drop any synonym to mz_r66_data_owner;

-- mz_r66_data_user

create user mz_r66_data_user identified by mz_r66
default tablespace mz_r66_audit_data
temporary tablespace temp;

-- create mz r66 data specific roles
create role mz_r66_data_readonly;
create role mz_r66_data_update;
create role mz_r66_data_execute;

grant create session to mz_r66_data_user;
grant mz_r66_data_readonly to mz_r66_data_user;
grant mz_r66_data_update to mz_r66_data_user;
grant mz_r66_data_execute to mz_r66_data_user;
