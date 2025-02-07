-- mz_ita_owner

create user mz_ita_owner identified by mz_ita
default tablespace mz_ita_data
temporary tablespace temp
quota unlimited on mz_ita_data;

grant create table to mz_ita_owner;
grant create view to mz_ita_owner;
grant create sequence to mz_ita_owner;
grant create trigger to mz_ita_owner;
grant create session to mz_ita_owner;
grant create any synonym to mz_ita_owner;
grant drop any synonym to mz_ita_owner;

-- mz_ita_admin

create user mz_ita_admin identified by mz_ita
default tablespace mz_ita_data
temporary tablespace temp
quota 0 on mz_ita_data;

-- create mz_ita specific role
create role mz_ita_role;

grant create session to mz_ita_admin;
grant create any synonym to mz_ita_admin;
grant drop any synonym to mz_ita_admin;
grant mz_ita_role to mz_ita_admin;
