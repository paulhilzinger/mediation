create user dar_admin identified by dar_admin
default tablespace dar_data
quota 0 on dar_data
temporary tablespace temp;

grant create session to dar_admin;
grant create profile to dar_admin;
grant create user to dar_admin;
grant drop user to dar_admin;
grant alter user to dar_admin;

grant create role to dar_admin;
grant drop any role to dar_admin;
grant grant any role to dar_admin;
grant grant any privilege to dar_admin;
grant grant any object privilege to dar_admin;
grant execute on sys.dbms_workload_repository to dar_admin with grant option;
grant execute on sys.dbms_lob to dar_admin with grant option;
grant execute on sys.dbms_job to dar_admin with grant option;
grant execute on sys.utl_file to dar_admin with grant option;
grant execute on sys.dbms_system to dar_admin with grant option;
grant select on sys.dba_pending_transactions to dar_admin with grant option;
grant select on sys.pending_trans$ to dar_admin with grant option;
grant select on sys.dba_2pc_pending to dar_admin with grant option;
grant select_catalog_role to dar_admin with admin option;
grant execute on dbms_lock to dar_admin with grant option;
grant create any synonym to dar_admin;
grant select on v_$session to dar_admin;
grant alter system to dar_admin;
grant execute on sys.dbms_crypto to dar_admin with grant option;
grant select on sys.v_$database to dar_admin with grant option;
