WHENEVER SQLERROR CONTINUE;
drop table n3c_gen_sql;
drop table n3c_cdm_tables;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

------------------------------------------------------------------------------------------------------------------------------
--- CDM tables to include
------------------------------------------------------------------------------------------------------------------------------
create table n3c_cdm_tables(
    table_name varchar(255)
);

--Insert into N3C_CDM_TABLES (TABLE_NAME) values ('CDM_STATUS');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('CONDITION');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DEATH');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DEATH_CAUSE');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DEMOGRAPHIC');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DIAGNOSIS');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DISPENSING');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('ENCOUNTER');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('ENROLLMENT');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('HARVEST');
--Insert into N3C_CDM_TABLES (TABLE_NAME) values ('HASH_TOKEN');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('IMMUNIZATION');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('LAB_RESULT_CM');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('LDS_ADDRESS_HISTORY');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('MED_ADMIN');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('OBS_CLIN');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('OBS_GEN');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PCORNET_TRIAL');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PRESCRIBING');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PROCEDURES');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PROVIDER');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PRO_CM');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('VITAL');

------------------------------------------------------------------------------------------------------------------------------
--- Save gen sql in table
------------------------------------------------------------------------------------------------------------------------------
create table n3c_gen_sql(
    sql_str varchar(4000)
);

insert into n3c_gen_sql (select 'define encrypting_password=&1;' from dual);
------------------------------------------------------------------------------------------------------------------------------
--- DROP TABLE SQL
------------------------------------------------------------------------------------------------------------------------------
insert into n3c_gen_sql (select 'WHENEVER SQLERROR CONTINUE ;' from dual);

insert into n3c_gen_sql
with cdm_tables_w_patid
as
(
select distinct table_name
from dba_tab_cols
where owner = 'PCORNET_CDM'
    and table_name in ( select table_name from N3C_CDM_TABLES)
)
select 'DROP TABLE PCORNET_CDM_N3C.'||table_name || ' purge ;' from cdm_tables_w_patid order by table_name
;

insert into n3c_gen_sql (select 'WHENEVER SQLERROR EXIT SQL.SQLCODE;' from dual);

commit;
------------------------------------------------------------------------------------------------------------------------------
--- CREATE TABLE SQL
-----------------------------------------------------------------------------------------------------------------------------
select 
''''||table_name || '''' table_name
from dba_tables
where owner='PCORNET_CDM_N3C'
order by table_name;

with cdm_tables_w_patid
as
(
select distinct table_name
from dba_tab_cols
where owner = 'PCORNET_CDM'
    and table_name in (
                        'CDM_STATUS'
                        ,'CONDITION'
                        ,'DEATH'
                        ,'DEATH_CAUSE'
                        ,'DEMOGRAPHIC'
                        ,'DIAGNOSIS'
                        ,'DISPENSING'
                        ,'ENCOUNTER'
                        ,'ENROLLMENT'
                        ,'HARVEST'
                        ,'HASH_TOKEN'
                        ,'IMMUNIZATION'
                        ,'LAB_RESULT_CM'
                        ,'LDS_ADDRESS_HISTORY'
                        ,'MED_ADMIN'
                        ,'OBS_CLIN'
                        ,'OBS_GEN'
                        ,'PCORNET_TRIAL'
                        ,'PRESCRIBING'
                        ,'PROCEDURES'
                        ,'PROVIDER'
                        ,'PRO_CM'
                        ,'VITAL'
                        )
    and column_name = 'PATID'
)
select 
'create table PCORNET_CDM_N3C.'|| table_name || ' nologging parallel as select ' || 
LISTAGG(column_name, ', ') WITHIN GROUP (ORDER BY column_id)
|| ' from '||owner||'.'|| table_name 
||' cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='
|| '''' ||'Epic@kumed.com' ||'''' || ' ;'
from dba_tab_cols
where owner = 'PCORNET_CDM'
    and table_name in (select table_name from cdm_tables_w_patid)
    and owner = 'PCORNET_CDM'
group by owner,table_name
order by owner,table_name
;
