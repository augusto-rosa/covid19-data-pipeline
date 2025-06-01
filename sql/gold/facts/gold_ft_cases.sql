/*
Author: Augusto Rosa

Source: Synapse (silver.ft_cases)

Description: Create gold.ft_cases - Fact table for COVID-19 cases

Dependencies:
- gold.dm_country
- gold.dm_time

Language Used: SQL, T-SQL
*/

--
DROP TABLE IF EXISTS gold.ft_cases;
--
-- Create the gold.ft_cases table
CREATE TABLE gold.ft_cases (
new_cases INT NULL,
new_cases_per_million DECIMAL(10,2) NULL,
new_cases_smoothed DECIMAL(10,2) NULL,
new_cases_smoothed_per_million DECIMAL(10,2) NULL,
total_cases_per_million DECIMAL(10, 2) NULL,
total_cases INT NULL,
country_id INT NOT NULL,
date_integer_id INT NOT NULL,
insert_date DATE DEFAULT CAST(GETDATE() AS DATE),
PRIMARY KEY (country_id, date_integer_id),
CONSTRAINT fk_ft_cases_country FOREIGN KEY (country_id) REFERENCES gold.dm_country (country_id),
CONSTRAINT fk_ft_cases_date FOREIGN KEY (date_integer_id) REFERENCES gold.dm_time (date_integer_id));
--
-- Additional indexes for query optimization
CREATE INDEX idx_ft_cases_date ON gold.ft_cases(date_integer_id);
CREATE INDEX idx_ft_cases_country_date_integer ON gold.ft_cases(country_id, date_integer_id);