/*

Author: Augusto Rosa

Source: Bronze layer (bronze.owid-covid-data.parquet)

Description: Create ft_cases

Language Used: SQL, T-SQL

*/
-- Generating the values to be inserted into silver.ft_cases
DROP VIEW IF EXISTS silver.ft_cases;
--
CREATE OR ALTER VIEW silver.ft_cases AS
WITH built_ft_cases AS (
SELECT 
	CAST(new_cases AS INT) AS new_cases
,	CASE 
		WHEN new_cases_per_million = '' THEN 0.00
		ELSE CAST(new_cases_per_million AS DECIMAL(10,2)) 
	END AS new_cases_per_million
,	CASE 
		WHEN new_cases_smoothed = '' THEN 0.00
		ELSE CAST(new_cases_smoothed AS DECIMAL(10,2))
	END AS new_cases_smoothed
,	CASE 
		WHEN new_cases_smoothed_per_million = '' THEN 0.00
		ELSE CAST(new_cases_smoothed_per_million AS DECIMAL(10,2))
		END AS new_cases_smoothed_per_million
,	CASE
		WHEN total_cases_per_million = '' THEN 0.00
		ELSE CAST(total_cases_per_million AS DECIMAL(10,2))
	END AS total_cases_per_million
,	CAST(total_cases AS INT) AS total_cases
,	CAST(REPLACE([date], '-', '') AS INT) AS date_int
,	iso_code
,	ROW_NUMBER () OVER(PARTITION BY iso_code, [date] ORDER BY iso_code, [date] ASC) AS rn
FROM bronze.covid19data
WHERE 1=1
AND COALESCE(
	NULLIF(new_cases_per_million, '')
,	NULLIF(new_cases_smoothed, '')
,	NULLIF(new_cases_smoothed_per_million, '')
,	NULLIF(total_cases_per_million, '')) IS NOT NULL
)
SELECT
	bfc.new_cases
,	bfc.new_cases_per_million
,	bfc.new_cases_smoothed
,	bfc.new_cases_smoothed_per_million
,	bfc.total_cases_per_million
,	bfc.total_cases
,	dc.country_id
,	dt.date_integer_id
FROM built_ft_cases bfc
INNER JOIN silver.dm_country dc ON (dc.country_code = bfc.iso_code)
INNER JOIN silver.dm_time dt ON (dt.date_integer_id = bfc.date_int)
WHERE 1=1
AND bfc.rn = 1;