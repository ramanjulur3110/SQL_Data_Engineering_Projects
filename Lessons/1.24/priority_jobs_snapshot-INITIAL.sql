CREATE OR REPLACE TABLE main.priority_jobs_snapshot (
    job_id INT PRIMARY KEY,
    job_title_short VARCHAR,
    company_name VARCHAR,
    job_posting_date TIMESTAMP,
    salary_year_avg DOUBLE, 
    priority_level INT, 
    updated_at TIMESTAMP 
);

INSERT INTO main.priority_jobs_snapshot (job_id, job_title_short, company_name, job_posting_date, salary_year_avg, priority_level, updated_at)
select 
    jpf.job_id,
    jpf.job_title_short, 
    cd.name as company_name,
    jpf.job_posted_date as job_posting_date,
    jpf.salary_year_avg,
    r.priority_level,
    current_timestamp
from data_jobs.job_postings_fact jpf
left join data_jobs.company_dim cd 
    on jpf.company_id = cd.company_id
inner join staging.priority_roles r
    on jpf.job_title_short = r.role_name;

select 
    job_title_short, 
    count(*) as job_count,
    min(priority_level) as min_priority_level,
    min(updated_at) as earliest_at
from main.priority_jobs_snapshot
group by job_title_short
order by job_count desc;
