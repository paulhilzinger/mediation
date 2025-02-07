-- mz_owner

create user mz5_owner identified by mz5_0wn3r
default tablespace mz_data
temporary tablespace temp
quota unlimited on mz_data;

grant create table to mz5_owner;
grant create view to mz5_owner;
grant create sequence to mz5_owner;
grant create trigger to mz5_owner;
grant create session to mz5_owner;

grant create any synonym to mz5_owner;
grant drop any synonym to mz5_owner;

-- mz_admin

create user mz5_admin identified by mz5_adm1n
default tablespace mz_data
temporary tablespace temp
quota 0 on mz_data;

create role mz5_role;

grant create session to mz5_admin;
grant create any synonym to mz5_admin;
grant drop any synonym to mz5_admin;
grant mz5_role to mz5_admin;

-- mz_support_user

create user mz_support_user identified by mzsupp0rt
default tablespace mz_data temporary tablespace temp;

create role mz5_readonly;
--create role mz_cdr_readonly;

grant create session to mz_support_user;

--grant mz_cdr_readonly to mz_support_user;
grant mz5_readonly to mz_support_user;
