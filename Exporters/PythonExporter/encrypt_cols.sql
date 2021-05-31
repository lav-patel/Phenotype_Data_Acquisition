define encrypting_password=&1;
-- drop tables
WHENEVER SQLERROR CONTINUE;
DROP TABLE CONDITION purge ;
DROP TABLE DEATH purge ;
DROP TABLE DEATH_CAUSE purge ;
DROP TABLE DEMOGRAPHIC purge ;
DROP TABLE DIAGNOSIS purge ;
DROP TABLE DISPENSING purge ;
DROP TABLE ENCOUNTER purge ;
DROP TABLE ENROLLMENT purge ;
DROP TABLE HARVEST purge ;
DROP TABLE IMMUNIZATION purge ;
DROP TABLE LAB_RESULT_CM purge ;
DROP TABLE LDS_ADDRESS_HISTORY purge ;
DROP TABLE MED_ADMIN purge ;
DROP TABLE OBS_CLIN purge ;
DROP TABLE OBS_GEN purge ;
DROP TABLE PCORNET_TRIAL purge ;
DROP TABLE PRESCRIBING purge ;
DROP TABLE PROCEDURES purge ;
DROP TABLE PROVIDER purge ;
DROP TABLE PRO_CM purge ;
DROP TABLE VITAL purge ;
WHENEVER SQLERROR EXIT SQL.SQLCODE;
-- create tables
create table CDM_STATUS nologging parallel as select TASK, START_TIME, END_TIME, RECORDS from PCORNET_CDM.CDM_STATUS ;
create table CONDITION nologging parallel as select CONDITIONID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, REPORT_DATE, RESOLVE_DATE, ONSET_DATE, CONDITION_STATUS, CONDITION, CONDITION_TYPE, CONDITION_SOURCE, RAW_CONDITION_STATUS, RAW_CONDITION, RAW_CONDITION_TYPE, RAW_CONDITION_SOURCE from PCORNET_CDM.CONDITION cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table DEATH nologging parallel as select standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, DEATH_DATE, DEATH_DATE_IMPUTE, DEATH_SOURCE, DEATH_MATCH_CONFIDENCE from PCORNET_CDM.DEATH cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table DEATH_CAUSE nologging parallel as select standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, DEATH_CAUSE, DEATH_CAUSE_CODE, DEATH_CAUSE_TYPE, DEATH_CAUSE_SOURCE, DEATH_CAUSE_CONFIDENCE from PCORNET_CDM.DEATH_CAUSE cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table DEMOGRAPHIC nologging parallel as select standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, BIRTH_DATE, BIRTH_TIME, SEX, SEXUAL_ORIENTATION, GENDER_IDENTITY, HISPANIC, BIOBANK_FLAG, RACE, PAT_PREF_LANGUAGE_SPOKEN, RAW_SEX, RAW_SEXUAL_ORIENTATION, RAW_GENDER_IDENTITY, RAW_HISPANIC, RAW_RACE, RAW_PAT_PREF_LANGUAGE_SPOKEN from PCORNET_CDM.DEMOGRAPHIC cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table DIAGNOSIS nologging parallel as select DIAGNOSISID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, ENC_TYPE, ADMIT_DATE, DX_DATE, standard_HASH('&encrypting_password'||PROVIDERID,'SHA1') PROVIDERID, DX, DX_TYPE, DX_SOURCE, DX_ORIGIN, PDX, DX_POA, RAW_DX, RAW_DX_TYPE, RAW_DX_SOURCE, RAW_ORIGDX, RAW_PDX, RAW_DX_POA from PCORNET_CDM.DIAGNOSIS cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table DISPENSING nologging parallel as select DISPENSINGID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, PRESCRIBINGID, DISPENSE_DATE, NDC, DISPENSE_SUP, DISPENSE_AMT, DISPENSE_DOSE_DISP, DISPENSE_DOSE_DISP_UNIT, DISPENSE_ROUTE, RAW_NDC, RAW_DISPENSE_DOSE_DISP, RAW_DISPENSE_DOSE_DISP_UNIT, RAW_DISPENSE_ROUTE, DISPENSE_SOURCE from PCORNET_CDM.DISPENSING cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table ENCOUNTER nologging parallel as select standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, ADMIT_DATE, ADMIT_TIME, DISCHARGE_DATE, DISCHARGE_TIME, standard_HASH('&encrypting_password'||PROVIDERID,'SHA1') PROVIDERID, standard_HASH('&encrypting_password'||FACILITY_LOCATION,'SHA1') FACILITY_LOCATION, ENC_TYPE, standard_HASH('&encrypting_password'||FACILITYID,'SHA1') FACILITYID, DISCHARGE_DISPOSITION, DISCHARGE_STATUS, DRG, DRG_TYPE, ADMITTING_SOURCE, PAYER_TYPE_PRIMARY, PAYER_TYPE_SECONDARY, FACILITY_TYPE, RAW_SITEID, RAW_ENC_TYPE, RAW_DISCHARGE_DISPOSITION, RAW_DISCHARGE_STATUS, RAW_DRG_TYPE, RAW_ADMITTING_SOURCE, RAW_FACILITY_TYPE, RAW_FACILITY_CODE, RAW_PAYER_TYPE_PRIMARY, standard_HASH('&encrypting_password'||RAW_PAYER_NAME_PRIMARY,'SHA1') RAW_PAYER_NAME_PRIMARY, standard_HASH('&encrypting_password'||RAW_PAYER_ID_PRIMARY,'SHA1') RAW_PAYER_ID_PRIMARY, RAW_PAYER_TYPE_SECONDARY, standard_HASH('&encrypting_password'||RAW_PAYER_NAME_SECONDARY,'SHA1') RAW_PAYER_NAME_SECONDARY, standard_HASH('&encrypting_password'||RAW_PAYER_ID_SECONDARY,'SHA1') RAW_PAYER_ID_SECONDARY from PCORNET_CDM.ENCOUNTER cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table ENROLLMENT nologging parallel as select standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENR_START_DATE, ENR_END_DATE, CHART, ENR_BASIS, RAW_CHART, RAW_BASIS from PCORNET_CDM.ENROLLMENT cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table HASH_TOKEN nologging parallel as select standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, TOKEN_01, TOKEN_02, TOKEN_05, TOKEN_12, TOKEN_17, TOKEN_21, TOKEN_22, TOKEN_23, TOKEN_03, TOKEN_04, TOKEN_16 from PCORNET_CDM.HASH_TOKEN cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table IMMUNIZATION nologging parallel as select IMMUNIZATIONID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, PROCEDURESID, VX_PROVIDERID, VX_RECORD_DATE, VX_ADMIN_DATE, VX_CODE_TYPE, VX_CODE, VX_STATUS, VX_STATUS_REASON, VX_SOURCE, VX_DOSE, VX_DOSE_UNIT, VX_ROUTE, VX_BODY_SITE, VX_MANUFACTURER, VX_LOT_NUM, VX_EXP_DATE, RAW_VX_NAME, RAW_VX_CODE, RAW_VX_CODE_TYPE, RAW_VX_DOSE, RAW_VX_DOSE_UNIT, RAW_VX_ROUTE, RAW_VX_BODY_SITE, RAW_VX_STATUS, RAW_VX_STATUS_REASON, RAW_VX_MANUFACTURER from PCORNET_CDM.IMMUNIZATION cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table LAB_RESULT_CM nologging parallel as select LAB_RESULT_CM_ID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, SPECIMEN_SOURCE, LAB_LOINC, PRIORITY, RESULT_LOC, LAB_PX, LAB_PX_TYPE, LAB_ORDER_DATE, SPECIMEN_DATE, SPECIMEN_TIME, RESULT_DATE, RESULT_TIME, RESULT_QUAL, RESULT_SNOMED, RESULT_NUM, RESULT_MODIFIER, RESULT_UNIT, NORM_RANGE_LOW, NORM_MODIFIER_LOW, NORM_RANGE_HIGH, NORM_MODIFIER_HIGH, ABN_IND, RAW_LAB_NAME, RAW_LAB_CODE, RAW_PANEL, RAW_RESULT, RAW_UNIT, RAW_ORDER_DEPT, RAW_FACILITY_CODE, LAB_LOINC_SOURCE, LAB_RESULT_SOURCE from PCORNET_CDM.LAB_RESULT_CM cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table LDS_ADDRESS_HISTORY nologging parallel as select ADDRESSID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, standard_HASH('&encrypting_password'||ADDRESS_USE,'SHA1') ADDRESS_USE, ADDRESS_TYPE, standard_HASH('&encrypting_password'||ADDRESS_PREFERRED,'SHA1') ADDRESS_PREFERRED, standard_HASH('&encrypting_password'||ADDRESS_CITY,'SHA1') ADDRESS_CITY, ADDRESS_STATE, ADDRESS_ZIP5, ADDRESS_ZIP9, ADDRESS_PERIOD_START, ADDRESS_PERIOD_END from PCORNET_CDM.LDS_ADDRESS_HISTORY cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table MED_ADMIN nologging parallel as select MEDADMINID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, PRESCRIBINGID, MEDADMIN_PROVIDERID, MEDADMIN_START_DATE, MEDADMIN_START_TIME, MEDADMIN_STOP_DATE, MEDADMIN_STOP_TIME, MEDADMIN_TYPE, MEDADMIN_CODE, MEDADMIN_DOSE_ADMIN, MEDADMIN_DOSE_ADMIN_UNIT, MEDADMIN_ROUTE, MEDADMIN_SOURCE, RAW_MEDADMIN_MED_NAME, RAW_MEDADMIN_CODE, RAW_MEDADMIN_DOSE_ADMIN, RAW_MEDADMIN_DOSE_ADMIN_UNIT, RAW_MEDADMIN_ROUTE from PCORNET_CDM.MED_ADMIN cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table OBS_CLIN nologging parallel as select OBSCLINID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, OBSCLIN_PROVIDERID, OBSCLIN_START_DATE, OBSCLIN_START_TIME, OBSCLIN_STOP_DATE, OBSCLIN_STOP_TIME, OBSCLIN_TYPE, OBSCLIN_CODE, OBSCLIN_RESULT_QUAL, OBSCLIN_RESULT_TEXT, OBSCLIN_RESULT_SNOMED, OBSCLIN_RESULT_NUM, OBSCLIN_RESULT_MODIFIER, OBSCLIN_RESULT_UNIT, OBSCLIN_ABN_IND, RAW_OBSCLIN_NAME, RAW_OBSCLIN_CODE, RAW_OBSCLIN_TYPE, RAW_OBSCLIN_RESULT, RAW_OBSCLIN_MODIFIER, RAW_OBSCLIN_UNIT, OBSCLIN_SOURCE from PCORNET_CDM.OBS_CLIN cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table OBS_GEN nologging parallel as select OBSGENID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, OBSGEN_PROVIDERID, OBSGEN_START_DATE, OBSGEN_START_TIME, OBSGEN_STOP_DATE, OBSGEN_STOP_TIME, OBSGEN_TYPE, OBSGEN_CODE, OBSGEN_RESULT_QUAL, OBSGEN_RESULT_TEXT, OBSGEN_RESULT_NUM, OBSGEN_RESULT_MODIFIER, OBSGEN_RESULT_UNIT, OBSGEN_TABLE_MODIFIED, OBSGEN_ID_MODIFIED, OBSGEN_ABN_IND, RAW_OBSGEN_NAME, RAW_OBSGEN_CODE, RAW_OBSGEN_TYPE, RAW_OBSGEN_RESULT, RAW_OBSGEN_UNIT, OBSGEN_SOURCE from PCORNET_CDM.OBS_GEN cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table PCORNET_TRIAL nologging parallel as select standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, TRIALID, PARTICIPANTID, TRIAL_SITEID, TRIAL_ENROLL_DATE, TRIAL_END_DATE, TRIAL_WITHDRAW_DATE, TRIAL_INVITE_CODE from PCORNET_CDM.PCORNET_TRIAL cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table PRESCRIBING nologging parallel as select PRESCRIBINGID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, RX_PROVIDERID, RX_ORDER_DATE, RX_ORDER_TIME, RX_START_DATE, RX_END_DATE, RX_DOSE_ORDERED, RX_DOSE_ORDERED_UNIT, RX_QUANTITY, RX_DOSE_FORM, RX_REFILLS, RX_DAYS_SUPPLY, RX_FREQUENCY, RX_PRN_FLAG, RX_ROUTE, RX_BASIS, RXNORM_CUI, RX_SOURCE, RX_DISPENSE_AS_WRITTEN, RAW_RX_MED_NAME, RAW_RX_FREQUENCY, RAW_RXNORM_CUI, RAW_RX_QUANTITY, RAW_RX_NDC, RAW_RX_DOSE_ORDERED, RAW_RX_DOSE_ORDERED_UNIT, RAW_RX_ROUTE, RAW_RX_REFILLS from PCORNET_CDM.PRESCRIBING cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table PROCEDURES nologging parallel as select PROCEDURESID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, ENC_TYPE, ADMIT_DATE, standard_HASH('&encrypting_password'||PROVIDERID,'SHA1') PROVIDERID, PX_DATE, PX, PX_TYPE, PX_SOURCE, PPX, RAW_PX, RAW_PX_TYPE, RAW_PPX from PCORNET_CDM.PROCEDURES cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table PRO_CM nologging parallel as select PRO_CM_ID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, PRO_DATE, PRO_TIME, PRO_TYPE, PRO_ITEM_NAME, PRO_ITEM_LOINC, PRO_RESPONSE_TEXT, PRO_RESPONSE_NUM, PRO_METHOD, PRO_MODE, PRO_CAT, PRO_ITEM_VERSION, PRO_MEASURE_NAME, PRO_MEASURE_SEQ, PRO_MEASURE_SCORE, PRO_MEASURE_THETA, PRO_MEASURE_SCALED_TSCORE, PRO_MEASURE_STANDARD_ERROR, PRO_MEASURE_COUNT_SCORED, PRO_MEASURE_LOINC, PRO_MEASURE_VERSION, PRO_ITEM_FULLNAME, PRO_ITEM_TEXT, PRO_MEASURE_FULLNAME, PRO_SOURCE from PCORNET_CDM.PRO_CM cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table VITAL nologging parallel as select VITALID, standard_HASH('&encrypting_password'||he.patient_ide,'SHA1') PATID, ENCOUNTERID, MEASURE_DATE, MEASURE_TIME, VITAL_SOURCE, HT, WT, DIASTOLIC, SYSTOLIC, ORIGINAL_BMI, BP_POSITION, SMOKING, TOBACCO, TOBACCO_TYPE, RAW_VITAL_SOURCE, RAW_HT, RAW_WT, RAW_DIASTOLIC, RAW_SYSTOLIC, RAW_BP_POSITION, RAW_SMOKING, RAW_TOBACCO, RAW_TOBACCO_TYPE from PCORNET_CDM.VITAL cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='Epic@kumed.com' ;
create table HARVEST nologging parallel as select NETWORKID, NETWORK_NAME, DATAMARTID, DATAMART_NAME, DATAMART_PLATFORM, CDM_VERSION, DATAMART_CLAIMS, DATAMART_EHR, TOKEN_ENCRYPTION_KEY, BIRTH_DATE_MGMT, ENR_START_DATE_MGMT, ENR_END_DATE_MGMT, ADMIT_DATE_MGMT, DISCHARGE_DATE_MGMT, DX_DATE_MGMT, PX_DATE_MGMT, RX_ORDER_DATE_MGMT, RX_START_DATE_MGMT, RX_END_DATE_MGMT, DISPENSE_DATE_MGMT, LAB_ORDER_DATE_MGMT, SPECIMEN_DATE_MGMT, RESULT_DATE_MGMT, MEASURE_DATE_MGMT, ONSET_DATE_MGMT, REPORT_DATE_MGMT, RESOLVE_DATE_MGMT, PRO_DATE_MGMT, DEATH_DATE_MGMT, MEDADMIN_START_DATE_MGMT, MEDADMIN_STOP_DATE_MGMT, OBSCLIN_START_DATE_MGMT, OBSCLIN_STOP_DATE_MGMT, OBSGEN_DATE_MGMT, OBSGEN_START_DATE_MGMT, OBSGEN_STOP_DATE_MGMT, ADDRESS_PERIOD_START_MGMT, ADDRESS_PERIOD_END_MGMT, VX_RECORD_DATE_MGMT, VX_ADMIN_DATE_MGMT, VX_EXP_DATE_MGMT, REFRESH_HASH_TOKEN_DATE, REFRESH_LDS_ADDRESS_HX_DATE, REFRESH_IMMUNIZATION_DATE, REFRESH_DEMOGRAPHIC_DATE, REFRESH_ENROLLMENT_DATE, REFRESH_ENCOUNTER_DATE, REFRESH_DIAGNOSIS_DATE, REFRESH_PROCEDURES_DATE, REFRESH_VITAL_DATE, REFRESH_DISPENSING_DATE, REFRESH_LAB_RESULT_CM_DATE, REFRESH_CONDITION_DATE, REFRESH_PRO_CM_DATE, REFRESH_PRESCRIBING_DATE, REFRESH_PCORNET_TRIAL_DATE, REFRESH_DEATH_DATE, REFRESH_DEATH_CAUSE_DATE, REFRESH_MED_ADMIN_DATE, REFRESH_OBS_CLIN_DATE, REFRESH_PROVIDER_DATE, REFRESH_OBS_GEN_DATE from PCORNET_CDM.HARVEST ;
create table PROVIDER nologging parallel as select standard_HASH('&encrypting_password'||PROVIDERID,'SHA1') PROVIDERID, PROVIDER_SEX, PROVIDER_SPECIALTY_PRIMARY, standard_HASH('&encrypting_password'||PROVIDER_NPI,'SHA1') PROVIDER_NPI, PROVIDER_NPI_FLAG, RAW_PROVIDER_SPECIALTY_PRIMARY from PCORNET_CDM.PROVIDER ;
-- test columns
select  case when count(*) = 0 then 0 else 1/0 END pass_fail from IMMUNIZATION where trim(VX_PROVIDERID) is not null;
select  case when count(*) = 0 then 0 else 1/0 END pass_fail from MED_ADMIN    where trim(medadmin_providerid) is not null;
select  case when count(*) = 0 then 0 else 1/0 END pass_fail from OBS_CLIN     where trim(OBSCLIN_PROVIDERID) is not null;
select  case when count(*) = 0 then 0 else 1/0 END pass_fail from OBS_GEN      where trim(OBSGEN_PROVIDERID) is not null;
select  case when count(*) = 0 then 0 else 1/0 END pass_fail from PRESCRIBING  where trim(rx_providerid) is not null;
exit;
