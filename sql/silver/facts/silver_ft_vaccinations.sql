/*

Author: Augusto Rosa

Source: Bronze layer (bronze.owid-covid-data.parquet)

Description: Create ft_vaccinations

Language Used: SQL, T-SQL

*/
--
-- Generating the values to be inserted into silver.ft_vaccinations
DROP VIEW IF EXISTS silver.ft_vaccinations;
--
CREATE OR ALTER VIEW silver.ft_vaccinations AS
WITH built_ft_vaccinations AS (
SELECT 
	CASE
		WHEN new_vaccinations = '' THEN 0
		ELSE CAST(new_vaccinations AS BIGINT)
	END AS new_vaccinations
,	CASE 
		WHEN new_vaccinations_smoothed = '' THEN 0.00
		ELSE CAST(new_vaccinations_smoothed AS DECIMAL(10,2)) 
	END AS new_vaccinations_smoothed
,	CASE 
		WHEN new_vaccinations_smoothed_per_million = '' THEN 0.00
		ELSE CAST(new_vaccinations_smoothed_per_million AS DECIMAL(10,2))
	END AS new_vaccinations_smoothed_per_million
,	CASE 
		WHEN total_vaccinations_per_hundred = '' THEN 0.00
		ELSE CAST(total_vaccinations_per_hundred AS DECIMAL(10,2))
	END AS total_vaccinations_per_hundred
,	CASE
		WHEN total_vaccinations = '' THEN 0
		ELSE CAST(total_vaccinations AS BIGINT)
	END AS total_vaccinations
,	CASE
		WHEN people_vaccinated = '' THEN 0
		ELSE CAST(people_vaccinated AS BIGINT) 
	END AS people_vaccinated
,	CASE
		WHEN people_vaccinated_per_hundred = '' THEN 0.00
		ELSE CAST(people_vaccinated_per_hundred AS DECIMAL(10,2))
	END AS people_vaccinated_per_hundred
,	CASE 
		WHEN people_fully_vaccinated = '' THEN 0
		ELSE CAST(people_fully_vaccinated AS BIGINT)
	END AS people_fully_vaccinated
,	CASE 
		WHEN people_fully_vaccinated_per_hundred = '' THEN 0.00
		ELSE CAST(people_fully_vaccinated_per_hundred AS DECIMAL(10,2))
	END AS people_fully_vaccinated_per_hundred
,	CASE 
		WHEN new_people_vaccinated_smoothed = '' THEN 0.00
		ELSE CAST(new_people_vaccinated_smoothed AS DECIMAL(10,2))
	END AS new_people_vaccinated_smoothed
,	CASE
		WHEN new_people_vaccinated_smoothed_per_hundred = '' THEN 0.00
		ELSE CAST(new_people_vaccinated_smoothed_per_hundred AS DECIMAL(10,2))
	END AS new_people_vaccinated_smoothed_per_hundred
,	CAST(REPLACE([date], '-', '') AS INT) AS date_int
,	iso_code
,	ROW_NUMBER () OVER(PARTITION BY iso_code, [date] ORDER BY iso_code, [date] ASC) AS rn
FROM bronze.covid19data
WHERE 1=1
AND COALESCE(
	NULLIF(new_vaccinations, '')
,	NULLIF(new_vaccinations_smoothed, '')
,	NULLIF(new_vaccinations_smoothed_per_million, '')
,	NULLIF(total_vaccinations_per_hundred, '')
,	NULLIF(total_vaccinations, '')
,	NULLIF(people_vaccinated, '')
,	NULLIF(people_vaccinated_per_hundred, '')
,	NULLIF(people_fully_vaccinated, '')
,	NULLIF(people_fully_vaccinated_per_hundred, '')
,	NULLIF(new_people_vaccinated_smoothed, '')
,	NULLIF(new_people_vaccinated_smoothed_per_hundred, '')) IS NOT NULL
)
SELECT 
	fvc.new_vaccinations
,	fvc.new_vaccinations_smoothed
,	fvc.new_vaccinations_smoothed_per_million
,	fvc.total_vaccinations_per_hundred
,	fvc.total_vaccinations
,	fvc.people_vaccinated
,	fvc.people_vaccinated_per_hundred
,	fvc.people_fully_vaccinated
,	fvc.people_fully_vaccinated_per_hundred
,	fvc.new_people_vaccinated_smoothed
,	fvc.new_people_vaccinated_smoothed_per_hundred
,	dc.country_id
,	dt.date_integer_id
FROM built_ft_vaccinations fvc
INNER JOIN silver.dm_country dc ON (dc.country_code = fvc.iso_code)
INNER JOIN silver.dm_time dt ON (dt.date_integer_id = fvc.date_int)
WHERE 1=1
AND fvc.rn = 1;