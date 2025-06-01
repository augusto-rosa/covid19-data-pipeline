/*
Author: Augusto Rosa

Source: Synapse (silver.ft_hospitalizations)

Description: Create gold.ft_hospitalizations - Fact table for COVID-19 hospitalizations

Dependencies:
- gold.dm_country
- gold.dm_time

Language Used: SQL, T-SQL
*/
--
DROP TABLE IF EXISTS gold.ft_hospitalizations;
--
-- Create the ft_hospitalizations table
CREATE TABLE gold.ft_hospitalizations (
icu_patients INT NULL,
icu_patients_per_million DECIMAL(10, 2) NULL,
hosp_patients INT NULL,
hosp_patients_per_million DECIMAL(10, 2) NULL,
weekly_icu_admissions INT NULL,
weekly_icu_admissions_per_million DECIMAL(10, 2) NULL,
weekly_hosp_admissions INT NULL,
weekly_hosp_admissions_per_million DECIMAL(10, 2) NULL,
country_id INT NOT NULL,
date_integer_id INT NOT NULL,
insert_date DATE DEFAULT CAST(GETDATE() AS DATE),
PRIMARY KEY (country_id, date_integer_id),
CONSTRAINT fk_ft_hospitalizations_country FOREIGN KEY (country_id) REFERENCES gold.dm_country(country_id),
CONSTRAINT fk_ft_hospitalizations_date FOREIGN KEY (date_integer_id) REFERENCES gold.dm_time(date_integer_id));
--
-- Additional indexes for query optimization
CREATE INDEX idx_ft_hospitalizations_date ON gold.ft_hospitalizations(date_integer_id);
CREATE INDEX idx_ft_hospitalizations_country_date_integer ON gold.ft_hospitalizations(country_id, date_integer_id);