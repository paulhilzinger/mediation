-- mz_cdr_owner

create user mz_cdr_owner identified by mz_cdr
default tablespace mz_cdr_data
temporary tablespace temp
quota unlimited on mz_cdr_data
quota unlimited on I_WLR3_MAXVALUE;

grant create table to mz_cdr_owner;
grant create trigger to mz_cdr_owner;
grant create view to mz_cdr_owner;
grant create sequence to mz_cdr_owner;
grant create session to mz_cdr_owner;
grant create any synonym to mz_cdr_owner;
grant drop any synonym to mz_cdr_owner;
grant create database link to mz_cdr_owner;
grant create procedure to mz_cdr_owner;

create role mz_cdr_readonly;

create role mz_cdr_update;

create user mz_cdr_user identified by mz
default tablespace mz_cdr_data
temporary tablespace temp
quota 0 on mz_cdr_data;

grant create session to mz_cdr_user;
grant mz_cdr_readonly to mz_cdr_user;
grant mz_cdr_update to mz_cdr_user;
