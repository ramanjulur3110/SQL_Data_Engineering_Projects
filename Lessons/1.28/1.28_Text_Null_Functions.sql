SELECT LENGTH('SQL');

SELECT LOWER('SQL');

SELECT UPPER('SQL');

SELECT LEFT('SQL', 2);

SELECT RIGHT('SQL', 2);

SELECT SUBSTRING('RAKESH', 2, 2);

SELECT CONCAT ('Rakesh', ' ', 'Ramanjulu');

SELECT TRIM(' SQL ');

SELECT NULLIF(10, 20);

SELECT
    salary_year_avg,
    salary_hour_avg
FROM 
    job_postings_fact;