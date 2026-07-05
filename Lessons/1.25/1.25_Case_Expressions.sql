--Bucket Salaries
-- < 25 = 'Low'
-- 25-50 = 'Medium'
-- ? 50 = 'High'

select 
    job_title_short, 
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg > 50 THEN 'High'
        WHEN salary_hour_avg >= 25 THEN 'Medium'
        ELSE 'Low'
    END as 'Bucket_Salaries'
from job_postings_fact
where salary_hour_avg not NULL
LIMIT 10;

-- Handling Missing Data (Nulls)
-- Filter Null salary values

select 
    job_title_short, 
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg IS NULL THEN 'Missing'
        WHEN salary_hour_avg > 50 THEN 'High'
        WHEN salary_hour_avg >= 25 THEN 'Medium'
        ELSE 'Low'
    END as 'Bucket_Salaries'
from job_postings_fact
LIMIT 10;

-- Categorizing Categorical Values
-- Classify the 'job_title' column as:
    -- 'Data Analyst'
    -- 'Data Engineer'
    -- 'Data Scientist'

