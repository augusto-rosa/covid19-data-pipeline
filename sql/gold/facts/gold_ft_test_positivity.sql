/*
Author: Augusto Rosa

Source: Synapse (silver.ft_test_positivity)

Description: Create gold.ft_test_positivity - Fact table for COVID-19 test_positivity

Dependencies:
- gold.dm_country
- gold.dm_time

Language Used: SQL, T-SQL
*/
--
DROP TABLE IF EXISTS gold.ft_test_positivity;
--
-- Create the ft_test_positivity table
CREATE TABLE gold.ft_test_positivity (
new_tests BIGINT NULL,
new_tests_per_thousand DECIMAL(10, 2) NULL,
total_tests BIGINT NULL,
total_tests_per_thousand DECIMAL(10, 2) NULL,
new_tests_smoothed DECIMAL(10, 1) NULL,
new_tests_smoothed_per_thousand DECIMAL(10, 2) NULL,
positive_rate DECIMAL(10, 2) NULL,
tests_per_case DECIMAL(10, 1) NULL,
country_id INT NOT NULL,
date_integer_id INT NOT NULL,
insert_date DATE DEFAULT CAST(GETDATE() AS DATE),
PRIMARY KEY (country_id, date_integer_id),
CONSTRAINT fk_ft_test_positivity_country FOREIGN KEY (country_id) REFERENCES gold.dm_country(country_id),
CONSTRAINT fk_ft_test_positivity_date FOREIGN KEY (date_integer_id) REFERENCES gold.dm_time(date_integer_id));
--
-- Additional indexes for query optimization
CREATE INDEX idx_ft_test_positivity_date ON gold.ft_test_positivity(date_integer_id);
CREATE INDEX idx_ft_test_positivity_country_date_integer ON gold.ft_test_positivity(country_id, date_integer_id);