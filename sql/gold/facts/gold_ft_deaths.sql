/*
Author: Augusto Rosa

Source: Synapse (silver.ft_deaths)

Description: Create gold.ft_deaths - Fact table for COVID-19 deaths

Dependencies:
- gold.dm_country
- gold.dm_time

Language Used: SQL, T-SQL
*/
--
DROP TABLE IF EXISTS gold.ft_deaths;
--
-- Create the gold.ft_deaths table
CREATE TABLE gold.ft_deaths (
new_deaths INT NULL,
new_deaths_per_million DECIMAL(10,2) NULL,
new_deaths_smoothed DECIMAL(10,2) NULL,
new_deaths_smoothed_per_million DECIMAL(10,2) NULL,
total_deaths_per_million DECIMAL(10,2) NULL,
total_deaths INT NULL,
country_id INT NOT NULL,
date_integer_id INT NOT NULL,
insert_date DATE DEFAULT CAST(GETDATE() AS DATE),
PRIMARY KEY (country_id, date_integer_id),
CONSTRAINT fk_ft_deaths_country FOREIGN KEY (country_id) REFERENCES gold.dm_country(country_id),
CONSTRAINT fk_ft_deaths_date FOREIGN KEY (date_integer_id) REFERENCES gold.dm_time(date_integer_id));
--
-- Additional indexes for query optimization
CREATE INDEX idx_ft_deaths_date ON gold.ft_deaths(date_integer_id);
CREATE INDEX idx_ft_deaths_country_date_integer ON gold.ft_deaths(country_id, date_integer_id);
