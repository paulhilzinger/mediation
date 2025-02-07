-- mz_ita_rtr_data_owner

create user mz_ita_rtr_data_owner identified by mz_ita
default tablespace mz_ita_cdr_data
temporary tablespace temp
quota unlimited on mz_ita_cdr_data;

grant create table to mz_ita_rtr_data_owner;
grant create trigger to mz_ita_rtr_data_owner;
grant create view to mz_ita_rtr_data_owner;
grant create sequence to mz_ita_rtr_data_owner;
grant create session to mz_ita_rtr_data_owner;
grant create any synonym to mz_ita_rtr_data_owner;
grant drop any synonym to mz_ita_rtr_data_owner;
grant create database link to mz_ita_rtr_data_owner;
grant create procedure to mz_ita_rtr_data_owner; 

-- mz_ita_rtr_data_user

create user mz_ita_rtr_data_user identified by mz_ita
default tablespace mz_ita_cdr_data
temporary tablespace temp
quota 0 on mz_ita_cdr_data;

-- create mz ita rtr data specific roles

create role mz_ita_rtr_data_readonly;
create role mz_ita_rtr_data_update;
create role mz_ita_rtr_data_execute;

grant create session to mz_ita_rtr_data_user;
grant mz_ita_rtr_data_readonly to mz_ita_rtr_data_user;
grant mz_ita_rtr_data_update to mz_ita_rtr_data_user;
grant mz_ita_rtr_data_execute to mz_ita_rtr_data_user;