-- mz7_owner

create user mz7_owner identified by mz
default tablespace mz_data
temporary tablespace temp
quota unlimited on mz_data;

grant create table to mz7_owner;
grant create view to mz7_owner;
grant create sequence to mz7_owner;
grant create trigger to mz7_owner;
grant create session to mz7_owner;
grant create any synonym to mz7_owner;
grant drop any synonym to mz7_owner;

-- mz7_admin

create user mz7_admin identified by mz
default tablespace mz_data
temporary tablespace temp
quota 0 on mz_data;

-- create mz7 specific role
create role mz7_role;

grant create session to mz7_admin;
grant create any synonym to mz7_admin;
grant drop any synonym to mz7_admin;
grant mz7_role to mz7_admin;
