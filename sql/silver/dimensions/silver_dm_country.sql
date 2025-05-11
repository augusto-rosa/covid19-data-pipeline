/*

Author: Augusto Rosa

Source: Bronze layer (bronze.covid19data)

Description: Create silver.DM_COUNTRY

Language Used: SQL, T-SQL

*/
--
USE azure_projects
GO
SELECT TOP 10 * FROM bronze.covid19data;
--
-- Criando a tabela dm_country
--
DROP TABLE IF EXISTS silver.dm_country
--
CREATE TABLE silver.dm_country (
country_id INT,
country_code VARCHAR(10),
continent VARCHAR(20),
country VARCHAR(80),
population BIGINT,
PRIMARY KEY (country_id));
--
-- Gerando os valores a serem inseridos na dm_country
--
WITH ranked_population AS (
SELECT
	code AS country_code
,	continent
,	country
,	population
,	ROW_NUMBER() OVER(PARTITION BY code ORDER BY population DESC) AS population_per_country --  maior população dentro de cada país
FROM bronze.covid19data
)
INSERT INTO silver.dm_country (country_id, country_code, continent, country, population) -- Inserindo valores na dm_country com base na subquery abaixo
SELECT 
	ROW_NUMBER() OVER(ORDER BY country ASC) AS country_id
,	country_code
,	continent
,	country
,	population
FROM ranked_population
WHERE 1=1
AND population_per_country = 1 -- Irá me trazer o maior valor da população de cada pais
AND country_code IS NOT NULL
AND country_code NOT IN ('OWID_WRL', 'OWID_TRS', 'OWID_SAM', 'OWID_OCE', 'OWID_NAM', 'OWID_KOS', 'OWID_EUR', 'OWID_EU27', 'OWID_ASI', 'OWID_AFR')
ORDER BY country ASC;
--
-- Validando os registros na dm_country
--
SELECT * FROM silver.dm_country





