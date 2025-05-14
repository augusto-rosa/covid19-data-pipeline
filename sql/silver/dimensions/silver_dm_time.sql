/*

Author: Augusto Rosa

Source: Bronze layer (bronze.covid19data)

Description: Create DM_TIME

Language Used: SQL, T-SQL

*/
--
USE azure_projects
GO
SELECT TOP 10 * FROM bronze.covid19data;
--
-- Deletando a tabela caso ela já exista
--
DROP TABLE IF EXISTS silver.dm_time;
--
-- Criando a tabela silver.dm_time
--
CREATE TABLE silver.dm_time (
date_integer_id INT,
[date] DATE,
[year] INT,
[quarter] TINYINT,
[month] TINYINT,
[week] TINYINT,
[day] TINYINT,
[weekday] TINYINT,
PRIMARY KEY (date_integer_id));
--
-- Gerando os valores a serem inseridos na dm_country
--
WITH distinct_date AS (
SELECT 
	[date] AS unique_date
,	ROW_NUMBER() OVER(PARTITION BY [date] ORDER BY [date] ASC) AS unique_date_rn
FROM bronze.covid19data
) INSERT INTO silver.dm_time (date_integer_id, [date], [year], [quarter], [month], [week], [day], [weekday])
SELECT
-- Gera o date_id no formato YYYYMMDD como INT para uso como chave estrangeira (FK) nas tabelas fato,
-- proporcionando melhor performance em joins e menor consumo de espaço comparado com tipos DATE/VARCHAR
	CAST(REPLACE(unique_date, '-', '') AS INT) AS date_integer_id
,	CAST(unique_date AS DATE) AS [date]
,	DATEPART(YEAR, unique_date) AS [year]
,	DATEPART(QUARTER, unique_date) AS [quarter]
,	DATEPART(MONTH, unique_date) AS [month]
,	DATEPART(WEEK, unique_date) AS [week]
,	DATEPART(DAY, unique_date) AS [day]
,	DATEPART(WEEKDAY, unique_date) AS [weekday]
FROM distinct_date
WHERE 1=1
AND unique_date_rn = 1
ORDER BY unique_date ASC
--
-- Validando os registros inseridos na silver.dm_time
--
SELECT 
    COUNT(*) AS total_records,
    MIN([date]) AS min_date,
    MAX([date]) AS max_date
FROM silver.dm_time;
