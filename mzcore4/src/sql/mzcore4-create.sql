-- mz_owner

create user mz_owner identified by mz
default tablespace mz_data
temporary tablespace temp
quota unlimited on mz_data;

grant create table to mz_owner;
grant create view to mz_owner;
grant create sequence to mz_owner;
grant create trigger to mz_owner;
grant create session to mz_owner;

grant create any synonym to mz_owner;
grant drop any synonym to mz_owner;

-- mz_admin

create user mz_admin identified by mz
default tablespace mz_data
temporary tablespace temp
quota 0 on mz_data;

create role mzrole;

grant create session to mz_admin;
grant create any synonym to mz_admin;
grant drop any synonym to mz_admin;
grant mzrole to mz_admin;
