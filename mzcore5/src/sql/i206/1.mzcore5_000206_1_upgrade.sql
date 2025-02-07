-- MZ 7.0 Upgrade DB patch
--IDENTIFIER: MZ-3813
-- Removes foreign key relations against ecs_group and ecs_error_code
-- since these tables are not in use any more.
--
-- Constraints to remove lacks name and must be looked up, via user_constraints
--

--BEGIN_PLSQL
declare v_constraint_name varchar(64);
begin
select constraint_name into v_constraint_name from user_constraints where table_name = 'ECS_UDR' and constraint_type = 'R' and r_constraint_name = 'PK_ECS_GROUP';
execute immediate 'alter table ECS_UDR drop constraint ' || v_constraint_name;

select constraint_name into v_constraint_name from user_constraints where table_name = 'ECS_BATCH' and constraint_type = 'R' and r_constraint_name = 'PK_ECS_GROUP';
execute immediate 'alter table ECS_BATCH drop constraint ' || v_constraint_name;

select constraint_name into v_constraint_name from user_constraints where table_name = 'ECS_UDR_ERROR' and constraint_type = 'R' and r_constraint_name = 'PK_ECS_ERROR_CODE';
execute immediate 'alter table ECS_UDR_ERROR drop constraint ' || v_constraint_name;

select constraint_name into v_constraint_name from user_constraints where table_name = 'ECS_BATCH_ERROR' and constraint_type = 'R' and r_constraint_name = 'PK_ECS_ERROR_CODE';
execute immediate 'alter table ECS_BATCH_ERROR drop constraint ' || v_constraint_name;

select constraint_name into v_constraint_name from user_constraints where table_name = 'ECS_ERROR_CODE' and constraint_type = 'R' and r_constraint_name = 'PK_ECS_GROUP';
execute immediate 'alter table ECS_ERROR_CODE drop constraint ' || v_constraint_name;

end;
/
--END_PLSQL
