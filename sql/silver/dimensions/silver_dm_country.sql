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
DROP TABLE IF EXISTS silver.dm_country;
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
	iso_code AS country_code
,	continent
,	location AS country
,	population
,	ROW_NUMBER() OVER(PARTITION BY iso_code ORDER BY population DESC) AS population_per_country --  maior população dentro de cada país
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
AND country_code NOT IN ('OWID_WRL', 'OWID_TRS', 'OWID_SAM', 'OWID_OCE', 'OWID_NAM', 'OWID_KOS', 
'OWID_EUR', 'OWID_EU27', 'OWID_ASI', 'OWID_AFR', 'OWID_EUN', 'OWID_HIC', 'OWID_LIC', 'OWID_LMC', 'OWID_UMC')
ORDER BY country ASC;
--
-- Validando os registros inseridos na dm_country
--
SELECT * FROM silver.dm_country;
--
-- Alterando o nome de "Micronesia (country)" para "Micronesia"
SELECT * FROM silver.dm_country
WHERE 1=1
AND country_id = 137; -- id do pais 'Micronesia' 
--
-- Alterando o nome para "Micronesia"
UPDATE silver.dm_country
SET country = 'Micronesia'
WHERE 1=1 
AND country_id = 137;
--
-- Atualizando o Country_code de England, Northern Ireland, Scotland, Wales e Northern Cyprus
--
-- ** England ** 
--
UPDATE silver.dm_country
SET country_code = 'ENG'
WHERE 1=1 
AND country_id = 64;
--
-- ** Northern Ireland ** 
--
UPDATE silver.dm_country
SET country_code = 'NIR'
WHERE 1=1 
AND country_id = 159;
--
-- ** Scotland ** 
--
UPDATE silver.dm_country
SET country_code = 'SCT'
WHERE 1=1 
AND country_id = 191;
--
-- ** Wales ** 
--
UPDATE silver.dm_country
SET country_code = 'WLS'
WHERE 1=1 
AND country_id = 237;
--
-- ** Northern Cyprus ** 
--
UPDATE silver.dm_country
SET country_code = 'CYN'
WHERE 1=1 
AND country_id = 158;
--
-- Validando os dados após atualizações
SELECT * FROM silver.dm_country;






