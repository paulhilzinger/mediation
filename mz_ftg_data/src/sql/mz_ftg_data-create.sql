-- mz_ftg_data_owner

create user mz_ftg_data_owner identified by mz_ftg
default tablespace mz_ftg_data
temporary tablespace temp
quota unlimited on mz_ftg_data;

grant create table to mz_ftg_data_owner;
grant create trigger to mz_ftg_data_owner;
grant create view to mz_ftg_data_owner;
grant create sequence to mz_ftg_data_owner;
grant create session to mz_ftg_data_owner;
grant create any synonym to mz_ftg_data_owner;
grant drop any synonym to mz_ftg_data_owner;
grant create database link to mz_ftg_data_owner;
grant create procedure to mz_ftg_data_owner; 

-- mz_ftg_data_user

create user mz_ftg_data_user identified by mz_ftg
default tablespace mz_ftg_data
temporary tablespace temp
quota 0 on mz_ftg_data;

-- create mz ftg data specific roles

create role mz_ftg_data_readonly;
create role mz_ftg_data_update;
create role mz_ftg_data_execute;

grant create session to mz_ftg_data_user;
grant mz_ftg_data_readonly to mz_ftg_data_user;
grant mz_ftg_data_update to mz_ftg_data_user;
grant mz_ftg_data_execute to mz_ftg_data_user;
