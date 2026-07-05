SELECT 
    table_name, 
    column_name, 
    data_type 
FROM information_schema.columns 
WHERE table_name = 'job_postings_fact';

DESCRIBE job_postings_fact;

SELECT
    job_id::VARCHAR || '_' || company_id::VARCHAR AS unique_job_id, --"more" unique identifier for each job posting
    job_work_from_home::INT AS job_work_from_home, -- from boolean to int for easier analysis
    job_posted_date::DATE AS job_posted_date, -- from timestamp to date for easier analysis
    salary_year_avg::DECIMAL(10, 2) AS salary_year_avg -- from double to decimal for easier analysis
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;