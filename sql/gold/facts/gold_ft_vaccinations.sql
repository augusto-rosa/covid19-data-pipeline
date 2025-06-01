/*
Author: Augusto Rosa

Source: Synapse (silver.ft_vaccinations)

Description: Create gold.ft_vaccinations - Fact table for COVID-19 vaccinations

Dependencies:
- gold.dm_country
- gold.dm_time

Language Used: SQL, T-SQL
*/
--
DROP TABLE IF EXISTS gold.ft_vaccinations;
--
-- Create the ft_vaccinations table
CREATE TABLE gold.ft_vaccinations (
new_vaccinations BIGINT NULL,
new_vaccinations_smoothed DECIMAL(10, 2) NULL,
new_vaccinations_smoothed_per_million DECIMAL(10, 2) NULL,
total_vaccinations_per_hundred DECIMAL(10, 2) NULL,
total_vaccinations BIGINT NULL,
people_vaccinated BIGINT NULL,
people_vaccinated_per_hundred DECIMAL(10, 2) NULL,
people_fully_vaccinated BIGINT NULL,
people_fully_vaccinated_per_hundred DECIMAL(10, 2) NULL,
new_people_vaccinated_smoothed DECIMAL(10, 2) NULL,
new_people_vaccinated_smoothed_per_hundred DECIMAL(10, 2) NULL,
country_id INT NOT NULL,
date_integer_id INT NOT NULL,
insert_date DATE DEFAULT CAST(GETDATE() AS DATE),
PRIMARY KEY (country_id, date_integer_id),
CONSTRAINT fk_ft_vaccinations_country FOREIGN KEY (country_id) REFERENCES gold.dm_country(country_id),
CONSTRAINT fk_ft_vaccinations_date FOREIGN KEY (date_integer_id) REFERENCES gold.dm_time(date_integer_id));
--
-- Additional indexes for query optimization
CREATE INDEX idx_ft_vaccinations_date ON gold.ft_vaccinations(date_integer_id);
CREATE INDEX idx_ft_vaccinations_country_date_integer ON gold.ft_vaccinations(country_id, date_integer_id);