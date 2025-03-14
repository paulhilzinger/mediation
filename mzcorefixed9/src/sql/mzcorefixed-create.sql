-- mz_fixed_owner

create user mz_fixed_owner identified by mz_fixed
default tablespace mz_fixed_data
temporary tablespace temp
quota unlimited on mz_fixed_data;

grant create table to mz_fixed_owner;
grant create view to mz_fixed_owner;
grant create sequence to mz_fixed_owner;
grant create trigger to mz_fixed_owner;
grant create session to mz_fixed_owner;
grant create any synonym to mz_fixed_owner;
grant drop any synonym to mz_fixed_owner;

-- mz_fixed_admin

create user mz_fixed_admin identified by mz_fixed
default tablespace mz_fixed_data
temporary tablespace temp
quota 0 on mz_fixed_data;

-- create mz_fixed specific role
create role mzrole;

grant create session to mz_fixed_admin;
grant create any synonym to mz_fixed_admin;
grant drop any synonym to mz_fixed_admin;
grant mzrole to mz_fixed_admin;

--grant connect, resource, mzrole to mz_fixed_admin;

grant create public synonym to mz_fixed_admin;
grant create public synonym to mz_fixed_owner;

grant drop public synonym to mz_fixed_admin;
grant drop public synonym to mz_fixed_owner;

