/*

Author: Augusto Rosa

Source: Bronze layer (bronze.owid-covid-data.parquet)

Description: Create ft_test_positivity

Language Used: SQL, T-SQL

*/
--
-- Generating the values to be inserted into silver.ft_test_positivity
DROP VIEW IF EXISTS silver.ft_test_positivity;
--
CREATE OR ALTER VIEW silver.ft_test_positivity AS
WITH built_ft_test_positivity AS (
SELECT 
	CASE
		WHEN new_tests = '' THEN 0
		ELSE CAST(new_tests AS BIGINT)
	END AS new_tests
,	CASE
		WHEN new_tests_per_thousand = '' THEN 0.00
		ELSE CAST(new_tests_per_thousand AS DECIMAL(10,2))
	END AS new_tests_per_thousand
,	CASE
		WHEN total_tests = '' THEN 0
		ELSE CAST(total_tests AS BIGINT)
	END AS total_tests
,	CASE
		WHEN total_tests_per_thousand = '' THEN 0.00
		ELSE CAST(total_tests_per_thousand AS DECIMAL(10,2))
	END AS total_tests_per_thousand
,	CASE 
		WHEN new_tests_smoothed = '' THEN 0.0
		ELSE CAST(new_tests_smoothed AS DECIMAL(10,1))
	END AS new_tests_smoothed
,	CASE 
		WHEN new_tests_smoothed_per_thousand = '' THEN 0.00
		ELSE CAST(new_tests_smoothed_per_thousand AS DECIMAL(10,2))
	END AS new_tests_smoothed_per_thousand
,	CASE
		WHEN positive_rate = '' THEN 0.00
		ELSE CAST(positive_rate AS DECIMAL(10,2))
	END AS positive_rate
,	CASE 
		WHEN tests_per_case = '' THEN 0.0
		ELSE CAST(tests_per_case AS DECIMAL(10,1))
	END AS tests_per_case
,	CAST(REPLACE([date], '-', '') AS INT) AS date_int
,	iso_code
,	ROW_NUMBER () OVER(PARTITION BY iso_code, [date] ORDER BY iso_code, [date] ASC) AS rn
FROM bronze.covid19data
WHERE 1=1
AND COALESCE(
	NULLIF (new_tests, '')
,	NULLIF (new_tests_per_thousand, '')	
,	NULLIF (total_tests, '')
,	NULLIF (total_tests_per_thousand, '')
,	NULLIF (new_tests_smoothed, '')
,	NULLIF (new_tests_smoothed_per_thousand, '')
,	NULLIF (positive_rate, '')
,	NULLIF (tests_per_case, '')) IS NOT NULL
)
SELECT
	ftp.new_tests
,	ftp.new_tests_per_thousand
,	ftp.total_tests
,	ftp.total_tests_per_thousand
,	ftp.new_tests_smoothed
,	ftp.new_tests_smoothed_per_thousand
,	ftp.positive_rate
,	ftp.tests_per_case
,	dc.country_id
,	dt.date_integer_id
FROM built_ft_test_positivity ftp
INNER JOIN silver.dm_country dc ON (dc.country_code = ftp.iso_code)
INNER JOIN silver.dm_time dt ON (dt.date_integer_id = ftp.date_int)
WHERE 1=1
AND ftp.rn = 1;