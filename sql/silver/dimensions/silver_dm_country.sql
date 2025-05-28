/*

Author: Augusto Rosa

Source: Bronze View (bronze.covid19data)

Description: Create silver.DM_COUNTRY

Language Used: SQL, T-SQL

*/

-- Generating the values to be inserted into silver.dm_country
DROP VIEW IF EXISTS silver.dm_country;
--
CREATE OR ALTER VIEW silver.dm_country AS
WITH ranked_population AS (
    SELECT
        iso_code AS country_code,
        continent,
        location AS country,
        population,
        ROW_NUMBER() OVER(PARTITION BY iso_code ORDER BY population DESC) AS population_per_country -- Getting the Highest population per country
    FROM bronze.covid19data
)
SELECT 
    ROW_NUMBER() OVER(ORDER BY country ASC) AS country_id,
    country_code,
    continent,
    country,
    population
FROM ranked_population
WHERE 1=1
    AND population_per_country = 1 -- Returns the highest population value for each country
    AND country_code IS NOT NULL
    AND country_code NOT IN (
        'OWID_WRL', 'OWID_TRS', 'OWID_SAM', 'OWID_OCE', 'OWID_NAM', 'OWID_KOS',
        'OWID_EUR', 'OWID_EU27', 'OWID_ASI', 'OWID_AFR', 'OWID_EUN', 
        'OWID_HIC', 'OWID_LIC', 'OWID_LMC', 'OWID_UMC'
    );
