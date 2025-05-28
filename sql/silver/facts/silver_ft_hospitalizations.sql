/*

Author: Augusto Rosa

Source: Bronze layer (bronze.owid-covid-data.parquet)

Description: Create silver.ft_hospitalizations

Language Used: SQL, T-SQL

*/
-- Generating the values to be inserted into silver.ft_hospitalizations
DROP VIEW IF EXISTS silver.ft_hospitalizations;
--
CREATE OR ALTER VIEW silver.ft_hospitalizations AS
WITH built_ft_hospitalizations AS (
SELECT 
	CASE
		WHEN icu_patients = '' THEN 0
		ELSE CAST(icu_patients AS INT)
	END AS icu_patients
,	CASE
		WHEN icu_patients_per_million = '' THEN 0.00
		ELSE CAST(icu_patients_per_million AS DECIMAL(10,2))
	END AS icu_patients_per_million
,	CASE
		WHEN hosp_patients = '' THEN 0
		ELSE CAST(hosp_patients AS INT)
	END AS hosp_patients
,	CASE
		WHEN hosp_patients_per_million = '' THEN 0.00
		ELSE CAST(hosp_patients_per_million AS DECIMAL(10,2))
	END AS hosp_patients_per_million
,	CASE 
		WHEN weekly_icu_admissions = '' THEN 0
		ELSE CAST(weekly_icu_admissions AS INT)
	END AS weekly_icu_admissions
,	CASE 
		WHEN weekly_icu_admissions_per_million = '' THEN 0.00
		ELSE CAST(weekly_icu_admissions_per_million AS DECIMAL(10,2))
	END AS weekly_icu_admissions_per_million
,	CASE
		WHEN weekly_hosp_admissions = '' THEN 0
		ELSE CAST(weekly_hosp_admissions AS INT)
	END AS weekly_hosp_admissions
,	CASE 
		WHEN weekly_hosp_admissions_per_million = '' THEN 0.00
		ELSE CAST(weekly_hosp_admissions_per_million AS DECIMAL(10,2))
	END AS weekly_hosp_admissions_per_million
,	CAST(REPLACE([date], '-', '') AS INT) AS date_int
,	iso_code
,	ROW_NUMBER () OVER(PARTITION BY iso_code, [date] ORDER BY iso_code, [date] ASC) AS rn
FROM bronze.covid19data
WHERE 1=1
AND COALESCE(
	NULLIF (icu_patients, '')
,	NULLIF (icu_patients_per_million, '')	
,	NULLIF (hosp_patients, '')
,	NULLIF (hosp_patients_per_million, '')
,	NULLIF (weekly_icu_admissions, '')
,	NULLIF (weekly_icu_admissions_per_million, '')
,	NULLIF (weekly_hosp_admissions, '')
,	NULLIF (weekly_hosp_admissions_per_million, '')) IS NOT NULL
)
SELECT
	fhp.icu_patients
,	fhp.icu_patients_per_million
,	fhp.hosp_patients
,	fhp.hosp_patients_per_million
,	fhp.weekly_icu_admissions
,	fhp.weekly_icu_admissions_per_million
,	fhp.weekly_hosp_admissions
,	fhp.weekly_hosp_admissions_per_million
,	dc.country_id
,	dt.date_integer_id
FROM built_ft_hospitalizations fhp
INNER JOIN silver.dm_country dc ON (dc.country_code = fhp.iso_code)
INNER JOIN silver.dm_time dt ON (dt.date_integer_id = fhp.date_int)
WHERE 1=1
AND fhp.rn = 1;