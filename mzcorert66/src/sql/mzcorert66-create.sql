-- mz_r66_owner

create user mz_r66_owner identified by mz_r66
default tablespace mz_r66_data
temporary tablespace temp
quota unlimited on mz_r66_data;

grant create table to mz_r66_owner;
grant create view to mz_r66_owner;
grant create sequence to mz_r66_owner;
grant create trigger to mz_r66_owner;
grant create session to mz_r66_owner;

grant create any synonym to mz_r66_owner;
grant drop any synonym to mz_r66_owner;

-- mz_r66_user

create user mz_r66_user identified by mz_r66
default tablespace mz_r66_data
temporary tablespace temp;

-- create mz r66 specific roles
create role mz_r66_readonly;
create role mz_r66_update;
create role mz_r66_execute;

grant create session to mz_r66_user;
grant mz_r66_readonly to mz_r66_user;
grant mz_r66_update to mz_r66_user;
grant mz_r66_execute to mz_r66_user;
