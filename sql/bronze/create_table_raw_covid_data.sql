/*

Author: Augusto Rosa

Source: Our World in Data Covid 19 - Blob Storage

Description: Bronze layer create table script

Language Used: SQL

*/
--
CREATE SCHEMA bronze;
GO
DROP TABLE IF EXISTS bronze.covid19data_Bronze
GO
CREATE TABLE bronze.covid19data_Bronze (
    total_cases INT,
    new_cases INT,
    new_cases_smoothed FLOAT,
    total_cases_per_million FLOAT,
    new_cases_per_million FLOAT,
    new_cases_smoothed_per_million FLOAT,
    total_deaths INT,
    new_deaths INT,
    new_deaths_smoothed FLOAT,
    total_deaths_per_million FLOAT,
    new_deaths_per_million FLOAT,
    new_deaths_smoothed_per_million FLOAT,
    excess_mortality FLOAT,
    excess_mortality_cumulative FLOAT,
    excess_mortality_cumulative_absolute FLOAT,
    excess_mortality_cumulative_per_million FLOAT,
    hosp_patients INT,
    hosp_patients_per_million FLOAT,
    weekly_hosp_admissions INT,
    weekly_hosp_admissions_per_million FLOAT,
    icu_patients INT,
    icu_patients_per_million FLOAT,
    weekly_icu_admissions INT,
    weekly_icu_admissions_per_million FLOAT,
    stringency_index FLOAT,
    reproduction_rate FLOAT,
    total_tests BIGINT,
    new_tests INT,
    total_tests_per_thousand FLOAT,
    new_tests_per_thousand FLOAT,
    new_tests_smoothed INT,
    new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
    tests_per_case FLOAT,
    total_vaccinations FLOAT,
    people_vaccinated FLOAT,
    people_fully_vaccinated FLOAT,
    total_boosters BIGINT,
    new_vaccinations FLOAT,
    new_vaccinations_smoothed FLOAT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
    total_boosters_per_hundred FLOAT,
    new_vaccinations_smoothed_per_million FLOAT,
    new_people_vaccinated_smoothed FLOAT,
    new_people_vaccinated_smoothed_per_hundred FLOAT,
    code VARCHAR(50),
    continent VARCHAR(100),
    population BIGINT,
    population_density FLOAT,
    median_age FLOAT,
    life_expectancy FLOAT,
    gdp_per_capita FLOAT,
    extreme_poverty FLOAT,
    diabetes_prevalence FLOAT,
    handwashing_facilities FLOAT,
    hospital_beds_per_thousand FLOAT,
    human_development_index FLOAT,
	country VARCHAR(100),
	date DATETIME,
    dt_insert DATETIME DEFAULT GETDATE() -- insertion date
);