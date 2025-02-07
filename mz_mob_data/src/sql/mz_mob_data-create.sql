-- mz_mob_data_owner

create user mz_mob_data_owner identified by mz_mob
default tablespace mz_mob_cdr_data
temporary tablespace temp
quota unlimited on mz_mob_cdr_data;

grant create table to mz_mob_data_owner;
grant create trigger to mz_mob_data_owner;
grant create view to mz_mob_data_owner;
grant create sequence to mz_mob_data_owner;
grant create session to mz_mob_data_owner;
grant create any synonym to mz_mob_data_owner;
grant drop any synonym to mz_mob_data_owner;
grant create database link to mz_mob_data_owner;
grant create procedure to mz_mob_data_owner; 

-- mz_mob_data_user

create user mz_mob_data_user identified by mz_mob
default tablespace mz_mob_cdr_data
temporary tablespace temp
quota 0 on mz_mob_cdr_data;

-- create mz mob data specific roles

create role mz_mob_data_readonly;
create role mz_mob_data_update;
create role mz_mob_data_execute;

grant create session to mz_mob_data_user;
grant mz_mob_data_readonly to mz_mob_data_user;
grant mz_mob_data_update to mz_mob_data_user;
grant mz_mob_data_execute to mz_mob_data_user;
