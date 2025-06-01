/*
Author: Augusto Rosa

Source: Synapse (silver.dm_time)

Description: Create gold.dm_time

Language Used: SQL, T-SQL
*/
--
DROP TABLE IF EXISTS gold.dm_time;
--
CREATE TABLE gold.dm_time (
date_integer_id INT NOT NULL,
[date] DATE NOT NULL,
[year] INT NOT NULL,
[quarter] TINYINT NOT NULL,
[month] TINYINT NOT NULL,
[week] TINYINT NOT NULL,
[day] TINYINT NOT NULL,
[weekday] TINYINT,
created_at DATE DEFAULT CAST(GETDATE() AS DATE),
updated_at DATE DEFAULT CAST(GETDATE() AS DATE), 
PRIMARY KEY (date_integer_id),
UNIQUE ([date]))
--
-- Additional indexes for query optimization
CREATE INDEX idx_dm_time_year ON gold.dm_time([year]);
CREATE INDEX idx_dm_time_year_month ON gold.dm_time([year], [month]);
CREATE INDEX idx_dm_time_weekday ON gold.dm_time([weekday]) WHERE [weekday] IS NOT NULL;
