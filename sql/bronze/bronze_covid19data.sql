/*

Author: Augusto Rosa

Source: Data Lake Gen2 (bronze.owid-covid-data.parquet)

Description: Create the bronze view (bronze.covid19data) for further analysis

Language Used: SQL, T-SQL

*/
--
-- Create the database
CREATE DATABASE datalakehouse;
GO
--
-- Select the created database
USE datalakehouse;
GO
--
-- Create schemas for different data layers
CREATE SCHEMA bronze; -- Raw Layer
CREATE SCHEMA silver; -- ETL Layer
GO
--
-- Create an external data source pointing to the Data Lake
CREATE EXTERNAL DATA SOURCE MyDataLakeStorage WITH (
    LOCATION = 'https://metastoredatalake.dfs.core.windows.net',
    CREDENTIAL = StorageCredential
);
--
-- Create or alter a view to expose the raw COVID-19 data from the Data Lake
CREATE OR ALTER VIEW bronze.covid19data AS
SELECT
    *
FROM
    OPENROWSET(
        BULK 'bronze/2025-05-14/owid-covid-data.parquet',
        DATA_SOURCE = 'MyDataLakeStorage',
        FORMAT = 'PARQUET',
		PARSER_VERSION = '2.0'
    ) AS bronze_covid19data_result;
