--Step 2. Load date from .CSVs into recently created tables. 

SELECT '=== Loading company_dim Table ===' as info;

INSERT INTO company_dim (company_id, name, link, link_google, thumbnail)
    SELECT company_id, name, link, link_google, thumbnail
    FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv', AUTO_DETECT=true);

SELECT '=== Loading skills_dim Table ===' as info;

INSERT INTO skills_dim (skill_id, skills, type)
    SELECT skill_id, skills, type
    FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv', AUTO_DETECT=true);

SELECT '=== Loading job_postings_fact Table ===' as info;

INSERT INTO job_postings_fact (
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
    SELECT 
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
    FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv', AUTO_DETECT=true);

SELECT '=== Loading skill_job_dim Table ===' as info;

INSERT INTO skills_job_dim (skill_id, job_id)
    SELECT skill_id, job_id 
    FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv', AUTO_DETECT=true);


--DATA VALIDATION--
-- Verify data was loaded correctly
SELECT 'Company Dim' as table_name, COUNT(*) as record_count from company_dim
UNION ALL
SELECT 'Skills Dim', COUNT(*) from skills_dim
UNION ALL
SELECT 'Job Postings Fact', COUNT(*) from job_postings_fact
UNION ALL
SELECT 'Skills Job Dim', COUNT(*) from skills_job_dim;

-- Show sample data
SELECT '=== Company Dimension Sample ===' AS info;
SELECT * FROM company_dim LIMIT 5;

SELECT '=== Skills Dimension Sample ===' AS info;
SELECT * FROM skills_dim LIMIT 5;

SELECT '=== Job Postings Fact Sample ===' AS info;
SELECT * FROM job_postings_fact LIMIT 5;

SELECT '=== Skills Job Dim Sample ===' AS info;
SELECT * FROM skills_job_dim LIMIT 5;