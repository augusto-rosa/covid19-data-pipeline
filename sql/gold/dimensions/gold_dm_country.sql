/*
Author: Augusto Rosa

Source: Synapse (silver.dm_country)

Description: Create gold.dm_country

Language Used: SQL, T-SQL
*/
--
DROP TABLE IF EXISTS gold.dm_country;
--
CREATE TABLE gold.dm_country (
country_id INT NOT NULL,
country_code VARCHAR(5) NOT NULL,
continent VARCHAR(20) NOT NULL,
country VARCHAR(80) NOT NULL,
population BIGINT,
created_at DATE DEFAULT CAST(GETDATE() AS DATE),
updated_at DATE DEFAULT CAST(GETDATE() AS DATE), 
PRIMARY KEY (country_id),
UNIQUE (country_code),
UNIQUE (country),
CONSTRAINT chk_population CHECK (population >= 0 OR population IS NULL));
--
-- Additional indexes for query optimization
CREATE INDEX idx_dm_country_country_code ON gold.dm_country(country_code);
CREATE INDEX idx_dm_country_country_name ON gold.dm_country(country);
CREATE INDEX idx_dm_country_continent ON gold.dm_country(continent);