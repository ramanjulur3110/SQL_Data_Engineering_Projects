-- Count Rows - Aggregation Only
select count(*) from job_postings_fact;


-- Count Rows - Window Function
select *, count(*) over() from job_postings_fact;
 

-- PARTITION BY - Find hourly sourly

select 
    job_id, 
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(PARTITION BY job_title_short) as salary_hour_avg_by_job_title
from job_postings_fact;

-- ORDER BY -Ranking Hourly Salary

SELECT
    job_id, 
    job_title_short, 
    salary_hour_avg, 
    RANK() OVER (partition by job_title_short order by salary_hour_avg DESC)
FROM job_postings_fact
where salary_hour_avg is not NULL
ORDER BY salary_hour_avg DESC
LIMIT 10;

-- PARTITION BY & ORDER BY - Running Average Hourly Salary

select
    job_posted_date, 
    job_title_short, 
    salary_hour_avg, 
    AVG(salary_hour_avg) over (partition by job_title_short order by job_posted_date)
from job_postings_fact
where salary_hour_avg is NOT NULL
and job_title_short = 'Data Engineer'
order by job_title_short, job_posted_date;

-- LAG() - Time Based Comparison of Company Yearly Salary

select *, LAG(job_title_salary_year_avg) OVER (partition by company_id, job_title_short) as previous_year_job_title_avg_salary,
job_title_salary_year_avg - LAG(job_title_salary_year_avg) OVER (partition by company_id, job_title_short) year_over_year_salary_change_by_position
from 
    (
    SELECT
        company_id, 
        job_title_short, 
        EXTRACT(YEAR from job_posted_date) as job_posting_year,
        MEDIAN(salary_year_avg) as job_title_salary_year_avg
    from job_postings_fact
    where salary_year_avg is NOT NULL
    group by company_id, job_title_short, EXTRACT(YEAR from job_posted_date)
    order by company_id, job_title_short, job_posting_year
    ) as subquery
ORDER BY company_id, job_title_short, job_posting_year ASC
LIMIT 150;


select count(job_id), job_title_short, company_id from job_postings_fact
where salary_year_avg is NOT NULL
group by job_title_short, company_id
order by company_id, count(job_id);