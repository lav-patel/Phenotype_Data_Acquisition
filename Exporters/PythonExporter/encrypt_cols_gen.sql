------------------------------------------------------------------------------------------------------------------------------
--- DROP TABLE SQL
-----------------------------------------------------------------------------------------------------------------------------
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
)
select 'DROP TABLE PCORNET_CDM_N3C.'||table_name || ' purge ;' from cdm_tables_w_patid order by table_name
;

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
