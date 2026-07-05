-- Step 5: Mart - Create priority roles mart

DROP SCHEMA IF EXISTS priority_mart CASCADE;
CREATE SCHEMA priority_mart;

SELECT '=== Loading Roles for Priority Mart ===' as info;
DROP TABLE IF EXISTS priority_mart.priority_roles;
CREATE TABLE priority_mart.priority_roles(
    role_id INT PRIMARY KEY, 
    role_name VARCHAR, 
    priority_level INT
);

INSERT INTO priority_mart.priority_roles (role_id, role_name, priority_level)
VALUES
    (1, 'Data Engineer', 2),
    (2, 'Senior Data Engineer', 1),
    (3, 'Software Engineer', 3);
SELECT * FROM priority_mart.priority_roles;



SELECT '=== Loading Snapshot for Priority Mart ===' as info;
DROP TABLE IF EXISTS priority_mart.priority_jobs_snapshot;
CREATE TABLE priority_mart.priority_jobs_snapshot (
    job_id INT PRIMARY KEY,
    job_title_short VARCHAR,
    company_name VARCHAR,
    job_posting_date TIMESTAMP,
    salary_year_avg DOUBLE, 
    priority_level INT, 
    updated_at TIMESTAMP 
);

INSERT INTO priority_mart.priority_jobs_snapshot (job_id, job_title_short, company_name, job_posting_date, salary_year_avg, priority_level, updated_at)
select 
    jpf.job_id,
    jpf.job_title_short, 
    cd.name as company_name,
    jpf.job_posted_date as job_posting_date,
    jpf.salary_year_avg,
    r.priority_level,
    current_timestamp
from job_postings_fact jpf
left join company_dim cd 
    on jpf.company_id = cd.company_id
inner join priority_mart.priority_roles r
    on jpf.job_title_short = r.role_name;

select 
    job_title_short, 
    count(*) as job_count,
    min(priority_level) as min_priority_level,
    min(updated_at) as earliest_at
from priority_mart.priority_jobs_snapshot
group by job_title_short
order by job_count desc;
