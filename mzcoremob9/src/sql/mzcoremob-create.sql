-- mz_mob_owner

create user mz_mob_owner identified by mz_mob
default tablespace mz_mob_data
temporary tablespace temp
quota unlimited on mz_mob_data;

grant create table to mz_mob_owner;
grant create view to mz_mob_owner;
grant create sequence to mz_mob_owner;
grant create trigger to mz_mob_owner;
grant create session to mz_mob_owner;
grant create any synonym to mz_mob_owner;
grant drop any synonym to mz_mob_owner;

-- mz_mob_admin

create user mz_mob_admin identified by mz_mob
default tablespace mz_mob_data
temporary tablespace temp
quota 0 on mz_mob_data;

-- create mz_mob specific role
create role mzrole;

grant create session to mz_mob_admin;
grant create any synonym to mz_mob_admin;
grant drop any synonym to mz_mob_admin;
grant mzrole to mz_mob_admin;

--grant connect, resource, mzrole to mz_mob_admin;

grant create public synonym to mz_mob_admin;
grant create public synonym to mz_mob_owner;

grant drop public synonym to mz_mob_admin;
grant drop public synonym to mz_mob_owner;

