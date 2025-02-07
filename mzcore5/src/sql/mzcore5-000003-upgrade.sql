-- Upgrade script for MZ5.1FR4 to MZ5.1 FR5. MZO-449
-- Run using SQLPlus
--

-- Copyright 2000-2011 Digital Route AB. All rights reserved.
-- DIGITAL ROUTE AB PROPRIETARY/CONFIDENTIAL. 
-- Use is subject to license terms.
--
-- ECS 5.1.x.y
--
-- db init script for oracle

set feedback on
set echo on

/* ----------------------------------------------------------------- */
/* Variables for table space                            	     */
DEFINE TS_MZ_ECS        = mz_data
DEFINE TS_MZ_ECS_IDX    = mz_data

/* ------------------------------------------------------------------------ */
/*  Lookup table containing ECS server side configuration.       		    */
/* ------------------------------------------------------------------------ */
PROMPT ecs_config
CREATE TABLE ecs_config (
 	type		  VARCHAR2(64)   NOT NULL,
 	name		  VARCHAR2(64)   NOT NULL,
	data          CLOB           NULL,
	CONSTRAINT pk_ecs_saved_filters 
	PRIMARY KEY(name) USING INDEX TABLESPACE &TS_MZ_ECS_IDX
) CACHE TABLESPACE &TS_MZ_ECS;

/* ------------------------------------------------------------------------ */
/*  Add new column to table ecs_udr           		    	            */
/* ------------------------------------------------------------------------ */
PROMPT ecs_udr
ALTER TABLE ecs_udr ADD (tag VARCHAR2(256),
   search_field_1  VARCHAR2(256),
   search_field_2  VARCHAR2(256),
   search_field_3  VARCHAR2(256),
   search_field_4  VARCHAR2(256),
   search_field_5  VARCHAR2(256),
   search_field_6  VARCHAR2(256),
   search_field_7  VARCHAR2(256),
   search_field_8  VARCHAR2(256),
   search_field_9  VARCHAR2(256),
   search_field_10 VARCHAR2(256) );

grant select, update, insert, delete on ecs_config to mz5_admin;

grant select, update, insert, delete on ecs_config to mz5_readonly;

grant select, update, insert, delete on ecs_config to mz5_role;

create synonym mz5_admin.ecs_config for mz5_owner.ecs_config;
